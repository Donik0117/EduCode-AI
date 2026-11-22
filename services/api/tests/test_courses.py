from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_courses_endpoint_returns_seeded_courses() -> None:
    response = client.get("/api/v1/courses")

    assert response.status_code == 200
    courses = response.json()
    assert len(courses) >= 5
    assert courses[0]["slug"] == "python-foundations"


def test_courses_endpoint_filters_by_level() -> None:
    response = client.get("/api/v1/courses", params={"level": "beginner"})

    assert response.status_code == 200
    assert all(course["level"] == "beginner" for course in response.json())


def test_course_endpoint_returns_404_for_unknown_course() -> None:
    response = client.get("/api/v1/courses/not-a-real-course")

    assert response.status_code == 404
