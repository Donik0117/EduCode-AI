# EduCode AI Mobile

Flutter mobil ilovasi (Dart, Material 3, Riverpod).

## Talablar
- Flutter stable
- Dart SDK 3.10+
- Android Studio yoki VS Code
- Android SDK (Android qurilma/emulator uchun)

## Birinchi ishga tushirish
Repo'da platform runnerlari hali generatsiya qilinmagan. Papkada quyidagilarni bir marta bajaring:

```bash
flutter create --platforms=android,ios,web,windows .
flutter pub get
flutter run
```

Mavjud Android project yaratish jarayonini saqlang; `lib/` ichidagi ilova kodi o‘zgartirilmaydi.

## Tekshiruv
```bash
dart format lib test
flutter analyze
flutter test
```

Hozirgi ekranlardagi kurs va topshiriq ma’lumotlari demo ma’lumotlardir. Autentifikatsiya, API va AI xizmatlari keyingi bosqichlarda ulanadi.
