from django.db import models


class Category(models.Model):
    name = models.CharField(max_length=255)

    class Meta:
        verbose_name_plural = 'Categories'

    def __str__(self):
        return self.name


class Lesson(models.Model):
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='lessons')
    title = models.CharField(max_length=255)
    content = models.TextField()

    def __str__(self):
        return self.title


class LessonBlock(models.Model):
    class BlockType(models.TextChoices):
        TEXT = 'text', 'Text'
        IMAGE = 'image', 'Image'
        VIDEO = 'video', 'Video'
        AUDIO = 'audio', 'Audio'
        CHECKLIST = 'checklist', 'Checklist'

    lesson = models.ForeignKey(Lesson, on_delete=models.CASCADE, related_name='blocks')
    order = models.PositiveIntegerField(default=0)
    block_type = models.CharField(max_length=20, choices=BlockType.choices)
    title = models.CharField(max_length=255, blank=True)
    body = models.TextField(blank=True)
    media_url = models.URLField(blank=True)

    class Meta:
        ordering = ('order', 'id')

    def __str__(self):
        return f'{self.lesson.title} - {self.block_type}'
