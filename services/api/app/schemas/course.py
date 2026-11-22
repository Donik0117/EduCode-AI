from typing import Literal

from pydantic import BaseModel, ConfigDict, Field


CourseLevel = Literal["beginner", "intermediate", "advanced"]


class CourseRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    slug: str
    title: str
    description: str
    category: str
    level: CourseLevel
    language: str
    lessons_count: int = Field(ge=0)
    estimated_hours: int = Field(ge=1)


class ModuleRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    course_id: str
    title: str
    description: str
    position: int
    lessons_count: int


class LessonRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    module_id: str
    title: str
    summary: str
    language: str
    duration_minutes: int
    position: int


class LessonDetail(LessonRead):
    content: str
    code_example: str | None
