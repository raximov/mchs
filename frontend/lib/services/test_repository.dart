import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/question.dart';
import 'api_client.dart';

class TestRepository {
  TestRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Question>> fetchByCategory(int categoryId) async {
    try {
      final response = await _apiClient.getList('/api/questions?category_id=$categoryId');
      await _cacheList('questions_$categoryId', response);
      return response.map((e) => Question.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      final cached = await _getCachedList('questions_$categoryId');
      return cached.map((e) => Question.fromJson(e)).toList();
    }
  }

  Future<List<Question>> fetchRandom() async {
    try {
      final response = await _apiClient.getList('/api/random-test');
      await _cacheList('random_test', response);
      return response.map((e) => Question.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      final cached = await _getCachedList('random_test');
      return cached.map((e) => Question.fromJson(e)).toList();
    }
  }

  Future<int?> submitAnswers(Map<int, int> answers) async {
    final payload = {
      'answers': answers.map((key, value) => MapEntry(key.toString(), value)),
    };
    final response = await _apiClient.post('/api/submit-test', payload);
    return response['score'] as int?;
  }

  Future<void> _cacheList(String key, List<dynamic> value) async {
    final box = await Hive.openBox<String>('offline_cache');
    await box.put(key, jsonEncode(value));
  }

  Future<List<Map<String, dynamic>>> _getCachedList(String key) async {
    final box = await Hive.openBox<String>('offline_cache');
    final raw = box.get(key);
    if (raw == null) {
      return [];
    }
    return (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
  }
}
