from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.api.deps import get_current_user
from app.db.session import get_db
from app.models.course import CourseModel, LessonModel, ModuleModel
from app.models.progress import UserLessonProgress
from app.models.user import User
from app.schemas.progress import LessonProgressRead, ProgressSummary

router = APIRouter(prefix="/progress", tags=["learning progress"])


@router.post(
    "/lessons/{lesson_id}/complete",
    response_model=LessonProgressRead,
)
def complete_lesson(
    lesson_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> LessonProgressRead:
    lesson = db.scalar(
        select(LessonModel)
        .join(ModuleModel, LessonModel.module_id == ModuleModel.id)
        .join(CourseModel, ModuleModel.course_id == CourseModel.id)
        .where(
            LessonModel.id == lesson_id,
            LessonModel.is_published.is_(True),
            ModuleModel.is_published.is_(True),
            CourseModel.is_published.is_(True),
        )
    )
    if lesson is None:
        raise HTTPException(status_code=404, detail="Lesson not found")

    progress = db.scalar(
        select(UserLessonProgress).where(
            UserLessonProgress.user_id == current_user.id,
            UserLessonProgress.lesson_id == lesson.id,
        )
    )

    if progress is None:
        progress = UserLessonProgress(
            user_id=current_user.id,
            lesson_id=lesson.id,
            is_completed=True,
            completed_at=datetime.now(timezone.utc),
        )
        db.add(progress)
    elif not progress.is_completed:
        progress.is_completed = True
        progress.completed_at = datetime.now(timezone.utc)

    db.commit()
    db.refresh(progress)
    return LessonProgressRead.model_validate(progress)


@router.get("/me", response_model=ProgressSummary)
def get_my_progress(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> ProgressSummary:
    completed_lesson_ids = list(
        db.scalars(
            select(UserLessonProgress.lesson_id)
            .where(
                UserLessonProgress.user_id == current_user.id,
                UserLessonProgress.is_completed.is_(True),
            )
            .order_by(UserLessonProgress.completed_at)
        ).all()
    )

    completed_course_count = db.scalar(
        select(func.count()).select_from(
            select(CourseModel.id)
            .join(ModuleModel, ModuleModel.course_id == CourseModel.id)
            .join(LessonModel, LessonModel.module_id == ModuleModel.id)
            .outerjoin(
                UserLessonProgress,
                (UserLessonProgress.lesson_id == LessonModel.id)
                & (UserLessonProgress.user_id == current_user.id)
                & (UserLessonProgress.is_completed.is_(True)),
            )
            .where(
                CourseModel.is_published.is_(True),
                ModuleModel.is_published.is_(True),
                LessonModel.is_published.is_(True),
            )
            .group_by(CourseModel.id)
            .having(func.count(LessonModel.id) == func.count(UserLessonProgress.id))
            .subquery()
        )
    ) or 0

    return ProgressSummary(
        user_id=current_user.id,
        completed_lesson_count=len(completed_lesson_ids),
        completed_course_count=completed_course_count,
        completed_lesson_ids=completed_lesson_ids,
    )
