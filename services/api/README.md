# EduCode AI API

FastAPI backend service.

## Local development

```bash
python -m venv .venv
pip install -r requirements.txt
uvicorn app.main:app --reload
```

OpenAPI: http://127.0.0.1:8000/docs

## Tests

```bash
pip install pytest httpx
pytest -q
```
