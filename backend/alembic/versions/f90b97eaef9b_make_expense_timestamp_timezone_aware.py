"""make expense timestamp timezone aware

Revision ID: f90b97eaef9b
Revises: ac1ee8320d99
Create Date: 2026-07-15 01:57:25.330970

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = 'f90b97eaef9b'
down_revision: Union[str, Sequence[str], None] = 'ac1ee8320d99'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.execute("""
        ALTER TABLE expenses
        ALTER COLUMN expense_date
        TYPE TIMESTAMP WITH TIME ZONE
        USING expense_date AT TIME ZONE 'UTC'
    """)


def downgrade() -> None:
    op.execute("""
        ALTER TABLE expenses
        ALTER COLUMN expense_date
        TYPE TIMESTAMP
        USING expense_date AT TIME ZONE 'UTC'
    """)