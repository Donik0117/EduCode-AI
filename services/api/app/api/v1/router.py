from fastapi import APIRouter

from app.api.v1.endpoints.auth import router as auth_router
from app.api.v1.endpoints.courses import router as courses_router
from app.api.v1.endpoints.progress import router as progress_router
from app.api.v1.endpoints.quizzes import router as quizzes_router

api_router = APIRouter()
api_router.include_router(auth_router)
api_router.include_router(courses_router)
api_router.include_router(progress_router)
api_router.include_router(quizzes_router)
