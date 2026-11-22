from datetime import datetime
import uuid

from sqlalchemy import Boolean, DateTime, ForeignKey, String, UniqueConstraint, func
from sqlalchemy.orm import Mapped, mapped_column

from app.db.base import Base


class UserLessonProgress(Base):
    __tablename__ = "user_lesson_progress"
    __table_args__ = (
        UniqueConstraint(
            "user_id",
            "lesson_id",
            name="uq_user_lesson_progress_user_lesson",
        ),
    )

    id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=lambda: str(uuid.uuid4())
    )
    user_id: Mapped[str] = mapped_column(
        ForeignKey("users.id", ondelete="CASCADE"), index=True, nullable=False
    )
    lesson_id: Mapped[str] = mapped_column(
        ForeignKey("lessons.id", ondelete="CASCADE"), index=True, nullable=False
    )
    is_completed: Mapped[bool] = mapped_column(
        Boolean, default=False, nullable=False
    )
    completed_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )
