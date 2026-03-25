from django.urls import path

from .views import CategoryListAPIView, LessonDetailAPIView, LessonListAPIView

urlpatterns = [
    path('categories', CategoryListAPIView.as_view(), name='categories-list'),
    path('lessons', LessonListAPIView.as_view(), name='lessons-list'),
    path('lessons/<int:pk>', LessonDetailAPIView.as_view(), name='lesson-detail'),
]
