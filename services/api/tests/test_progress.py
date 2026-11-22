from fastapi.testclient import TestClient


def _register_student(client: TestClient, email: str) -> str:
    response = client.post(
        "/api/v1/auth/register",
        json={
            "email": email,
            "password": "StrongPassword123!",
            "full_name": "Progress Student",
        },
    )
    assert response.status_code == 201
    return response.json()["access_token"]


def test_progress_requires_authentication(client: TestClient) -> None:
    response = client.get("/api/v1/progress/me")
    assert response.status_code == 401


def test_student_can_complete_lesson_and_read_summary(
    client: TestClient,
) -> None:
    token = _register_student(client, "progress@example.com")
    headers = {"Authorization": f"Bearer {token}"}

    response = client.post(
        "/api/v1/progress/lessons/lesson-python-variables/complete",
        headers=headers,
    )
    assert response.status_code == 200
    progress = response.json()
    assert progress["lesson_id"] == "lesson-python-variables"
    assert progress["is_completed"] is True
    assert progress["completed_at"] is not None

    summary = client.get("/api/v1/progress/me", headers=headers)
    assert summary.status_code == 200
    data = summary.json()
    assert data["completed_lesson_count"] == 1
    assert data["completed_course_count"] == 0
    assert data["completed_lesson_ids"] == ["lesson-python-variables"]


def test_completing_same_lesson_is_idempotent(client: TestClient) -> None:
    token = _register_student(client, "idempotent@example.com")
    headers = {"Authorization": f"Bearer {token}"}
    path = "/api/v1/progress/lessons/lesson-python-variables/complete"

    first = client.post(path, headers=headers)
    second = client.post(path, headers=headers)

    assert first.status_code == 200
    assert second.status_code == 200
    assert first.json()["id"] == second.json()["id"]

    summary = client.get("/api/v1/progress/me", headers=headers)
    assert summary.json()["completed_lesson_count"] == 1


def test_completing_all_course_lessons_marks_course_complete(
    client: TestClient,
) -> None:
    token = _register_student(client, "course-progress@example.com")
    headers = {"Authorization": f"Bearer {token}"}

    for lesson_id in [
        "lesson-python-variables",
        "lesson-python-conditions",
    ]:
        response = client.post(
            f"/api/v1/progress/lessons/{lesson_id}/complete",
            headers=headers,
        )
        assert response.status_code == 200

    summary = client.get("/api/v1/progress/me", headers=headers)
    assert summary.status_code == 200
    assert summary.json()["completed_lesson_count"] == 2
    assert summary.json()["completed_course_count"] == 1


def test_student_cannot_complete_unknown_lesson(client: TestClient) -> None:
    token = _register_student(client, "unknown-lesson@example.com")
    response = client.post(
        "/api/v1/progress/lessons/not-a-real-lesson/complete",
        headers={"Authorization": f"Bearer {token}"},
    )
    assert response.status_code == 404
