from fastapi import FastAPI
import app.models
from app.api.v1.users import router as users_router
from app.api.v1.auth import router as auth_router
from app.api.v1.groups import router as groups_router

app = FastAPI(
    title="FairSplit API",
    version="1.0.0",
)

# Register routers
app.include_router(auth_router)
app.include_router(users_router)
app.include_router(groups_router)

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