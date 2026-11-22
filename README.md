# EduCode AI

**Learn. Code. Solve. Build. Grow.**

Sun’iy intellekt texnologiyalari asosida dasturlashni o‘rgatishga mo‘ljallangan mobil ta’lim platformasi.

## BMI mavzusi
**Sun’iy intellekt texnologiyalari asosida dasturlashni o‘rgatishga mo‘ljallangan mobil ta’lim platformasini ishlab chiqish.**

## Loyihaning maqsadi
EduCode AI dasturlashni endi boshlayotgan va bilimini rivojlantirmoqchi bo‘lgan o‘quvchilarga individual ta’lim yo‘nalishi, interaktiv darslar, amaliy topshiriqlar va AI mentor yordamida o‘rganish imkonini beradi.

## Arxitektura

- `apps/mobile` — Flutter mobil ilovasi (Dart, Riverpod, feature-first).
- `services/api` — FastAPI backend.
- `docs` — loyiha va BMI texnik hujjatlari.
- `.github/workflows` — CI tekshiruvlari.

## Rejalashtirilgan asosiy imkoniyatlar

- Ro‘yxatdan o‘tish va autentifikatsiya
- Boshlang‘ich bilim darajasini aniqlash
- Shaxsiylashtirilgan o‘quv yo‘l xaritasi
- Python, Dart, Flutter, JavaScript va boshqa kurslar
- Darslar, testlar va amaliy topshiriqlar
- AI Mentor: savol-javob va tushuntirishlar
- Kodni tahlil qilish va xatolarni tushuntirish
- Loyihalar laboratoriyasi
- XP, streak, badge va yutuqlar
- O‘quv jarayoni statistikasi
- Administrator boshqaruv paneli

## Ishga tushirish

### Mobil ilova
Flutter SDK 3.38+ va Dart 3.10+ talab qilinadi.

```bash
cd apps/mobile
flutter pub get
flutter run
```

### Backend
Python 3.11+ talab qilinadi.

```bash
cd services/api
python -m venv .venv
# Windows:
.venv\Scripts\activate
# macOS/Linux:
# source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

API hujjatlari: `http://127.0.0.1:8000/docs`

## Muhim xavfsizlik eslatmasi
Haqiqiy AI provayder kalitlari, ma’lumotlar bazasi parollari va boshqa maxfiy qiymatlarni Git repositoryga joylamang. `.env.example` faqat namuna qiymatlarni saqlaydi.

## Holat
Boshlang‘ich monorepo va arxitektura tayyorlanmoqda. Funksiyalar bosqichma-bosqich ishlab chiqiladi va testlar bilan mustahkamlanadi.
