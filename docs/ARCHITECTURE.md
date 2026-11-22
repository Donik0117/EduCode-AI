# Texnik arxitektura

## Umumiy ko‘rinish

```text
Flutter Mobile App
       |
       | HTTPS / JSON
       v
FastAPI Backend
       |
       +---- PostgreSQL (keyingi bosqich)
       |
       +---- AI Provider Adapter
       |
       +---- Learning / Assessment Services
       |
       +---- Secure Code Execution Adapter (alohida sandbox)
```

## Mobil ilova

Feature-first tuzilma. Har bir feature ichida data, domain va presentation qatlamlari ajratiladi.

- presentation: ekranlar, widgetlar, holat boshqaruvi
- domain: entity, repository contract, use case
- data: API client, DTO, repository implementation

Holat boshqaruvi: Riverpod.
Navigatsiya: GoRouter.
HTTP: Dio.
Kod sifati: dart format va flutter analyze.

## Backend

FastAPI, Pydantic v2 va SQLAlchemy 2 uchun tayyorlangan qatlamli tuzilma.
API versiyalash: `/api/v1`.
Konfiguratsiya environment orqali boshqariladi.

## Xavfsizlik tamoyillari

- Maxfiy kalitlar faqat server environmentida saqlanadi.
- Barcha tashqi API so‘rovlari validatsiya qilinadi.
- Kodni bajarish backend jarayonida yoki mobil qurilmada amalga oshirilmaydi.
- Kod bajarish alohida, resurs cheklovlari va tarmoq siyosati o‘rnatilgan sandbox xizmatiga topshiriladi.
- Autentifikatsiya va avtorizatsiya endpointlar bo‘yicha tekshiriladi.
