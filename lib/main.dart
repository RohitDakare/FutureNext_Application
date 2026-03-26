import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/chat_provider.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final token = await ApiService.getToken();
  final quizProvider = QuizProvider();
  await quizProvider.loadPersistedData();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: quizProvider),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: FutureNextApp(isLoggedIn: token != null),
    ),
  );
}

class FutureNextApp extends StatelessWidget {
  final bool isLoggedIn;
  const FutureNextApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Future Next India',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: isLoggedIn ? const SplashScreen() : const LoginScreen(),
    );
  }
}
