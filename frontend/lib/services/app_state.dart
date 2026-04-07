


import 'package:flutter/foundation.dart' hide Category;
=======
import 'package:flutter/foundation.dart';

=======
import 'package:flutter/foundation.dart';

=======
import 'package:flutter/foundation.dart';


import '../models/category.dart';
import '../models/lesson.dart';
import '../models/question.dart';
import 'content_repository.dart';
import 'test_repository.dart';

class AppState extends ChangeNotifier {
  AppState({required ContentRepository contentRepository, required TestRepository testRepository})
      : _contentRepository = contentRepository,
        _testRepository = testRepository;

  final ContentRepository _contentRepository;
  final TestRepository _testRepository;

  List<Category> categories = [];
  List<Lesson> lessons = [];
  List<Question> questions = [];
  Map<int, int> selectedAnswers = {};
  bool loading = false;
  String? error;

  Future<void> loadHomeData() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      categories = await _contentRepository.fetchCategories();
      lessons = await _contentRepository.fetchLessons();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> loadTest({int? categoryId}) async {
    loading = true;
    selectedAnswers = {};
    error = null;
    notifyListeners();
    try {
      questions = categoryId == null
          ? await _testRepository.fetchRandom()
          : await _testRepository.fetchByCategory(categoryId);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void pickAnswer(int questionId, int answerId) {
    selectedAnswers[questionId] = answerId;
    notifyListeners();
  }

  Future<int> submit() async {
    final remoteScore = await _testRepository.submitAnswers(selectedAnswers);
    if (remoteScore != null) {
      return remoteScore;
    }
    return 0;
  }
}
