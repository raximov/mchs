from rest_framework import serializers

from .models import Category, Lesson, LessonBlock


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['id', 'name']


class LessonBlockSerializer(serializers.ModelSerializer):
    file_url = serializers.SerializerMethodField()

    def get_file_url(self, obj):
        if not obj.media_file:
            return ''
        request = self.context.get('request')
        if request is None:
            return obj.media_file.url
        return request.build_absolute_uri(obj.media_file.url)

    class Meta:
        model = LessonBlock
        fields = ['id', 'order', 'block_type', 'title', 'body', 'media_url', 'file_url']


class LessonSerializer(serializers.ModelSerializer):
    category = CategorySerializer(read_only=True)
    blocks = LessonBlockSerializer(many=True, read_only=True)
    category_id = serializers.PrimaryKeyRelatedField(
        queryset=Category.objects.all(), source='category', write_only=True
    )

    class Meta:
        model = Lesson
        fields = ['id', 'category', 'category_id', 'title', 'content', 'blocks']
