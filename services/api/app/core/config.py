from pydantic import Field, model_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "EduCode AI API"
    app_env: str = "development"
    api_v1_prefix: str = "/api/v1"
    database_url: str = "postgresql+psycopg://postgres:postgres@localhost:5432/educode_ai"
    jwt_secret_key: str = "local-development-only-secret-change-before-deployment"
    jwt_algorithm: str = "HS256"
    access_token_expire_minutes: int = Field(default=1440, ge=5, le=10080)
    cors_origins: list[str] = [
        "http://localhost:3000",
        "http://localhost:8080",
        "http://localhost:5173",
        "http://localhost:7357",
    ]
    ai_api_key: str | None = None
    ai_base_url: str = "https://api.openai.com/v1"
    ai_model: str | None = None
    ai_timeout_seconds: int = Field(default=45, ge=5, le=120)

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    @model_validator(mode="after")
    def validate_production_secrets(self) -> "Settings":
        if self.app_env == "production":
            if len(self.jwt_secret_key) < 32:
                raise ValueError("JWT_SECRET_KEY must contain at least 32 characters")
            if self.jwt_secret_key.startswith(
                ("local-development", "replace-", "changeme")
            ):
                raise ValueError("Set a unique JWT_SECRET_KEY in production")
        return self


settings = Settings()
