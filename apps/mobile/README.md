# EduCode AI Mobile

Flutter mobil ilovasi: Material UI, Riverpod, Dio va secure token storage.

## Talablar
- Flutter stable 3.50+
- Dart SDK 3.13+
- Android Studio / Android SDK

## Birinchi ishga tushirish
Platform runnerlari hali generatsiya qilinmagan. Birinchi marta:

```bash
flutter create --platforms=android,ios,web,windows .
flutter pub get
```

## API manzili

API manzili `API_BASE_URL` compile-time define orqali sozlanadi.

Android Emulator (host kompyuterdagi FastAPI):
```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1
```

Jismoniy Android qurilma uchun `10.0.2.2` o‘rniga kompyuterning lokal tarmoq IP manzilini yozing. iOS Simulator/Web uchun `http://127.0.0.1:8000/api/v1` manzilidan foydalanish mumkin.

Backendni ishga tushirishdan oldin repository ildizida `docker compose up -d db`, keyin `services/api` ichida migratsiya va Uvicorn serverini ishga tushiring. Uvicorn Android qurilmalardan ulanishi uchun `--host 0.0.0.0` bilan ishga tushirilishi kerak.

## Tekshiruv
```bash
dart format lib test
flutter analyze
flutter test
```

JWT access token `flutter_secure_storage` orqali qurilmaning secure storage joyida saqlanadi. Hozir login/register va sessiya tekshiruvi API bilan ulangan; refresh token, email verification va password reset hali ishlab chiqilmagan.
