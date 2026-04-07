import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('education', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='LessonBlock',
            fields=[
                (
                    'id',
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name='ID',
                    ),
                ),
                ('order', models.PositiveIntegerField(default=0)),
                (
                    'block_type',
                    models.CharField(
                        choices=[
                            ('text', 'Text'),
                            ('image', 'Image'),
                            ('video', 'Video'),
                            ('audio', 'Audio'),
                            ('checklist', 'Checklist'),
                        ],
                        max_length=20,
                    ),
                ),
                ('title', models.CharField(blank=True, max_length=255)),
                ('body', models.TextField(blank=True)),
                ('media_url', models.URLField(blank=True)),
                (
                    'lesson',
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE,
                        related_name='blocks',
                        to='education.lesson',
                    ),
                ),
            ],
            options={
                'ordering': ('order', 'id'),
            },
        ),
    ]
