from fastapi import FastAPI
import app.models
from app.api.v1.users import router as users_router
from app.api.v1.auth import router as auth_router
from app.api.v1.groups import router as groups_router
from app.api.v1.group_members import router as group_members_router
from app.api.v1.expenses import router as expenses_router
from app.api.v1.balances import router as balances_router
from app.api.v1.settlements import router as settlement_router
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="FairSplit API",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register routers
app.include_router(auth_router)
app.include_router(users_router)
app.include_router(groups_router)
app.include_router(group_members_router)
app.include_router(expenses_router)
app.include_router(balances_router)
app.include_router(settlement_router)

@app.get("/")
async def root():
    return {
        "message": "FairSplit Backend Running 🚀"
    }


@app.get("/health")
async def health():
    return {
        "status": "healthy"
    }