from fastapi.testclient import TestClient


def test_courses_endpoint_returns_seeded_courses(client: TestClient) -> None:
    response = client.get("/api/v1/courses")

    assert response.status_code == 200
    courses = response.json()
    assert len(courses) == 6
    assert courses[0]["slug"] == "python-foundations"


def test_courses_endpoint_filters_by_level(client: TestClient) -> None:
    response = client.get("/api/v1/courses", params={"level": "beginner"})

    assert response.status_code == 200
    courses = response.json()
    assert len(courses) == 3
    assert all(course["level"] == "beginner" for course in courses)


def test_courses_endpoint_searches_title_language_and_category(
    client: TestClient,
) -> None:
    response = client.get("/api/v1/courses", params={"search": "sql"})

    assert response.status_code == 200
    assert len(response.json()) == 1
    assert response.json()[0]["slug"] == "sql-databases"


def test_course_detail_and_module_list(client: TestClient) -> None:
    course_response = client.get("/api/v1/courses/python-foundations")
    assert course_response.status_code == 200
    assert course_response.json()["title"] == "Python dasturlash"

    modules_response = client.get(
        "/api/v1/courses/python-foundations/modules"
    )
    assert modules_response.status_code == 200
    modules = modules_response.json()
    assert len(modules) == 1
    assert modules[0]["lessons_count"] == 2


def test_module_lessons_and_lesson_content(client: TestClient) -> None:
    response = client.get(
        "/api/v1/courses/modules/module-python-core/lessons"
    )
    assert response.status_code == 200
    lessons = response.json()
    assert len(lessons) == 2
    assert lessons[0]["title"] == "O‘zgaruvchilar va ma’lumot turlari"

    detail = client.get(
        "/api/v1/courses/lessons/lesson-python-variables"
    )
    assert detail.status_code == 200
    assert "O‘zgaruvchilar" in detail.json()["content"]
    assert "print" in detail.json()["code_example"]


def test_unknown_course_module_and_lesson_return_404(
    client: TestClient,
) -> None:
    assert client.get("/api/v1/courses/not-a-real-course").status_code == 404
    assert (
        client.get("/api/v1/courses/modules/not-a-module/lessons").status_code
        == 404
    )
    assert (
        client.get("/api/v1/courses/lessons/not-a-lesson").status_code == 404
    )
