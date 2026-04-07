from django.core.management.base import BaseCommand
from django.db import transaction

from apps.education.models import Category, Lesson, LessonBlock
from apps.quiz.models import Answer, Question


SEED_DATA = [
    {
        'name': "Yong'in",
        'lesson_title': "Yong'in paytida xavfsizlik",
        'lesson_content': (
            "Avvalo vaziyatni baholang, odamlarni ogohlantiring va imkon qadar tez xavfsiz joyga chiqing. "
            "Lift ishlatmang, tutun bo'lsa pastroq egilib harakat qiling va 101 yoki 112 ga xabar bering."
        ),
        'lesson_blocks': [
            {
                'order': 1,
                'block_type': 'image',
                'title': "Yong'in o'chirgich sxemasi",
                'body': "O'quvchiga ushlagich, xavfsizlik plomba va purkash qismi qayerda ekanini ko'rsating.",
                'media_url': 'https://images.unsplash.com/photo-1593115057322-e94b77572f20?auto=format&fit=crop&w=1200&q=80',
            },
            {
                'order': 2,
                'block_type': 'video',
                'title': 'Evakuatsiya bo‘yicha qisqa video',
                'body': "30 soniyalik rolikda sinfdan chiqish ketma-ketligini ko'rsating.",
                'media_url': 'https://www.youtube.com/watch?v=Sqz5dbs5zmo',
            },
            {
                'order': 3,
                'block_type': 'audio',
                'title': '112 ga qo‘ng‘iroq namunasi',
                'body': "Ism, manzil va hodisa turini aniq aytish bo'yicha audio yozuv.",
                'media_url': 'https://example.com/mchs/fire-dispatch-sample.mp3',
            },
            {
                'order': 4,
                'block_type': 'checklist',
                'title': "Yong'in paytida 4 qadam",
                'body': "1. Atrofdagilarni ogohlantiring\n2. Lift ishlatmang\n3. Pastroq egilib chiqing\n4. 101 yoki 112 ga qo'ng'iroq qiling",
                'media_url': '',
            },
        ],
        'questions': [
            {
                'text': "Yong'in paytida binoni tark etishda eng to'g'ri yo'l qaysi?",
                'answers': [
                    ("Lift orqali tushish", False),
                    ("Derazadan sakrash", False),
                    ("Zinadan tartibli chiqish", True),
                    ("Avval buyumlarni yig'ish", False),
                ],
            },
            {
                'text': "Tutun ko'p bo'lsa qanday harakat qilish kerak?",
                'answers': [
                    ("Yugurib ketish", False),
                    ("Pastroq egilib yurish", True),
                    ("Eshiklarni ochiq qoldirish", False),
                    ("Elektr jihozlarini yoqish", False),
                ],
            },
        ],
    },
    {
        'name': 'Zilzila',
        'lesson_title': 'Zilzila vaqtida to\'g\'ri harakat',
        'lesson_content': (
            "Silkinish paytida boshni va bo'yinni himoya qiling, oynalardan uzoqroq turing va mustahkam buyum ostida "
            "panalang. Ko'chada bo'lsangiz, binolar, ustunlar va daraxtlardan uzoqroq joyga o'ting."
        ),
        'lesson_blocks': [],
        'questions': [
            {
                'text': "Zilzila vaqtida xona ichida bo'lsangiz nima qilish kerak?",
                'answers': [
                    ("Derazaga yaqinlashish", False),
                    ("Mustahkam stol ostiga pana bo'lish", True),
                    ("Balkonga yugurish", False),
                    ("Liftga chiqish", False),
                ],
            },
            {
                'text': "Zilziladan keyin birinchi navbatda nima tekshiriladi?",
                'answers': [
                    ("Internet tezligi", False),
                    ("Gaz sizishi va jarohatlar", True),
                    ("Televizor ishlashi", False),
                    ("Mebel joylashuvi", False),
                ],
            },
        ],
    },
    {
        'name': 'Suv toshqini',
        'lesson_title': 'Suv toshqini xavfsizligi',
        'lesson_content': (
            "Suv sathi oshayotgan bo'lsa, balandroq joyga chiqing va elektr manbalaridan uzoq turing. "
            "Tez oqayotgan suvdan piyoda ham, avtomobil bilan ham o'tishga urinmang."
        ),
        'lesson_blocks': [],
        'questions': [
            {
                'text': "Suv toshqini paytida eng xavfsiz qaror qaysi?",
                'answers': [
                    ("Past joyga tushish", False),
                    ("Balandroq joyga chiqish", True),
                    ("Ko'prik ostida kutish", False),
                    ("Suvni kesib o'tish", False),
                ],
            },
            {
                'text': "Tez oqayotgan suv bo'lsa nima qilish kerak?",
                'answers': [
                    ("Mashina bilan kesib o'tish", False),
                    ("Piyoda o'tib ko'rish", False),
                    ("Uzoqroq aylanib xavfsiz yo'l tanlash", True),
                    ("Suv chuqurligini oyoq bilan tekshirish", False),
                ],
            },
        ],
    },
    {
        'name': 'Elektr xavfi',
        'lesson_title': 'Elektr xavfsizligi qoidalari',
        'lesson_content': (
            "Nam qo'l bilan elektr jihozlariga tegmang va shikastlangan simlardan foydalanmang. "
            "Tok urgan odamga bevosita tegishdan oldin elektr manbaini uzing."
        ),
        'lesson_blocks': [],
        'questions': [
            {
                'text': "Tok urgan odamga yordam berishda birinchi qadam nima?",
                'answers': [
                    ("Darhol ushlab tortish", False),
                    ("Elektr manbaini uzish", True),
                    ("Suv sepish", False),
                    ("Telefonini olish", False),
                ],
            },
            {
                'text': "Qaysi holat elektr xavfi hisoblanadi?",
                'answers': [
                    ("Quruq rozetka", False),
                    ("Shikastlangan sim", True),
                    ("O'chirilgan chiroq", False),
                    ("Zaryadsiz batareya", False),
                ],
            },
        ],
    },
    {
        'name': 'Birinchi yordam',
        'lesson_title': 'Birinchi yordamning asoslari',
        'lesson_content': (
            "Jarohatlangan odamning hushini, nafasini va qon ketishini baholang. Zarur bo'lsa tez yordam chaqiring "
            "va faqat xavfsiz usullar bilan yordam ko'rsating."
        ),
        'lesson_blocks': [],
        'questions': [
            {
                'text': "Birinchi yordamda avval nima baholanadi?",
                'answers': [
                    ("Kiyim rangi", False),
                    ("Hush va nafas holati", True),
                    ("Telefon modeli", False),
                    ("Yo'lovchilar soni", False),
                ],
            },
            {
                'text': "Kuchli qon ketishda nima qilish kerak?",
                'answers': [
                    ("Jarohatni bosib turish", True),
                    ("Jarohatni iflos suv bilan yuvish", False),
                    ("Hech narsa qilmaslik", False),
                    ("Odamni yurishga majburlash", False),
                ],
            },
        ],
    },
    {
        'name': "Iqlim o'zgarishi",
        'lesson_title': "Issiq to'lqin va iqlim xatarlari",
        'lesson_content': (
            "Issiq kunlarda ko'proq suv iching, soyada dam oling va kunning eng issiq paytida og'ir ishlarni cheklang. "
            "Ob-havo ogohlantirishlarini muntazam kuzatib boring."
        ),
        'lesson_blocks': [],
        'questions': [
            {
                'text': "Issiq to'lqin vaqtida qaysi odat foydali?",
                'answers': [
                    ("Suv ichishni kamaytirish", False),
                    ("Quyosh tig'ida uzoq qolish", False),
                    ("Ko'proq suyuqlik ichish", True),
                    ("Qalin kiyim kiyish", False),
                ],
            },
            {
                'text': "Iqlimga oid ogohlantirishlarni qanday kuzatish kerak?",
                'answers': [
                    ("Faqat mish-mishlar orqali", False),
                    ("Rasmiy ob-havo xabarlari orqali", True),
                    ("Tasodifiy taxmin bilan", False),
                    ("Faqat kechqurun", False),
                ],
            },
        ],
    },
]


