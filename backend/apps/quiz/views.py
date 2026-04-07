from django.db.models import QuerySet
from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import Question, TestResult
from .serializers import QuestionSerializer, SubmitTestSerializer
from .services import check_test


class QuestionListAPIView(generics.ListAPIView):
    serializer_class = QuestionSerializer

    def get_queryset(self) -> QuerySet[Question]:
        queryset = Question.objects.prefetch_related('answers').select_related('category').all()
        category_id = self.request.query_params.get('category_id')
        if category_id:
            queryset = queryset.filter(category_id=category_id)
        return queryset.order_by('id')


class RandomTestAPIView(generics.ListAPIView):
    serializer_class = QuestionSerializer

    def get_queryset(self) -> QuerySet[Question]:
        return Question.objects.prefetch_related('answers').select_related('category').order_by('?')[:10]


class SubmitTestAPIView(APIView):
<<<<<<< ours
<<<<<<< ours
    permission_classes = [permissions.AllowAny]
=======
    permission_classes = [permissions.IsAuthenticated]
>>>>>>> theirs
=======
    permission_classes = [permissions.IsAuthenticated]
>>>>>>> theirs

    def post(self, request):
        serializer = SubmitTestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        submitted_answers = {int(k): v for k, v in serializer.validated_data['answers'].items()}
        score = check_test(submitted_answers)

<<<<<<< ours
<<<<<<< ours
        user = request.user if request.user.is_authenticated else None
        result = TestResult.objects.create(user=user, score=score)
=======
        result = TestResult.objects.create(user=request.user, score=score)
>>>>>>> theirs
=======
        result = TestResult.objects.create(user=request.user, score=score)
>>>>>>> theirs
        return Response(
            {'result_id': result.id, 'score': score},
            status=status.HTTP_201_CREATED,
        )
