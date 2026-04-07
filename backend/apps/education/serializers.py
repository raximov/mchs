from rest_framework import serializers

from .models import Category, Lesson, LessonBlock


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'name']


class LessonBlockSerializer(serializers.ModelSerializer):
    class Meta:
        model = LessonBlock
        fields = ['id', 'order', 'block_type', 'title', 'body', 'media_url']


class LessonSerializer(serializers.ModelSerializer):
    category = CategorySerializer(read_only=True)
    blocks = LessonBlockSerializer(many=True, read_only=True)
    category_id = serializers.PrimaryKeyRelatedField(
        queryset=Category.objects.all(), source='category', write_only=True
    )

    class Meta:
        model = Lesson
        fields = ['id', 'category', 'category_id', 'title', 'content', 'blocks']
