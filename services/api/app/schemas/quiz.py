from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field


class QuizQuestionRead(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    prompt: str
    options: list[str]
    points: int
    position: int


class QuizListItem(BaseModel):
    id: str
    module_id: str
    title: str
    description: str
    duration_minutes: int
    questions_count: int


class QuizRead(QuizListItem):
    questions: list[QuizQuestionRead]


class QuizSubmitRequest(BaseModel):
    answers: dict[str, str] = Field(default_factory=dict)


class QuizQuestionResult(BaseModel):
    question_id: str
    prompt: str
    selected_answer: str | None
    correct_answer: str
    is_correct: bool
    explanation: str
    points_awarded: int
    points_possible: int


class QuizResult(BaseModel):
    id: str
    quiz_id: str
    quiz_title: str
    score: int
    total_points: int
    correct_answers: int
    question_count: int
    percentage: float
    submitted_at: datetime
    question_results: list[QuizQuestionResult]


class QuizAttemptRead(BaseModel):
    id: str
    quiz_id: str
    score: int
    total_points: int
    correct_answers: int
    question_count: int
    submitted_at: datetime
    percentage: float
