from datetime import datetime
from typing import Literal

from pydantic import BaseModel, ConfigDict, Field, field_validator


class AIChatRequest(BaseModel):
    message: str = Field(min_length=1, max_length=4000)
    conversation_id: str | None = Field(default=None, max_length=36)
    course_context: str | None = Field(default=None, max_length=160)
    lesson_context: str | None = Field(default=None, max_length=3000)
    programming_language: str | None = Field(default=None, max_length=40)

    @field_validator("message")
    @classmethod
    def validate_non_blank_message(cls, value: str) -> str:
        cleaned = value.strip()
        if not cleaned:
            raise ValueError("Message cannot be blank")
        return cleaned


class AIChatResponse(BaseModel):
    conversation_id: str
    message_id: str
    reply: str
    created_at: datetime


class AIMessageRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    role: Literal["user", "assistant"]
    content: str
    created_at: datetime


class AIConversationSummary(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    title: str
    created_at: datetime
    updated_at: datetime


class AIConversationRead(AIConversationSummary):
    messages: list[AIMessageRead]
