from django.contrib import admin

from .models import Category, Lesson, LessonBlock


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    search_fields = ('name',)
    list_display = ('id', 'name')


@admin.register(Lesson)
class LessonAdmin(admin.ModelAdmin):
    list_display = ('id', 'title', 'category')
    search_fields = ('title', 'content')
    list_filter = ('category',)


@admin.register(LessonBlock)
class LessonBlockAdmin(admin.ModelAdmin):
    list_display = ('id', 'lesson', 'order', 'block_type', 'title')
    list_filter = ('block_type', 'lesson__category')
    search_fields = ('lesson__title', 'title', 'body', 'media_url')
    fields = ('lesson', 'order', 'block_type', 'title', 'body', 'media_url', 'media_file')
