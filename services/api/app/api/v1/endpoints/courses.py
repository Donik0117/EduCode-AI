from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import func, or_, select
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.models.course import CourseModel, LessonModel, ModuleModel
from app.schemas.course import (
    CourseLevel,
    CourseRead,
    LessonDetail,
    LessonRead,
    ModuleRead,
)

router = APIRouter(prefix="/courses", tags=["learning content"])


def _get_course(db: Session, course_id: str) -> CourseModel:
    course = db.scalar(
        select(CourseModel).where(
            or_(CourseModel.id == course_id, CourseModel.slug == course_id)
        )
    )
    if course is None or not course.is_published:
        raise HTTPException(status_code=404, detail="Course not found")
    return course


@router.get("", response_model=list[CourseRead])
def list_courses(
    level: CourseLevel | None = Query(default=None),
    search: str | None = Query(default=None, min_length=1, max_length=80),
    db: Session = Depends(get_db),
) -> list[CourseRead]:
    statement = select(CourseModel).where(CourseModel.is_published.is_(True))

    if level is not None:
        statement = statement.where(CourseModel.level == level)

    if search is not None:
        query = f"%{search.strip().casefold()}%"
        statement = statement.where(
            or_(
                func.lower(CourseModel.title).like(query),
                func.lower(CourseModel.category).like(query),
                func.lower(CourseModel.language).like(query),
            )
        )

    courses = db.scalars(statement.order_by(CourseModel.position)).all()
    return [CourseRead.model_validate(course) for course in courses]


@router.get("/{course_id}/modules", response_model=list[ModuleRead])
def list_course_modules(
    course_id: str,
    db: Session = Depends(get_db),
) -> list[ModuleRead]:
    course = _get_course(db, course_id)
    modules = db.scalars(
        select(ModuleModel)
        .where(
            ModuleModel.course_id == course.id,
            ModuleModel.is_published.is_(True),
        )
        .order_by(ModuleModel.position)
    ).all()

    return [
        ModuleRead(
            id=module.id,
            course_id=module.course_id,
            title=module.title,
            description=module.description,
            position=module.position,
            lessons_count=db.scalar(
                select(func.count(LessonModel.id)).where(
                    LessonModel.module_id == module.id,
                    LessonModel.is_published.is_(True),
                )
            )
            or 0,
        )
        for module in modules
    ]


@router.get(
    "/modules/{module_id}/lessons",
    response_model=list[LessonRead],
)
def list_module_lessons(
    module_id: str,
    db: Session = Depends(get_db),
) -> list[LessonRead]:
    module = db.get(ModuleModel, module_id)
    if module is None or not module.is_published:
        raise HTTPException(status_code=404, detail="Module not found")

    lessons = db.scalars(
        select(LessonModel)
        .where(
            LessonModel.module_id == module_id,
            LessonModel.is_published.is_(True),
        )
        .order_by(LessonModel.position)
    ).all()
    return [LessonRead.model_validate(lesson) for lesson in lessons]


@router.get("/lessons/{lesson_id}", response_model=LessonDetail)
def get_lesson(
    lesson_id: str,
    db: Session = Depends(get_db),
) -> LessonDetail:
    lesson = db.get(LessonModel, lesson_id)
    if lesson is None or not lesson.is_published:
        raise HTTPException(status_code=404, detail="Lesson not found")
    return LessonDetail.model_validate(lesson)


@router.get("/{course_id}", response_model=CourseRead)
def get_course(
    course_id: str,
    db: Session = Depends(get_db),
) -> CourseRead:
    return CourseRead.model_validate(_get_course(db, course_id))
