import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/category.dart';
import '../models/lesson.dart';
import 'api_client.dart';

class ContentRepository {
  ContentRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _apiClient.getList('/api/categories');
      await _cacheList('categories', response);
      return response.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      final cached = await _getCachedList('categories');
      if (cached.isNotEmpty) {
        return cached.map((e) => Category.fromJson(e)).toList();
      }
      final seeded = await _getSeededCategories();
      await _cacheList('categories', seeded);
      return seeded.map((e) => Category.fromJson(e)).toList();
    }
  }

  Future<List<Lesson>> fetchLessons() async {
    try {
      final response = await _apiClient.getList('/api/lessons');
      await _cacheList('lessons', response);
      return response.map((e) => Lesson.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      final cached = await _getCachedList('lessons');
      return cached.map((e) => Lesson.fromJson(e)).toList();
    }
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

  Future<List<Map<String, dynamic>>> _getSeededCategories() async {
    final raw = await rootBundle.loadString('assets/data/seed_content.json');
    final parsed = jsonDecode(raw) as Map<String, dynamic>;
    return (parsed['categories'] as List<dynamic>).cast<Map<String, dynamic>>();
  }
}
