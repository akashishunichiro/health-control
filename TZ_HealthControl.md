# Texnik Topshiriq (TZ): "Health Control" — Shaxsiy salomatlik kuzatuvi mobil ilovasi

**Hujjat versiyasi:** 1.0
**Sana:** 2026-06-24
**Loyiha turi:** B2C mobil ilova (Android + iOS)
**Holati:** Loyihalash bosqichi

---

## 1. Umumiy ma'lumot

### 1.1. Loyiha haqida
"Health Control" — bu foydalanuvchiga o'z salomatligi ko'rsatkichlarini bir joyda kuzatish, tahlil qilish va sog'lom odatlarni shakllantirishga yordam beruvchi mobil ilova. Ilova kundalik o'lchovlar (vazn, qon bosimi, qand, suv, uyqu, qadamlar, dori qabuli) ni yig'adi, vizual statistika ko'rsatadi va eslatmalar yuboradi.

### 1.2. Hujjatning maqsadi
Ushbu TZ ilovaning funksional va nofunksional talablari, texnologik tanlovi, ma'lumotlar tuzilishi, ekranlari va ishlab chiqish bosqichlarini belgilaydi. U dasturchilar, dizaynerlar, testerlar va buyurtmachi o'rtasidagi kelishilgan asos hisoblanadi.

### 1.3. Atamalar va qisqartmalar
| Atama | Izoh |
|-------|------|
| MVP | Minimal ishlaydigan mahsulot (Minimum Viable Product) |
| BMI/TVI | Tana vazni indeksi (Body Mass Index) |
| Metrika | Kuzatiladigan salomatlik ko'rsatkichi (vazn, bosim va h.k.) |
| Push-bildirishnoma | Telefon ekraniga keladigan eslatma |
| Onboarding | Yangi foydalanuvchini ilova bilan tanishtirish jarayoni |
| HealthKit / Health Connect | iOS va Android'ning tizim sog'liq ma'lumotlar platformalari |

---

## 2. Maqsad va vazifalar

### 2.1. Biznes maqsad
- Foydalanuvchilarga salomatligini muntazam kuzatish odatini berish.
- Sog'lom turmush tarzini rag'batlantirish orqali foydalanuvchini ilovada ushlab turish (retention).
- Kelajakda premium obuna (monetizatsiya) uchun asos yaratish.

### 2.2. Foydalanuvchi maqsadlari
- Salomatlik ko'rsatkichlarini tez va oson kiritish.
- O'zgarish dinamikasini grafiklarda ko'rish.
- Dori va o'lchovlar haqida o'z vaqtida eslatma olish.
- Hisobotni shifokor bilan ulashish (PDF/eksport).

### 2.3. Muvaffaqiyat mezonlari (KPI)
- DAU/MAU (kunlik/oylik faol foydalanuvchilar) nisbati ≥ 20%.
- 7-kunlik retention ≥ 30%.
- O'rtacha kuniga ≥ 1 ta o'lchov kiritilishi.
- Ilova do'koni reytingi ≥ 4.3.

---

## 3. Maqsadli auditoriya (Personas)

| Persona | Tavsif | Asosiy ehtiyoj |
|---------|--------|----------------|
| **Salomatlikka e'tiborli** (25–40 yosh) | Sport bilan shug'ullanadi, vazn va faollikni kuzatadi | Trend grafiklari, maqsadlar |
| **Surunkali holatga ega** (45+ yosh) | Qon bosimi/qandni nazorat qiladi, dori ichadi | Eslatmalar, shifokorga hisobot |
| **Yangi ona / homilador** | Vazn, suv, kayfiyatni kuzatadi | Sodda interfeys, kundalik |
| **Keksa foydalanuvchi** | Texnikaga uncha tushunmaydi | Katta shrift, oddiy navigatsiya |

---

## 4. Funksional talablar

Talablar prioritet bo'yicha belgilangan: **[M]** — MVP (majburiy), **[F]** — keyingi fazalar.

