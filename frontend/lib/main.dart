import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'services/api_client.dart';
import 'services/app_state.dart';
import 'services/content_repository.dart';
import 'services/test_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final apiClient = ApiClient(baseUrl: _resolveApiBaseUrl());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppState(
            contentRepository: ContentRepository(apiClient),
            testRepository: TestRepository(apiClient),
          ),
        ),
      ],
      child: const LoyihaApp(),
    ),
  );
}

String _resolveApiBaseUrl() {
  const override = String.fromEnvironment('API_BASE_URL');
  if (override.isNotEmpty) {
    return override;
  }

  if (kIsWeb) {
    return 'https://mchs-3ewf.onrender.com/api';
  }

  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:8000';
  }

  return 'http://127.0.0.1:8000';
}

class LoyihaApp extends StatelessWidget {
  const LoyihaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOYIHA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
