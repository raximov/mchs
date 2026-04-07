from django.conf import settings
from django.db import models

from apps.education.models import Category


class Question(models.Model):
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='questions')
    text = models.TextField()

    def __str__(self):
        return f'{self.category.name}: {self.text[:50]}'


class Answer(models.Model):
    question = models.ForeignKey(Question, on_delete=models.CASCADE, related_name='answers')
    text = models.CharField(max_length=255)
    is_correct = models.BooleanField(default=False)

    def __str__(self):
        return self.text


class TestResult(models.Model):



    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, null=True, blank=True)
=======
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)

=======
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)

=======
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)

    score = models.IntegerField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'{self.user} - {self.score}'
