import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

from app.db.base import Base
from app.db.session import get_db
from app.main import app
from app.models.user import User  # noqa: F401


@pytest.fixture
def client():
    test_engine = create_engine(
        "sqlite://",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    TestingSessionLocal = sessionmaker(
        bind=test_engine,
        autoflush=False,
        autocommit=False,
        expire_on_commit=False,
    )
    Base.metadata.create_all(bind=test_engine)

    def override_get_db():
        db = TestingSessionLocal()
        try:
            yield db
        finally:
            db.close()

    app.dependency_overrides[get_db] = override_get_db
    with TestClient(app) as test_client:
        yield test_client

    app.dependency_overrides.clear()
    Base.metadata.drop_all(bind=test_engine)
    test_engine.dispose()


def test_register_login_and_me(client: TestClient) -> None:
    response = client.post(
        "/api/v1/auth/register",
        json={
            "email": " Student@Example.com ",
            "password": "StrongPassword123!",
            "full_name": "Test Student",
        },
    )

    assert response.status_code == 201
    data = response.json()
    assert data["token_type"] == "bearer"
    assert data["user"]["email"] == "student@example.com"
    assert "password_hash" not in data["user"]

    token = data["access_token"]
    me_response = client.get(
        "/api/v1/auth/me",
        headers={"Authorization": f"Bearer {token}"},
    )
    assert me_response.status_code == 200
    assert me_response.json()["full_name"] == "Test Student"

    login_response = client.post(
        "/api/v1/auth/login",
        json={"email": "student@example.com", "password": "StrongPassword123!"},
    )
    assert login_response.status_code == 200
    assert login_response.json()["user"]["id"] == data["user"]["id"]


def test_register_rejects_duplicate_email(client: TestClient) -> None:
    payload = {"email": "duplicate@example.com", "password": "StrongPassword123!"}
    assert client.post("/api/v1/auth/register", json=payload).status_code == 201
    duplicate = client.post("/api/v1/auth/register", json=payload)
    assert duplicate.status_code == 409


def test_login_rejects_invalid_password(client: TestClient) -> None:
    client.post(
        "/api/v1/auth/register",
        json={"email": "login@example.com", "password": "StrongPassword123!"},
    )
    response = client.post(
        "/api/v1/auth/login",
        json={"email": "login@example.com", "password": "WrongPassword123!"},
    )
    assert response.status_code == 401


def test_me_requires_bearer_token(client: TestClient) -> None:
    response = client.get("/api/v1/auth/me")
    assert response.status_code == 401


def test_register_rejects_short_password(client: TestClient) -> None:
    response = client.post(
        "/api/v1/auth/register",
        json={"email": "short@example.com", "password": "123"},
    )
    assert response.status_code == 422
