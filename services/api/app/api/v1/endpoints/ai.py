from datetime import datetime, timezone
from uuid import uuid4

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.api.deps import get_current_user
from app.db.session import get_db
from app.models.ai_conversation import AIConversation, AIMessage
from app.models.user import User
from app.schemas.ai import (
    AIChatRequest,
    AIChatResponse,
    AIConversationRead,
    AIConversationSummary,
    AIMessageRead,
)
from app.services import ai_service

router = APIRouter(prefix="/ai", tags=["AI mentor"])


@router.post("/chat", response_model=AIChatResponse)
async def chat_with_mentor(
    payload: AIChatRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> AIChatResponse:
    conversation: AIConversation | None = None
    history: list[dict[str, str]] = []

    if payload.conversation_id is not None:
        conversation = db.scalar(
            select(AIConversation).where(
                AIConversation.id == payload.conversation_id,
                AIConversation.user_id == current_user.id,
            )
        )
        if conversation is None:
            raise HTTPException(status_code=404, detail="Conversation not found")

        previous_messages = db.scalars(
            select(AIMessage)
            .where(AIMessage.conversation_id == conversation.id)
            .order_by(AIMessage.created_at.desc())
            .limit(20)
        ).all()
        history.extend(
            {"role": item.role, "content": item.content}
            for item in reversed(previous_messages)
        )

    history.append({"role": "user", "content": payload.message})

    try:
        reply = await ai_service.generate_chat_completion(
            history=history,
            course_context=payload.course_context,
            lesson_context=payload.lesson_context,
            programming_language=payload.programming_language,
        )
    except ai_service.AIProviderNotConfigured:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="AI Mentor hali sozlanmagan. Server administrator AI API kaliti va modelini sozlashi kerak.",
        ) from None
    except ai_service.AIProviderUnavailable:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail="AI xizmati hozir javob bera olmayapti. Birozdan so‘ng qayta urinib ko‘ring.",
        ) from None

    now = datetime.now(timezone.utc)
    if conversation is None:
        conversation = AIConversation(
            id=str(uuid4()),
            user_id=current_user.id,
            title=payload.message.strip()[:100],
        )
        db.add(conversation)

    conversation.updated_at = now
    user_message = AIMessage(
        id=str(uuid4()),
        conversation_id=conversation.id,
        role="user",
        content=payload.message.strip(),
    )
    assistant_message = AIMessage(
        id=str(uuid4()),
        conversation_id=conversation.id,
        role="assistant",
        content=reply,
    )
    db.add_all([user_message, assistant_message])
    db.commit()
    db.refresh(assistant_message)

    return AIChatResponse(
        conversation_id=conversation.id,
        message_id=assistant_message.id,
        reply=assistant_message.content,
        created_at=assistant_message.created_at,
    )


@router.get(
    "/conversations",
    response_model=list[AIConversationSummary],
)
def list_my_conversations(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> list[AIConversationSummary]:
    conversations = db.scalars(
        select(AIConversation)
        .where(AIConversation.user_id == current_user.id)
        .order_by(AIConversation.updated_at.desc())
        .limit(50)
    ).all()
    return [
        AIConversationSummary.model_validate(conversation)
        for conversation in conversations
    ]


@router.get(
    "/conversations/{conversation_id}",
    response_model=AIConversationRead,
)
def get_my_conversation(
    conversation_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> AIConversationRead:
    conversation = db.scalar(
        select(AIConversation).where(
            AIConversation.id == conversation_id,
            AIConversation.user_id == current_user.id,
        )
    )
    if conversation is None:
        raise HTTPException(status_code=404, detail="Conversation not found")

    messages = db.scalars(
        select(AIMessage)
        .where(AIMessage.conversation_id == conversation.id)
        .order_by(AIMessage.created_at)
    ).all()
    return AIConversationRead(
        id=conversation.id,
        title=conversation.title,
        created_at=conversation.created_at,
        updated_at=conversation.updated_at,
        messages=[
            AIMessageRead.model_validate(message)
            for message in messages
        ],
    )
