from fastapi import APIRouter, HTTPException, Query

from app.data.courses import COURSES
from app.schemas.course import CourseLevel, CourseRead

router = APIRouter(prefix="/courses", tags=["courses"])


@router.get("", response_model=list[CourseRead])
async def list_courses(
    level: CourseLevel | None = Query(default=None),
    search: str | None = Query(default=None, min_length=1, max_length=80),
) -> list[CourseRead]:
    results = COURSES

    if level is not None:
        results = tuple(course for course in results if course["level"] == level)

    if search is not None:
        query = search.casefold()
        results = tuple(
            course
            for course in results
            if query in course["title"].casefold()
            or query in course["category"].casefold()
            or query in course["language"].casefold()
        )

    return [CourseRead.model_validate(course) for course in results]


@router.get("/{course_id}", response_model=CourseRead)
async def get_course(course_id: str) -> CourseRead:
    for course in COURSES:
        if course["id"] == course_id or course["slug"] == course_id:
            return CourseRead.model_validate(course)

    raise HTTPException(status_code=404, detail="Course not found")
