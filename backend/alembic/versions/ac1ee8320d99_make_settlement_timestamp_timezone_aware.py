"""make settlement timestamp timezone aware

Revision ID: ac1ee8320d99
Revises: 8124a023ac40
Create Date: 2026-07-15 01:25:39.561564

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = 'ac1ee8320d99'
down_revision: Union[str, Sequence[str], None] = '8124a023ac40'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.execute("""
        ALTER TABLE settlement_history
        ALTER COLUMN settled_at
        TYPE TIMESTAMP WITH TIME ZONE
        USING settled_at AT TIME ZONE 'UTC'
    """)


def downgrade() -> None:
    op.execute("""
        ALTER TABLE settlement_history
        ALTER COLUMN settled_at
        TYPE TIMESTAMP
        USING settled_at AT TIME ZONE 'UTC'
    """)
