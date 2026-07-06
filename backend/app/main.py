from fastapi import FastAPI

app = FastAPI(
    title="FairSplit API",
    version="1.0.0",
)

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