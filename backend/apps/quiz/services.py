from apps.quiz.models import Answer


def check_test(user_answers: dict[int, int]) -> int:
    correct = 0
    for _, answer_id in user_answers.items():
        answer = Answer.objects.get(id=answer_id)
        if answer.is_correct:
            correct += 1
    return correct
