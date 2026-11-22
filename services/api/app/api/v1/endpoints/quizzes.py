from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.api.deps import get_current_user
from app.db.session import get_db
from app.models.course import CourseModel, ModuleModel
from app.models.quiz import (
    QuizAnswerModel,
    QuizAttemptModel,
    QuizModel,
    QuizQuestionModel,
)
from app.models.user import User
from app.schemas.quiz import (
    QuizAttemptRead,
    QuizListItem,
    QuizQuestionRead,
    QuizQuestionResult,
    QuizRead,
    QuizResult,
    QuizSubmitRequest,
)

router = APIRouter(prefix="/quizzes", tags=["quizzes"])


def _get_published_quiz(db: Session, quiz_id: str) -> QuizModel:
    quiz = db.scalar(
        select(QuizModel)
        .join(ModuleModel, QuizModel.module_id == ModuleModel.id)
        .join(CourseModel, ModuleModel.course_id == CourseModel.id)
        .where(
            QuizModel.id == quiz_id,
            QuizModel.is_published.is_(True),
            ModuleModel.is_published.is_(True),
            CourseModel.is_published.is_(True),
        )
    )
    if quiz is None:
        raise HTTPException(status_code=404, detail="Quiz not found")
    return quiz


@router.get("", response_model=list[QuizListItem])
def list_quizzes(
    module_id: str | None = None,
    db: Session = Depends(get_db),
) -> list[QuizListItem]:
    statement = (
        select(QuizModel)
        .join(ModuleModel, QuizModel.module_id == ModuleModel.id)
        .join(CourseModel, ModuleModel.course_id == CourseModel.id)
        .where(
            QuizModel.is_published.is_(True),
            ModuleModel.is_published.is_(True),
            CourseModel.is_published.is_(True),
        )
        .order_by(QuizModel.position)
    )
    if module_id is not None:
        statement = statement.where(QuizModel.module_id == module_id)

    quizzes = db.scalars(statement).all()
    results: list[QuizListItem] = []
    for quiz in quizzes:
        published_questions = [
            question for question in quiz.questions if question.is_published
        ]
        results.append(
            QuizListItem(
                id=quiz.id,
                module_id=quiz.module_id,
                title=quiz.title,
                description=quiz.description,
                duration_minutes=quiz.duration_minutes,
                questions_count=len(published_questions),
            )
        )
    return results


@router.get("/{quiz_id}", response_model=QuizRead)
def get_quiz(
    quiz_id: str,
    db: Session = Depends(get_db),
) -> QuizRead:
    quiz = _get_published_quiz(db, quiz_id)
    questions = [
        QuizQuestionRead.model_validate(question)
        for question in quiz.questions
        if question.is_published
    ]
    return QuizRead(
        id=quiz.id,
        module_id=quiz.module_id,
        title=quiz.title,
        description=quiz.description,
        duration_minutes=quiz.duration_minutes,
        questions_count=len(questions),
        questions=questions,
    )


@router.post("/{quiz_id}/submit", response_model=QuizResult)
def submit_quiz(
    quiz_id: str,
    payload: QuizSubmitRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> QuizResult:
    quiz = _get_published_quiz(db, quiz_id)
    questions = [
        question
        for question in quiz.questions
        if question.is_published
    ]
    if not questions:
        raise HTTPException(status_code=409, detail="Quiz has no published questions")

    question_ids = {question.id for question in questions}
    unknown_ids = set(payload.answers) - question_ids
    if unknown_ids:
        raise HTTPException(
            status_code=422,
            detail="One or more submitted question IDs do not belong to this quiz",
        )

    total_points = sum(question.points for question in questions)
    score = 0
    correct_answers = 0
    question_results: list[QuizQuestionResult] = []

    attempt = QuizAttemptModel(
        quiz_id=quiz.id,
        user_id=current_user.id,
        total_points=total_points,
        question_count=len(questions),
    )
    db.add(attempt)
    db.flush()

    for question in questions:
        selected_answer = payload.answers.get(question.id)
        is_correct = (
            selected_answer is not None
            and selected_answer.strip().casefold()
            == question.correct_answer.strip().casefold()
        )
        awarded = question.points if is_correct else 0
        if is_correct:
            score += awarded
            correct_answers += 1

        db.add(
            QuizAnswerModel(
                attempt_id=attempt.id,
                question_id=question.id,
                selected_answer=selected_answer,
                is_correct=is_correct,
                points_awarded=awarded,
            )
        )
        question_results.append(
            QuizQuestionResult(
                question_id=question.id,
                prompt=question.prompt,
                selected_answer=selected_answer,
                correct_answer=question.correct_answer,
                is_correct=is_correct,
                explanation=question.explanation,
                points_awarded=awarded,
                points_possible=question.points,
            )
        )

    attempt.score = score
    attempt.correct_answers = correct_answers
    db.commit()
    db.refresh(attempt)

    percentage = round((score / total_points) * 100, 2) if total_points else 0.0
    return QuizResult(
        id=attempt.id,
        quiz_id=quiz.id,
        quiz_title=quiz.title,
        score=score,
        total_points=total_points,
        correct_answers=correct_answers,
        question_count=len(questions),
        percentage=percentage,
        submitted_at=attempt.submitted_at,
        question_results=question_results,
    )


@router.get("/me/attempts", response_model=list[QuizAttemptRead])
def list_my_quiz_attempts(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> list[QuizAttemptRead]:
    attempts = db.scalars(
        select(QuizAttemptModel)
        .where(QuizAttemptModel.user_id == current_user.id)
        .order_by(QuizAttemptModel.submitted_at.desc())
    ).all()
    return [
        QuizAttemptRead(
            id=attempt.id,
            quiz_id=attempt.quiz_id,
            score=attempt.score,
            total_points=attempt.total_points,
            correct_answers=attempt.correct_answers,
            question_count=attempt.question_count,
            submitted_at=attempt.submitted_at,
            percentage=(
                round((attempt.score / attempt.total_points) * 100, 2)
                if attempt.total_points
                else 0.0
            ),
        )
        for attempt in attempts
    ]
