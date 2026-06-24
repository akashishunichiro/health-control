# Health Control — Shaxsiy salomatlik kuzatuvi (Flutter ilova)

[TZ_HealthControl.md](TZ_HealthControl.md) asosida yaratilgan mobil ilova (Android + iOS).
Foydalanuvchi salomatlik ko'rsatkichlarini kuzatadi: **ovqatlanish, suv, yurish/faollik, uyqu, vazn, qon bosimi/qand, dori-darmon**.

---

## Texnologiyalar
- **Flutter 3.44.3 / Dart 3.12.2**
- **Riverpod** — holat boshqaruvi (`NotifierProvider`)
- **Hive** — lokal (offline) ma'lumotlar bazasi
- Material 3 dizayn, maxsus chizilgan grafiklar (tashqi grafik kutubxonasiz)

## Loyiha tuzilishi
```
app/lib/
├── main.dart                  # kirish nuqtasi, Hive init
├── core/
│   ├── theme.dart             # Material 3 mavzu, ranglar
│   └── util.dart              # sana, BMI, Mifflin–St Jeor kaloriya hisobi
├── data/
│   ├── db.dart                # Hive box'lari
│   ├── models.dart            # Meal, WaterLog, SleepLog, StepsLog, WeightLog, Medication...
│   ├── profile.dart           # foydalanuvchi profili + maqsadlar
│   ├── food_catalog.dart      # mahalliy ovqatlar bazasi (kaloriya)
│   └── app_state.dart         # markaziy holat (CRUD + hisob-kitoblar)
├── widgets/
│   └── common.dart            # ProgressRing, MiniBarChart, MetricCard, SectionHeader
└── features/
    ├── home_screen.dart       # pastki navigatsiya (5 tab)
    ├── dashboard_screen.dart  # bosh ekran: bugungi xulosa + grafiklar
    ├── nutrition_screen.dart  # ovqatlanish (kaloriya halqasi, ovqat ro'yxati)
    ├── add_meal_screen.dart   # ovqat qo'shish (bazadan/qo'lda)
    ├── water_screen.dart      # suv (tezkor qo'shish + progress)
    ├── activity_screen.dart   # yurish/faollik (qadam, masofa, kaloriya)
    ├── sleep_screen.dart      # uyqu (yotish/uyg'onish, sifat, tarix)
    ├── medication_screen.dart # dori ro'yxati + qabul belgisi
    ├── add_medication_screen.dart
    ├── weight_screen.dart     # vazn + BMI + dinamika
    ├── profile_screen.dart    # profil va maqsadlar
    └── more_screen.dart       # "Yana" menyusi
```

## Asosiy funksiyalar (MVP)
- 🍽️ **Ovqatlanish** — ovqat qo'shish, kaloriya hisobi, ovqatlar bazasi, kunlik me'yor
- 💧 **Suv** — tezkor qo'shish, kunlik progress, haftalik grafik
- 🚶 **Yurish/faollik** — qadam, masofa (km), kaloriya, maqsad halqasi
- 😴 **Uyqu** — yotish/uyg'onish vaqti, davomiylik, sifat, tarix
- ⚖️ **Vazn** — kuzatuv, BMI (TVI) hisobi, dinamika grafigi
- 💊 **Dori-darmon** — jadval, kunlik qabul belgisi
- 📊 **Dashboard** — bugungi xulosa kartalari + haftalik grafiklar
- Barcha ma'lumotlar telefon ichida (offline, Hive) saqlanadi

---

## Ishga tushirish / build qilish

Muhit o'zgaruvchilarini yuklash (`flutter`, Java, Android SDK yo'llari):
```bash
source "env.sh"
```

Loyiha papkasiga o'tish va paketlarni o'rnatish:
```bash
cd app
flutter pub get
```

**Emulyator yoki ulangan telefonda ishga tushirish:**
```bash
flutter run
```

**APK build qilish:**
```bash
flutter build apk --debug                      # to'liq debug APK
flutter build apk --release --split-per-abi    # kichik release APK (har ABI)
```

Build natijalari: `app/build/app/outputs/flutter-apk/`

> **iOS build** uchun macOS + Xcode kerak (bu Linux mashinada bajarilmaydi). Kod tayyor — Mac'da yoki Codemagic kabi CI'da build qilinadi.

---

## Eslatma
Ilova tibbiy maslahat bermaydi va tashxis qo'ymaydi — faqat shaxsiy kuzatuv vositasi.
