# EduCode AI

**Learn. Code. Solve. Build. Grow.**

Sun’iy intellekt texnologiyalari asosida dasturlashni o‘rgatishga mo‘ljallangan mobil ta’lim platformasi.

## BMI mavzusi
**Sun’iy intellekt texnologiyalari asosida dasturlashni o‘rgatishga mo‘ljallangan mobil ta’lim platformasini ishlab chiqish.**

## Arxitektura
- `apps/mobile` — Flutter mobil ilovasi (Dart, Riverpod, feature-first).
- `services/api` — FastAPI backend.
- PostgreSQL — foydalanuvchilar, kurslar, darslar va o‘quv progressi.
- Alembic — database migratsiyalari.
- `docs` — loyiha va BMI texnik hujjatlari.
- `.github/workflows` — CI tekshiruvlari.

## Hozir mavjud funksiyalar

### Mobil ilova
- Email/parol orqali ro‘yxatdan o‘tish va kirish.
- JWT access tokenni qurilmaning secure storage joyida saqlash.
- Bosh sahifa, kurslar, amaliyot va profil navigatsiyasi.
- API orqali kurslarni ko‘rish, qidirish va daraja bo‘yicha filtrlash.
- Kurs modullari va darslarini ochish.
- Dars matni va kod misollarini ko‘rish.
- Darsni tugatish va progressni serverga saqlash.
- Profil va hisobdan chiqish.

### Backend
- JWT bearer autentifikatsiya va Argon2 parol xeshlash.
- Foydalanuvchi profili endpointi.
- PostgreSQL kurs/modul/dars modeli va Alembic migratsiyalari.
- Olti namuna kurs va o‘n ikki boshlang‘ich dars.
- Kurslar, modullar va darslar API.
- Darsni yakunlash va foydalanuvchi progressini ko‘rish API.

## Backendni ishga tushirish

Python 3.11+, Docker va Docker Compose talab qilinadi.

```bash
# Repository ildizida PostgreSQLni ishga tushiring
docker compose up -d db

cd services/api
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

API hujjatlari: http://127.0.0.1:8000/docs

Production muhitida `JWT_SECRET_KEY` qiymatini tasodifiy, maxfiy va kamida 32 belgidan iborat qiymatga almashtiring. Haqiqiy `.env` faylini Git'ga joylamang.

## Mobil ilovani ishga tushirish

Flutter SDK 3.50+ va Dart 3.13+ talab qilinadi. Platform runnerlari hali repoga generatsiya qilinmagan; birinchi marta quyidagilarni bajaring:

```bash
cd apps/mobile
flutter create --platforms=android,ios,web,windows .
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1
```

`10.0.2.2` Android emulyatoridan kompyuterning localhost manziliga ulanish uchun ishlatiladi. Jismoniy Android qurilma uchun `API_BASE_URL` qiymatida kompyuterning lokal tarmoq IP manzilidan foydalaning. iOS Simulator/Web uchun mos localhost manzilini bering.

## API endpointlar

- `POST /api/v1/auth/register`
- `POST /api/v1/auth/login`
- `GET /api/v1/auth/me`
- `GET /api/v1/courses?level=beginner&search=python`
- `GET /api/v1/courses/{course_id}`
- `GET /api/v1/courses/{course_id}/modules`
- `GET /api/v1/courses/modules/{module_id}/lessons`
- `GET /api/v1/courses/lessons/{lesson_id}`
- `POST /api/v1/progress/lessons/{lesson_id}/complete`
- `GET /api/v1/progress/me`

Autentifikatsiya talab qiladigan endpointlar uchun `Authorization: Bearer <access_token>` sarlavhasidan foydalaniladi.

## Testlar

Backend:
```bash
cd services/api
pytest -q
```

Mobil:
```bash
cd apps/mobile
dart format lib test
flutter analyze
flutter test
```

Backend GitHub Actions testlari muvaffaqiyatli o‘tgan. Mobil CI yangi lesson-progress funksiyasi bilan qayta tekshirilmoqda.

## Xavfsizlik va keyingi bosqichlar
- Email tasdiqlash, parolni tiklash va refresh-token rotation.
- Rate limiting va brute-force himoyasi.
- AI Mentor, kod tahlili va xavfsiz alohida code-execution sandbox.
- Quiz, adaptiv o‘quv yo‘l xaritasi va gamification.
- Admin panel, accessibility, localization va production release.

Kod bajarish API jarayonida yoki mobil ilova ichida bajarilmaydi; alohida izolyatsiyalangan sandbox talab qilinadi.