class Command(BaseCommand):
    help = 'Seed demo categories, lessons, and quiz questions for local development.'

    @transaction.atomic
    def handle(self, *args, **options):
        created_categories = 0
        updated_lessons = 0
        synced_questions = 0

        for category_data in SEED_DATA:
            category, category_created = Category.objects.get_or_create(name=category_data['name'])
            created_categories += int(category_created)

            lesson, _ = Lesson.objects.update_or_create(
                category=category,
                title=category_data['lesson_title'],
                defaults={'content': category_data['lesson_content']},
            )
            updated_lessons += 1

            lesson.blocks.all().delete()
            LessonBlock.objects.bulk_create(
                [
                    LessonBlock(
                        lesson=lesson,
                        order=block_data['order'],
                        block_type=block_data['block_type'],
                        title=block_data['title'],
                        body=block_data['body'],
                        media_url=block_data['media_url'],
                    )
                    for block_data in category_data.get('lesson_blocks', [])
                ]
            )

            for question_data in category_data['questions']:
                question, _ = Question.objects.get_or_create(
                    category=category,
                    text=question_data['text'],
                )
                question.answers.all().delete()
                Answer.objects.bulk_create(
                    [
                        Answer(question=question, text=answer_text, is_correct=is_correct)
                        for answer_text, is_correct in question_data['answers']
                    ]
                )
                synced_questions += 1

        self.stdout.write(
            self.style.SUCCESS(
                f'Seeded {created_categories} new categories, synced {updated_lessons} lessons, '
                f'and synced {synced_questions} questions.'
            )
        )
