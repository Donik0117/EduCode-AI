# EduCode AI API

FastAPI backend: authentication, course content and student learning progress.

## Stack
- FastAPI + Pydantic
- SQLAlchemy 2
- PostgreSQL + Psycopg 3
- Alembic migrations
- JWT access tokens (HS256)
- Argon2 password hashing

## Local development

Start PostgreSQL from the repository root:

```bash
docker compose up -d db
```

Then from this directory:

```bash
python -m venv .venv
# Windows PowerShell:
.venv\Scripts\Activate.ps1
# macOS/Linux:
# source .venv/bin/activate
pip install -r requirements.txt
# Windows PowerShell:
Copy-Item .env.example .env
# macOS/Linux:
# cp .env.example .env

alembic upgrade head
python -m app.seed
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

OpenAPI documentation: http://127.0.0.1:8000/docs

`python -m app.seed` inserts six starter courses, their first modules, twelve starter lessons and a Python fundamentals quiz with three questions. It is safe to run again; existing catalog and quiz data are not duplicated.

## Authentication endpoints

All authentication routes use JSON.

- `POST /api/v1/auth/register` — create a student account and return an access token.
- `POST /api/v1/auth/login` — verify credentials and return an access token.
- `GET /api/v1/auth/me` — return the authenticated user's profile.

Registration accepts `email`, `password` and optional `full_name`. Passwords must contain at least eight characters. Password hashes are not returned by the API.

## Course and lesson endpoints

- `GET /api/v1/courses` — list published courses. Optional filters: `level`, `search`.
- `GET /api/v1/courses/{course_id}` — retrieve a course by UUID or slug.
- `GET /api/v1/courses/{course_id}/modules` — retrieve the course modules.
- `GET /api/v1/courses/modules/{module_id}/lessons` — retrieve module lessons.
- `GET /api/v1/courses/lessons/{lesson_id}` — retrieve full lesson text and code example.

## Quiz endpoints

- `GET /api/v1/quizzes` — list published quizzes.
- `GET /api/v1/quizzes/{quiz_id}` — return quiz questions and answer options without revealing correct answers.
- `POST /api/v1/quizzes/{quiz_id}/submit` — submit answers; the server grades them and returns explanations and the score. Authentication required.
- `GET /api/v1/quizzes/me/attempts` — return the current user's previous quiz attempts. Authentication required.

Correct answers are never included in the quiz detail endpoint; they are returned only after submission.

## Learning progress endpoints

These routes require a Bearer access token.

- `POST /api/v1/progress/lessons/{lesson_id}/complete` — mark a published lesson as completed. The operation is idempotent.
- `GET /api/v1/progress/me` — return completed lesson IDs, completed lesson count and fully completed course count for the current user.

## Tests

```bash
pip install pytest httpx
pytest -q
```

Tests use an isolated in-memory SQLite database, create all SQLAlchemy models and seed the starter learning catalog. They do not connect to the local PostgreSQL instance.

## Security notes

- Never commit a real `.env` file or production secret.
- Set a unique random `JWT_SECRET_KEY` (at least 32 characters) for production.
- Use HTTPS in deployed environments.
- Current access tokens are bearer JWTs. Refresh-token rotation, email verification, password reset, rate limiting and account lockout remain planned work.
- Code execution must run in a separately isolated sandbox service, not inside the API process.