### 4.1. Autentifikatsiya va profil
- **[M]** Ro'yxatdan o'tish: email/parol, telefon raqami (OTP).
- **[M]** Tizimga kirish, parolni tiklash.
- **[F]** Ijtimoiy tarmoq orqali kirish (Google, Apple ID).
- **[M]** Profil: ism, yosh, jins, bo'y, boshlang'ich vazn, faollik darajasi.
- **[M]** Salomatlik maqsadlarini belgilash (masalan: "vaznni 5 kg kamaytirish").

### 4.2. Salomatlik metrikalari (asosiy modul)
Quyidagi ko'rsatkichlarni qo'lda kiritish va kuzatish:

| Metrika | Birlik | MVP |
|---------|--------|-----|
| Vazn | kg | [M] |
| Qon bosimi (systolik/diastolik) | mmHg | [M] |
| Yurak urishi (puls) | bpm | [M] |
| Qondagi qand | mmol/L | [M] |
| Suv iste'moli | ml / stakan | [M] |
| Uyqu davomiyligi va sifati | soat | [M] |
| Qadamlar / yurish | qadam / km | [M] |
| Faollik / kuydirilgan kaloriya | kkal | [M] |
| Ovqatlanish / iste'mol qilingan kaloriya | kkal / g | [M] |
| Tana harorati | °C | [F] |
| Kayfiyat / o'zini his qilish | belgi (emoji) | [F] |
| Dori qabuli | doza | [M] |

Har bir metrika uchun:
- **[M]** Yangi yozuv qo'shish (qiymat + sana/vaqt + izoh).
- **[M]** Yozuvni tahrirlash va o'chirish.
- **[M]** Tarix ro'yxati (kunlar/haftalar bo'yicha).
- **[M]** Avtomatik hisoblash: BMI (TVI), o'rtacha qiymatlar.

### 4.3. Ovqatlanish kuzatuvi (Nutrition) — yegan ovqati
- **[M]** Ovqat qo'shish: nomi, porsiya/og'irlik (g), ovqat turi (nonushta / tushlik / kechki ovqat / yengil tamaddi).
- **[M]** Kunlik iste'mol qilingan **kaloriya**ni hisoblash va kunlik me'yor bilan solishtirish.
- **[M]** Suv iste'molini shu modul ichida tezkor kiritish ("+1 stakan", "+250 ml" tugmalari).
- **[M]** Ovqatlar bazasi (oddiy mahalliy lug'at: non, guruch, go'sht, sut va h.k. — kaloriyasi bilan).
- **[F]** Makronutriyentlar: oqsil / yog' / uglevod hisobi.
- **[F]** Shtrix-kod (barcode) orqali mahsulot qidirish.
- **[F]** Tayyor ovqat fotosurati va izoh (ovqat kundaligi).
- **[M]** Kunlik/haftalik ovqatlanish xulosasi va grafigi.

> Kunlik kaloriya me'yori foydalanuvchi profili (jins, yosh, bo'y, vazn, faollik darajasi) asosida avtomatik taklif qilinadi (Mifflin–St Jeor formulasi).

