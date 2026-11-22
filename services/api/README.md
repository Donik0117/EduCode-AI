# EduCode AI API

FastAPI backend: course catalog and student authentication.

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
# Windows:
.venv\\Scripts\\activate
# macOS/Linux:
# source .venv/bin/activate
pip install -r requirements.txt
copy .env.example .env
alembic upgrade head
uvicorn app.main:app --reload
```

API documentation: http://127.0.0.1:8000/docs

## Authentication endpoints

- `POST /api/v1/auth/register` — create a student account and receive an access token.
- `POST /api/v1/auth/login` — validate credentials and receive an access token.
- `GET /api/v1/auth/me` — return the authenticated user's profile (Bearer token required).

Registration and login accept JSON bodies with `email` and `password`. Registration also accepts an optional `full_name`.

## Course endpoints

- `GET /api/v1/courses` — list courses; optional `level` and `search` filters.
- `GET /api/v1/courses/{course_id}` — retrieve a course by ID or slug.

## Tests

```bash
pip install pytest httpx
pytest -q
```

Tests use an isolated in-memory SQLite database. They do not connect to the local PostgreSQL instance.

## Security notes

- Never commit a real `.env` file or production secret.
- Set a unique random `JWT_SECRET_KEY` (at least 32 characters) for production.
- Use HTTPS in deployed environments.
- Access tokens are currently bearer JWTs; refresh-token rotation, email verification, password reset, rate limiting, and account lockout remain planned work.
- Code execution must run in a separately isolated sandbox service, not inside the API process.
