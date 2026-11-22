"""Add per-user lesson completion progress.

Revision ID: 0003_user_lesson_progress
Revises: 0002_learning_content
Create Date: 2026-11-22
"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = "0003_user_lesson_progress"
down_revision: Union[str, None] = "0002_learning_content"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "user_lesson_progress",
        sa.Column("id", sa.String(length=36), nullable=False),
        sa.Column("user_id", sa.String(length=36), nullable=False),
        sa.Column("lesson_id", sa.String(length=36), nullable=False),
        sa.Column("is_completed", sa.Boolean(), server_default=sa.false(), nullable=False),
        sa.Column("completed_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"], ondelete="CASCADE"),
        sa.ForeignKeyConstraint(["lesson_id"], ["lessons.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("user_id", "lesson_id", name="uq_user_lesson_progress_user_lesson"),
    )
    op.create_index("ix_user_lesson_progress_user_id", "user_lesson_progress", ["user_id"])
    op.create_index("ix_user_lesson_progress_lesson_id", "user_lesson_progress", ["lesson_id"])


def downgrade() -> None:
    op.drop_index("ix_user_lesson_progress_lesson_id", table_name="user_lesson_progress")
    op.drop_index("ix_user_lesson_progress_user_id", table_name="user_lesson_progress")
    op.drop_table("user_lesson_progress")
