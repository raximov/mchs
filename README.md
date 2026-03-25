# LOYIHA: Favqulodda Vaziyatlar O‘quv Ilovasi (Backend skeleton)

Ushbu repoda Django REST asosidagi backend skeleti yaratildi.

## Ishga tushirish

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

## API endpointlar

### Content module
- `GET /api/categories`
- `GET /api/lessons`
- `GET /api/lessons/{id}`

### Quiz module
- `GET /api/questions?category_id=`
- `GET /api/random-test`
- `POST /api/submit-test` (auth required)

Request body example (`submit-test`):

```json
{
  "answers": {
    "1": 4,
    "2": 7,
    "3": 10
  }
}
```

## Model tuzilmasi
- Education: `Category`, `Lesson`
- Quiz: `Question`, `Answer`, `TestResult`

## Keyingi qadamlar
- JWT auth qo‘shish
- migratsiyalar yaratish
- Flutter bilan integratsiya
- offline sync strategiyasi
