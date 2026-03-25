from rest_framework import serializers

from .models import Answer, Question, TestResult


class AnswerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Answer
        fields = ['id', 'text']


class QuestionSerializer(serializers.ModelSerializer):
    answers = AnswerSerializer(many=True, read_only=True)

    class Meta:
        model = Question
        fields = ['id', 'category', 'text', 'answers']


class SubmitTestSerializer(serializers.Serializer):
    answers = serializers.DictField(child=serializers.IntegerField(), allow_empty=False)


class TestResultSerializer(serializers.ModelSerializer):
    class Meta:
        model = TestResult
        fields = ['id', 'user', 'score', 'created_at']
        read_only_fields = ['id', 'created_at']
