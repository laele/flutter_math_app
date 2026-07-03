import 'package:flutter/material.dart';
import 'package:flutter_math_app/features/game/presentation/screens/home/widgets/home_action_buttons.dart';
import 'package:flutter_math_app/features/game/presentation/screens/home/widgets/home_mascot_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Froggy Math'),
        centerTitle: true,
      ),
      body: HomeMascotBackground(),
      floatingActionButton: HomeFloatingActionButtons(),
    );
  }
}
