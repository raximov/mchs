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

  final apiClient = ApiClient(baseUrl: 'http://10.0.2.2:8000');

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
