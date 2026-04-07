# LOYIHA: Favqulodda Vaziyatlar O‘quv Ilovasi

Ushbu repoda **Django REST backend** va **Flutter frontend (APK)** uchun boshlang‘ich skelet mavjud.

## 1) Backend (Django REST)

### Ishga tushirish
<<<<<<< ours
<<<<<<< ours
<<<<<<< ours
=======
# LOYIHA: Favqulodda Vaziyatlar O‘quv Ilovasi (Backend skeleton)

Ushbu repoda Django REST asosidagi backend skeleti yaratildi.

## Ishga tushirish
=======
=======
=======

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

### API endpointlar

#### Content module

=======
## API endpointlar

### Content module
=======

- `GET /api/categories`
- `GET /api/lessons`
- `GET /api/lessons/{id}`

#### Quiz module

=======
### Quiz module
=======
=======
=======
- `GET /api/questions?category_id=`
- `GET /api/random-test`
- `POST /api/submit-test` (auth required)

`submit-test` request body:

Request body example (`submit-test`):
=======
=======
=======

```json
{
  "answers": {
    "1": 4,
    "2": 7,
    "3": 10
  }
}
```

## 2) Frontend (Flutter APK)

### Ishga tushirish

```bash
cd frontend
flutter pub get
flutter run
```

### APK build

```bash
flutter build apk --release
```

### Frontend imkoniyatlari
- Home ekran: darslar ro‘yxati va aralash test boshlash
- Lesson ekran: nazariy matn
- Test ekran: savol, variant, next/yakunlash
- Result ekran: score
- Offline fallback: Hive cache + seed content (`assets/data/seed_content.json`)

> Default backend URL: `http://10.0.2.2:8000` (Android emulator uchun).

## 3) Model tuzilmasi
- Education: `Category`, `Lesson`
- Quiz: `Question`, `Answer`, `TestResult`

## 4) Keyingi qadamlar
- JWT auth qo‘shish
- migratsiyalar va seed data
- Flutter UI polishing (responsive/design system)
- offline sync strategiyasi (background sync)
<<<<<<< ours
<<<<<<< ours
<<<<<<< ours
=======
## Model tuzilmasi
- Education: `Category`, `Lesson`
- Quiz: `Question`, `Answer`, `TestResult`

## Keyingi qadamlar
- JWT auth qo‘shish
- migratsiyalar yaratish
- Flutter bilan integratsiya
- offline sync strategiyasi
=======
=======
=======
