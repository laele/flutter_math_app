import 'package:flutter/material.dart';
import 'package:flutter_math_app/core/theme/app_theme.dart';
import 'package:flutter_math_app/features/game/presentation/screens/home/home_screen.dart';
import 'package:rive/rive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await RiveNative.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Froggy Math',
      theme: AppTheme.light(),
      home: HomeScreen(),
    );
  }
}
