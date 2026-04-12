from rest_framework import generics
from rest_framework.response import Response

from .models import Category, Lesson, LessonBlock
from .serializers import (
    CategorySerializer,
    LessonBlockSerializer,
    LessonBlockWriteSerializer,
    LessonSerializer,
)


class CategoryListAPIView(generics.ListAPIView):
    queryset = Category.objects.all().order_by('name')
    serializer_class = CategorySerializer


class LessonListAPIView(generics.ListCreateAPIView):
    queryset = Lesson.objects.select_related('category').prefetch_related('blocks').all().order_by('id')
    serializer_class = LessonSerializer


class LessonDetailAPIView(generics.RetrieveAPIView):
    queryset = Lesson.objects.select_related('category').prefetch_related('blocks').all()
    serializer_class = LessonSerializer


class LessonBlockListCreateAPIView(generics.ListCreateAPIView):
    queryset = LessonBlock.objects.select_related('lesson', 'lesson__category').all().order_by('order', 'id')

    def get_serializer_class(self):
        if self.request.method == 'POST':
            return LessonBlockWriteSerializer
        return LessonBlockSerializer

    def create(self, request, *args, **kwargs):
        write_serializer = self.get_serializer(data=request.data)
        write_serializer.is_valid(raise_exception=True)
        block = write_serializer.save()
        read_serializer = LessonBlockSerializer(block, context=self.get_serializer_context())
        headers = self.get_success_headers(read_serializer.data)
        return Response(read_serializer.data, status=201, headers=headers)
