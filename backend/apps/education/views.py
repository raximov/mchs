from rest_framework import generics

from .models import Category, Lesson
from .serializers import CategorySerializer, LessonSerializer


class CategoryListAPIView(generics.ListAPIView):
    queryset = Category.objects.all().order_by('name')
    serializer_class = CategorySerializer


class LessonListAPIView(generics.ListAPIView):
    queryset = Lesson.objects.select_related('category').prefetch_related('blocks').all().order_by('id')
    serializer_class = LessonSerializer


class LessonDetailAPIView(generics.RetrieveAPIView):
    queryset = Lesson.objects.select_related('category').prefetch_related('blocks').all()
    serializer_class = LessonSerializer
