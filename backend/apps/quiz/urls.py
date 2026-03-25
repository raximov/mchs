from django.urls import path

from .views import QuestionListAPIView, RandomTestAPIView, SubmitTestAPIView

urlpatterns = [
    path('questions', QuestionListAPIView.as_view(), name='questions-list'),
    path('random-test', RandomTestAPIView.as_view(), name='random-test'),
    path('submit-test', SubmitTestAPIView.as_view(), name='submit-test'),
]
