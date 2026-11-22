from typing import Literal

from pydantic import BaseModel, ConfigDict, Field


CourseLevel = Literal["beginner", "intermediate", "advanced"]


class CourseRead(BaseModel):
    model_config = ConfigDict(extra="forbid")

    id: str
    slug: str
    title: str
    description: str
    category: str
    level: CourseLevel
    language: str
    lessons_count: int = Field(ge=1)
    estimated_hours: int = Field(ge=1)