### 4.4. Faollik va yurish (Activity) — yurish
- **[M]** Kunlik qadamlar sonini kuzatish (telefon pedometr datchigi orqali avtomatik, yoki qo'lda kiritish).
- **[M]** Bosib o'tilgan masofa (km) va taxminiy kuydirilgan kaloriya.
- **[M]** Kunlik qadam maqsadi (masalan, 8000 qadam) va uning bajarilishi (progress halqa).
- **[F]** Mashq turlarini qo'lda kiritish (yugurish, velosiped, suzish — davomiylik + kaloriya).
- **[F]** Aqlli soat / fitnes-trekerdan avtomatik olish (4.10-bo'limga qarang).

### 4.5. Uyqu kuzatuvi (Sleep) — uxlash
- **[M]** Uyquga yotish va uyg'onish vaqtini kiritish → umumiy davomiylik avtomatik hisoblanadi.
- **[M]** Uyqu sifatini baholash (yomon / o'rtacha / yaxshi).
- **[M]** Kunlik uyqu maqsadi (masalan, 8 soat) va haftalik trend grafigi.
- **[F]** Uyqu tartibini tahlil qilish (o'rtacha yotish/uyg'onish vaqti).
- **[F]** Uxlash vaqti yaqinlashganda eslatma.

### 4.6. Dori-darmon eslatmalari
- **[M]** Dori qo'shish: nomi, doza, ichish vaqti(lari), davomiyligi.
- **[M]** Belgilangan vaqtda push-bildirishnoma.
- **[M]** "Ichdim / o'tkazib yubordim" belgisi.
- **[F]** Dori zaxirasi tugashi haqida ogohlantirish.

### 4.7. Statistika va tahlil (Dashboard)
- **[M]** Bosh ekran: bugungi xulosa (kiritilgan/qolgan metrikalar).
- **[M]** Grafiklar: chiziqli grafik (kun/hafta/oy bo'yicha trend).
- **[M]** Norma chegaralari (yashil/sariq/qizil zonalar — masalan, bosim normada emasligini ko'rsatish).
- **[F]** Aqlli tavsiyalar (insight): "So'nggi hafta suv kam ichdingiz".

### 4.8. Eslatmalar va bildirishnomalar
- **[M]** Metrika kiritishni eslatish (masalan, har kuni ertalab vazn).
- **[M]** Suv ichish bo'yicha vaqtli eslatmalar.
- **[M]** Bildirishnomalarni yoqish/o'chirish sozlamalari.

### 4.9. Hisobot va eksport
- **[F]** Tanlangan davr uchun PDF hisobot yaratish.
- **[F]** Hisobotni ulashish (shifokorga jo'natish, email).
- **[F]** Ma'lumotlarni CSV ga eksport qilish.

### 4.10. Integratsiyalar
- **[F]** Apple HealthKit (iOS) va Health Connect (Android) bilan sinxronizatsiya (qadamlar, puls, uyqu).
- **[F]** Aqlli soat / fitnes-trekerlardan ma'lumot olish.

### 4.11. Sozlamalar
- **[M]** O'lchov birliklari (kg/lb, mmol/mg).
- **[M]** Til (o'zbek, rus, ingliz).
- **[M]** Mavzu (yorug'/qorong'i rejim).
- **[M]** Ma'lumotlarni o'chirish / akkauntni o'chirish.

---

## 5. Nofunksional talablar

### 5.1. Unumdorlik
- Ilova ishga tushishi ≤ 3 soniya.
- Ekranlar orasida o'tish ≤ 300 ms.
- Offline rejim: ma'lumot internetsiz kiritilib, ulanish tiklanganda sinxronlanadi.

### 5.2. Foydalanuvchanlik (UX)
- 3 tegishdan ko'p bo'lmagan masofada har qanday metrikani kiritish imkoni.
- Katta auditoriya uchun katta shrift rejimi.
- WCAG AA darajasidagi kontrast va accessibility.

### 5.3. Ishonchlilik
- Crash-free sessiyalar ≥ 99.5%.
- Ma'lumotlar yo'qolishiga yo'l qo'ymaslik (lokal + bulutli zaxira).

### 5.4. Mosrulik
- Android 8.0+ (API 26+).
- iOS 14+.
- Turli ekran o'lchamlariga moslashuvchan (responsive) dizayn.

### 5.5. Til va lokalizatsiya
- To'liq ko'p tillilik (o'zbek — asosiy, rus, ingliz).
- Sana/vaqt va sonlar mahalliy formatda.

---

## 6. Texnologiyalar (tavsiya etilgan stek)

| Qatlam | Texnologiya | Asoslash |
|--------|-------------|----------|
| **Mobil (frontend)** | **Flutter (Dart)** | Bitta kod bazasidan Android + iOS, tez ishlash, boy UI |
| State management | Riverpod yoki Bloc | Kengayuvchan, test qilinadigan |
| Lokal baza | Drift (SQLite) / Hive | Offline ma'lumotlar va keshlash |
| **Backend** | Node.js (NestJS) yoki Firebase | Tez start uchun Firebase; kengayish uchun NestJS |
| Ma'lumotlar bazasi | PostgreSQL (yoki Firestore) | Strukturali salomatlik ma'lumotlari uchun PostgreSQL |
| Autentifikatsiya | Firebase Auth / JWT | Xavfsiz, tez integratsiya |
| Push-bildirishnoma | Firebase Cloud Messaging (FCM) | Bepul, ikkala platforma |
| Analitika | Firebase Analytics / Amplitude | Foydalanuvchi xulqini kuzatish |
| Xatolarni kuzatish | Sentry / Crashlytics | Crash monitoring |
| CI/CD | GitHub Actions + Codemagic | Avtomatik build va deploy |

> **Eslatma:** MVP uchun **Flutter + Firebase** kombinatsiyasi tezroq natija beradi. Loyiha o'sganda backend mustaqil NestJS + PostgreSQL ga ko'chirilishi mumkin.

---

## 7. Arxitektura

### 7.1. Umumiy ko'rinish
```
┌─────────────────────┐      HTTPS/REST       ┌──────────────────┐
│   Flutter mobil      │ ◄──────────────────► │     Backend      │
│   ilova (iOS/Android)│      (JWT auth)       │  (API server)    │
│  ┌───────────────┐   │                       │  ┌────────────┐  │
│  │ Lokal SQLite  │   │                       │  │ PostgreSQL │  │
│  │ (offline)     │   │                       │  └────────────┘  │
│  └───────────────┘   │                       │  ┌────────────┐  │
└─────────┬───────────┘                        │  │ FCM (push) │  │
          │                                     │  └────────────┘  │
          ▼                                     └──────────────────┘
   HealthKit / Health Connect
```

### 7.2. Mobil ilova arxitekturasi (Clean Architecture)
- **Presentation** — UI ekranlar + state management.
- **Domain** — biznes-logika, use-case'lar, entitilar.
- **Data** — repozitoriylar, lokal/uzoq ma'lumot manbalari.

### 7.3. Sinxronizatsiya strategiyasi
- "Offline-first": barcha yozuvlar avval lokal bazaga, keyin fon rejimida serverga yuboriladi.
- Konflikt yechimi: "last-write-wins" + timestamp.

---

## 8. Ma'lumotlar modeli (asosiy jadvallar)

### `users`
| Maydon | Tur | Izoh |
|--------|-----|------|
| id | UUID | Birlamchi kalit |
| email | string | Unikal |
| password_hash | string | Shifrlangan |
| name | string | |
| birth_date | date | |
| gender | enum | male/female/other |
| height_cm | float | |
| activity_level | enum | low/medium/high |
| created_at | timestamp | |

### `metrics` (universal o'lchov yozuvi)
| Maydon | Tur | Izoh |
|--------|-----|------|
| id | UUID | |
| user_id | UUID | FK → users |
| type | enum | weight, blood_pressure, glucose, water, sleep, heart_rate... |
| value | jsonb | Moslashuvchan qiymat (masalan {"sys":120,"dia":80}) |
| unit | string | kg, mmHg, ml... |
| measured_at | timestamp | O'lchov vaqti |
| note | text | Ixtiyoriy izoh |
| created_at | timestamp | |

### `medications`
| Maydon | Tur | Izoh |
|--------|-----|------|
| id | UUID | |
| user_id | UUID | FK |
| name | string | Dori nomi |
| dose | string | Masalan "1 tabletka" |
| schedule | jsonb | Vaqtlar massivi |
| start_date | date | |
| end_date | date | |

### `medication_logs`
| Maydon | Tur | Izoh |
|--------|-----|------|
| id | UUID | |
| medication_id | UUID | FK |
| scheduled_at | timestamp | |
| status | enum | taken / skipped / pending |

### `meals` (ovqatlanish yozuvi)
| Maydon | Tur | Izoh |
|--------|-----|------|
| id | UUID | |
| user_id | UUID | FK → users |
| meal_type | enum | breakfast / lunch / dinner / snack |
| name | string | Ovqat nomi |
| amount_g | float | Porsiya og'irligi (gramm) |
| calories | float | Kaloriya (kkal) |
| protein_g | float | Oqsil (ixtiyoriy) |
| fat_g | float | Yog' (ixtiyoriy) |
| carbs_g | float | Uglevod (ixtiyoriy) |
| eaten_at | timestamp | Ovqat vaqti |
| photo_url | string | Ixtiyoriy fotosurat |

### `food_catalog` (ovqatlar bazasi / lug'at)
| Maydon | Tur | Izoh |
|--------|-----|------|
| id | UUID | |
| name | string | Mahsulot nomi |
| calories_per_100g | float | 100 g uchun kaloriya |
| protein_per_100g | float | |
| fat_per_100g | float | |
| carbs_per_100g | float | |
| barcode | string | Ixtiyoriy shtrix-kod |

### `goals`
| Maydon | Tur | Izoh |
|--------|-----|------|
| id | UUID | |
| user_id | UUID | FK |
| metric_type | enum | weight, steps, water, sleep, calories... |
| target_value | float | |
| deadline | date | |

---

## 9. Ekranlar ro'yxati (UI/UX)

| # | Ekran | Tavsif | MVP |
|---|-------|--------|-----|
| 1 | Splash / Onboarding | 3–4 slayd tanishtiruv | [M] |
| 2 | Ro'yxatdan o'tish / Kirish | Auth oqimi | [M] |
| 3 | Profil sozlash | Boshlang'ich ma'lumotlar | [M] |
| 4 | Bosh ekran (Dashboard) | Bugungi xulosa + tez kiritish | [M] |
| 5 | Metrika kiritish | Modal/forma | [M] |
| 6 | Metrika tarixi + grafik | Trend ko'rinishi | [M] |
| 7 | Ovqatlanish (kunlik) | Ovqatlar ro'yxati + kaloriya xulosasi | [M] |
| 8 | Ovqat qo'shish | Forma + ovqatlar bazasidan qidirish | [M] |
| 9 | Faollik / Yurish | Qadamlar, masofa, kaloriya, maqsad halqasi | [M] |
| 10 | Uyqu | Yotish/uyg'onish vaqti, davomiylik, sifat | [M] |
| 11 | Suv | Tezkor kiritish + kunlik progress | [M] |
| 12 | Dori-darmon ro'yxati | Eslatmalar | [M] |
| 13 | Dori qo'shish/tahrirlash | Forma | [M] |
| 14 | Maqsadlar | Maqsad belgilash/kuzatish | [M] |
| 15 | Statistika / Hisobotlar | Umumiy tahlil, PDF | [F] |
| 16 | Bildirishnomalar | Eslatmalar ro'yxati | [M] |
| 17 | Sozlamalar | Til, birlik, mavzu | [M] |
| 18 | Profil | Tahrirlash, akkaunt | [M] |

### Dizayn talablari
- Toza, minimalistik, "sog'liq" estetikasi (yashil/ko'k tonlar).
- Karta (card) asosidagi tartib.
- Grafiklar uchun: `fl_chart` (Flutter) kutubxonasi.
- Figma'da dizayn-tizim (komponentlar, ranglar, tipografiya) tayyorlanadi.

---

## 10. API (asosiy endpoint'lar, REST)

| Metod | Endpoint | Tavsif |
|-------|----------|--------|
| POST | `/auth/register` | Ro'yxatdan o'tish |
| POST | `/auth/login` | Kirish |
| POST | `/auth/refresh` | Token yangilash |
| GET | `/users/me` | Profil olish |
| PATCH | `/users/me` | Profilni yangilash |
| GET | `/metrics?type=&from=&to=` | O'lchovlar ro'yxati |
| POST | `/metrics` | Yangi o'lchov |
| PATCH | `/metrics/:id` | Tahrirlash |
| DELETE | `/metrics/:id` | O'chirish |
| GET/POST | `/medications` | Dorilar |
| POST | `/medications/:id/logs` | Qabul belgisi |
| GET/POST | `/meals?date=` | Ovqatlanish yozuvlari |
| PATCH/DELETE | `/meals/:id` | Ovqatni tahrirlash/o'chirish |
| GET | `/food-catalog?q=` | Ovqatlar bazasidan qidirish |
| GET/POST | `/goals` | Maqsadlar |
| POST | `/sync` | Ommaviy sinxronizatsiya |

Format: JSON, autentifikatsiya: `Bearer JWT`.

---

## 11. Xavfsizlik va maxfiylik

> Salomatlik ma'lumotlari — maxsus toifadagi shaxsiy ma'lumotlar. Bunga jiddiy yondashish shart.

- **[M]** Barcha trafik HTTPS/TLS orqali.
- **[M]** Parollar bcrypt/argon2 bilan heshlanadi.
- **[M]** Lokal bazani shifrlash (SQLCipher).
- **[M]** Token asosidagi sessiya, avtomatik chiqish.
- **[M]** Foydalanuvchi o'z ma'lumotlarini eksport va to'liq o'chirish huquqiga ega (GDPR-ga mos).
- **[F]** Ilovaga kirishda PIN-kod / biometrik (Face ID, barmoq izi).
- **[M]** Maxfiylik siyosati va foydalanish shartlari.
- Ma'lumotlar uchinchi tomonga sotilmaydi.

---

## 12. Ishlab chiqish bosqichlari (Roadmap)

### Bosqich 0 — Tayyorgarlik (1–2 hafta)
- Dizayn-tizim va Figma maketlari.
- Loyiha skeleti, CI/CD sozlash.

### Bosqich 1 — MVP (7–9 hafta)
- Auth + profil.
- Asosiy metrikalar (vazn, bosim, qand).
- **Ovqatlanish** (kaloriya hisobi + ovqatlar bazasi).
- **Suv** kuzatuvi.
- **Yurish/faollik** (pedometr + qadam maqsadi).
- **Uyqu** kuzatuvi.
- Dashboard + grafiklar.
- Dori eslatmalari + push.
- Sozlamalar, offline rejim.

### Bosqich 2 — Kengaytirish (4–6 hafta)
- HealthKit / Health Connect integratsiyasi (qadamlar, uyqu, puls avtomatik).
- Makronutriyentlar (oqsil/yog'/uglevod) va shtrix-kod skaneri.
- PDF hisobot va eksport.
- Aqlli tavsiyalar (insights).
- Qo'shimcha metrikalar (harorat, kayfiyat).

### Bosqich 3 — Monetizatsiya va o'sish (4+ hafta)
- Premium obuna (kengaytirilgan tahlil, cheksiz tarix).
- Ijtimoiy/oilaviy profil ulashish.
- Gamifikatsiya (mukofotlar, streak).

---

## 13. Sinov (Testing) talablari

- **Unit-testlar**: domain logikasi (BMI, o'rtacha hisoblash).
- **Widget/UI testlar**: asosiy ekranlar.
- **Integratsion testlar**: auth, sinxronizatsiya oqimi.
- **Qo'lda QA**: turli qurilmalar (kichik/katta ekran, eski Android).
- **Beta-test**: TestFlight (iOS) + Google Play Internal Testing.
- Qamrov maqsadi: kritik logika uchun ≥ 70%.

---

## 14. Risklar va cheklovlar

| Risk | Ehtimollik | Yengillashtirish |
|------|-----------|-------------------|
| HealthKit/Health Connect murakkab integratsiya | O'rta | MVP'dan keyinga qoldirildi |
| Ma'lumot maxfiyligi qonunlari | Yuqori | Huquqshunos bilan maxfiylik siyosatini tekshirish |
| Foydalanuvchi ma'lumot kiritmay tashlab ketishi | Yuqori | Eslatmalar, sodda UX, gamifikatsiya |
| App Store / Play Market tibbiy ilova qoidalari | O'rta | "Tibbiy maslahat emas" disklaymerini qo'shish |

> **Muhim huquqiy eslatma:** Ilova tashxis qo'ymaydi va tibbiy maslahat bermaydi. Bu faqat shaxsiy kuzatuv vositasi. Har bir tegishli ekranda shu disklaymer ko'rsatilishi kerak.

---

## 15. Yetkazib beriladigan natijalar (Deliverables)

1. Figma dizayn-maketlari va dizayn-tizim.
2. Flutter mobil ilova (Android `.apk`/`.aab` + iOS build).
3. Backend API + ma'lumotlar bazasi.
4. Texnik hujjatlar (API docs, README).
5. Test hisobotlari.
6. Play Market va App Store'ga joylashtirish.

---

*Ushbu TZ loyiha jarayonida aniqlashtirilishi va yangilanishi mumkin. Har bir o'zgarish versiya tarixida qayd etiladi.*
