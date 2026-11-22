from fastapi.testclient import TestClient

from app.services import ai_service


def _register_student(client: TestClient, email: str) -> str:
    response = client.post(
        "/api/v1/auth/register",
        json={
            "email": email,
            "password": "StrongPassword123!",
            "full_name": "AI Student",
        },
    )
    assert response.status_code == 201
    return response.json()["access_token"]


def test_ai_chat_requires_authentication(client: TestClient) -> None:
    response = client.post(
        "/api/v1/ai/chat",
        json={"message": "Python nima?"},
    )
    assert response.status_code == 401


def test_ai_chat_returns_service_unavailable_without_provider(
    client: TestClient,
    monkeypatch,
) -> None:
    token = _register_student(client, "ai-unconfigured@example.com")
    monkeypatch.setattr(ai_service.settings, "ai_api_key", None)
    monkeypatch.setattr(ai_service.settings, "ai_model", None)

    response = client.post(
        "/api/v1/ai/chat",
        headers={"Authorization": f"Bearer {token}"},
        json={"message": "Python nima?"},
    )

    assert response.status_code == 503
    assert "AI Mentor hali sozlanmagan" in response.json()["detail"]


def test_ai_chat_saves_conversation_and_message_history(
    client: TestClient,
    monkeypatch,
) -> None:
    token = _register_student(client, "ai-history@example.com")
    captured: list[dict] = []

    async def fake_generate_chat_completion(**kwargs):
        captured.append(kwargs)
        return "Python — yuqori darajali dasturlash tili."

    monkeypatch.setattr(
        ai_service,
        "generate_chat_completion",
        fake_generate_chat_completion,
    )
    headers = {"Authorization": f"Bearer {token}"}

    first = client.post(
        "/api/v1/ai/chat",
        headers=headers,
        json={
            "message": "Python nima?",
            "course_context": "Python dasturlash",
            "lesson_context": "O‘zgaruvchilar",
            "programming_language": "Python",
        },
    )

    assert first.status_code == 200
    first_data = first.json()
    assert first_data["reply"] == "Python — yuqori darajali dasturlash tili."
    conversation_id = first_data["conversation_id"]

    second = client.post(
        "/api/v1/ai/chat",
        headers=headers,
        json={
            "message": "Bitta sodda misol ko‘rsating",
            "conversation_id": conversation_id,
        },
    )
    assert second.status_code == 200
    assert len(captured) == 2
    assert captured[1]["history"][0] == {
        "role": "user",
        "content": "Python nima?",
    }
    assert captured[1]["history"][1] == {
        "role": "assistant",
        "content": "Python — yuqori darajali dasturlash tili.",
    }

    conversations = client.get(
        "/api/v1/ai/conversations",
        headers=headers,
    )
    assert conversations.status_code == 200
    assert len(conversations.json()) == 1
    assert conversations.json()[0]["id"] == conversation_id

    detail = client.get(
        f"/api/v1/ai/conversations/{conversation_id}",
        headers=headers,
    )
    assert detail.status_code == 200
    messages = detail.json()["messages"]
    assert [item["role"] for item in messages] == [
        "user",
        "assistant",
        "user",
        "assistant",
    ]
    assert messages[2]["content"] == "Bitta sodda misol ko‘rsating"


def test_ai_conversation_is_private_to_its_owner(
    client: TestClient,
    monkeypatch,
) -> None:
    owner_token = _register_student(client, "ai-owner@example.com")
    other_token = _register_student(client, "ai-other@example.com")

    async def fake_generate_chat_completion(**kwargs):
        return "Salom! Men EduCode AI mentoriman."

    monkeypatch.setattr(
        ai_service,
        "generate_chat_completion",
        fake_generate_chat_completion,
    )

    created = client.post(
        "/api/v1/ai/chat",
        headers={"Authorization": f"Bearer {owner_token}"},
        json={"message": "Salom"},
    )
    assert created.status_code == 200
    conversation_id = created.json()["conversation_id"]

    response = client.get(
        f"/api/v1/ai/conversations/{conversation_id}",
        headers={"Authorization": f"Bearer {other_token}"},
    )
    assert response.status_code == 404


def test_ai_chat_rejects_blank_messages(client: TestClient) -> None:
    token = _register_student(client, "ai-blank@example.com")
    response = client.post(
        "/api/v1/ai/chat",
        headers={"Authorization": f"Bearer {token}"},
        json={"message": "   "},
    )
    assert response.status_code == 422
