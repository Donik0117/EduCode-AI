from fastapi import APIRouter

from app.api.v1.endpoints.courses import router as courses_router

api_router = APIRouter()
api_router.include_router(courses_router)
