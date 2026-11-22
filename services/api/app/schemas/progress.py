from datetime import datetime

from pydantic import BaseModel, ConfigDict


class LessonProgressRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    lesson_id: str
    is_completed: bool
    completed_at: datetime | None


class ProgressSummary(BaseModel):
    user_id: str
    completed_lesson_count: int
    completed_course_count: int
    completed_lesson_ids: list[str]
