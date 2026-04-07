from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('education', '0002_lessonblock'),
    ]

    operations = [
        migrations.AddField(
            model_name='lessonblock',
            name='media_file',
            field=models.FileField(blank=True, upload_to='lesson_blocks/'),
        ),
    ]
