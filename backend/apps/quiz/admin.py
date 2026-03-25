from django.contrib import admin

from .models import Answer, Question, TestResult


class AnswerInline(admin.TabularInline):
    model = Answer
    extra = 1


@admin.register(Question)
class QuestionAdmin(admin.ModelAdmin):
    list_display = ('id', 'text', 'category')
    list_filter = ('category',)
    search_fields = ('text',)
    inlines = [AnswerInline]


@admin.register(TestResult)
class TestResultAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'score', 'created_at')
    search_fields = ('user__username',)
    date_hierarchy = 'created_at'
