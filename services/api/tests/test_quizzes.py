from fastapi.testclient import TestClient


def _register_student(client: TestClient, email: str) -> str:
    response = client.post(
        "/api/v1/auth/register",
        json={"email": email, "password": "StrongPassword123!"},
    )
    assert response.status_code == 201
    return response.json()["access_token"]


def test_quiz_catalog_does_not_expose_correct_answers(client: TestClient) -> None:
    response = client.get("/api/v1/quizzes")

    assert response.status_code == 200
    quizzes = response.json()
    assert len(quizzes) == 1
    assert quizzes[0]["id"] == "quiz-python-basics"
    assert quizzes[0]["questions_count"] == 3

    detail = client.get("/api/v1/quizzes/quiz-python-basics")
    assert detail.status_code == 200
    assert len(detail.json()["questions"]) == 3
    assert "correct_answer" not in detail.json()["questions"][0]


def test_quiz_submission_is_graded_and_attempt_is_saved(
    client: TestClient,
) -> None:
    token = _register_student(client, "quiz-student@example.com")
    headers = {"Authorization": f"Bearer {token}"}
    response = client.post(
        "/api/v1/quizzes/quiz-python-basics/submit",
        headers=headers,
        json={
            "answers": {
                "quiz-python-q1": "int",
                "quiz-python-q2": "True",
                "quiz-python-q3": "if",
            }
        },
    )

    assert response.status_code == 200
    result = response.json()
    assert result["score"] == 3
    assert result["total_points"] == 3
    assert result["correct_answers"] == 3
    assert result["percentage"] == 100.0
    assert all(item["is_correct"] for item in result["question_results"])

    attempts = client.get("/api/v1/quizzes/me/attempts", headers=headers)
    assert attempts.status_code == 200
    assert len(attempts.json()) == 1
    assert attempts.json()[0]["id"] == result["id"]


def test_quiz_submission_handles_wrong_and_missing_answers(
    client: TestClient,
) -> None:
    token = _register_student(client, "quiz-partial@example.com")
    headers = {"Authorization": f"Bearer {token}"}
    response = client.post(
        "/api/v1/quizzes/quiz-python-basics/submit",
        headers=headers,
        json={"answers": {"quiz-python-q1": "float"}},
    )

    assert response.status_code == 200
    result = response.json()
    assert result["score"] == 0
    assert result["correct_answers"] == 0
    assert result["question_count"] == 3
    assert result["percentage"] == 0.0
    assert result["question_results"][1]["selected_answer"] is None


def test_quiz_submission_requires_authentication(client: TestClient) -> None:
    response = client.post(
        "/api/v1/quizzes/quiz-python-basics/submit",
        json={"answers": {}},
    )
    assert response.status_code == 403 or response.status_code == 401


def test_quiz_submission_rejects_questions_from_another_quiz(
    client: TestClient,
) -> None:
    token = _register_student(client, "quiz-invalid@example.com")
    response = client.post(
        "/api/v1/quizzes/quiz-python-basics/submit",
        headers={"Authorization": f"Bearer {token}"},
        json={"answers": {"unknown-question": "anything"}},
    )
    assert response.status_code == 422
