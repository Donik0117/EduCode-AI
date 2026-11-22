# EduCode AI

**Learn. Code. Solve. Build. Grow.**

Sun’iy intellekt texnologiyalari asosida dasturlashni o‘rgatishga mo‘ljallangan mobil ta’lim platformasi.

## BMI mavzusi
**Sun’iy intellekt texnologiyalari asosida dasturlashni o‘rgatishga mo‘ljallangan mobil ta’lim platformasini ishlab chiqish.**

## Arxitektura
- `apps/mobile` — Flutter mobil ilovasi (Dart, Riverpod, feature-first).
- `services/api` — FastAPI backend.
- PostgreSQL — foydalanuvchilar va ta’lim ma’lumotlari.
- Alembic — database migratsiyalari.
- `docs` — loyiha va BMI texnik hujjatlari.
- `.github/workflows` — CI tekshiruvlari.

## Hozir mavjud funksiyalar
- Email/parol orqali ro‘yxatdan o‘tish va kirish.
- JWT bearer access token.
- Argon2 parol xeshlash.
- Joriy foydalanuvchi profili va hisobdan chiqish.
- Kurslar katalogi va filtrlash endpointlari.
- Flutter login/register UI.
- Android uchun secure storage orqali token saqlash.

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
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

API hujjatlari: http://127.0.0.1:8000/docs

Production muhitida `JWT_SECRET_KEY` qiymatini albatta tasodifiy, maxfiy va kamida 32 belgidan iborat qiymatga almashtiring. Haqiqiy `.env` faylini Git'ga joylamang.

## Mobil ilovani ishga tushirish

Flutter SDK 3.50+ va Dart 3.13+ talab qilinadi. Platform runnerlari hali repoga generatsiya qilinmagan; birinchi marta quyidagilarni bajaring:

```bash
cd apps/mobile
flutter create --platforms=android,ios,web,windows .
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1
```

`10.0.2.2` Android emulyatoridan kompyuterning localhost manziliga ulanish uchun ishlatiladi. Jismoniy Android qurilma uchun `API_BASE_URL` qiymatida kompyuterning lokal tarmoq IP manzilidan foydalaning. iOS Simulator/Web uchun mos localhost manzilini bering.

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

## Xavfsizlik va keyingi bosqichlar
- Email tasdiqlash, parolni tiklash va refresh-token rotation.
- Rate limiting va brute-force himoyasi.
- Kurs kontentini PostgreSQLga ko‘chirish.
- AI Mentor va xavfsiz, alohida code-execution sandbox.
- Learning progress, quiz, adaptive roadmap va gamification.
- Admin panel va production deployment.

Kod bajarish API jarayonida yoki mobil ilova ichida bajarilmaydi; alohida izolyatsiyalangan sandbox talab qilinadi.
