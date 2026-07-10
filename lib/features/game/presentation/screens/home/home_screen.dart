import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';
import 'package:flutter_math_app/features/game/presentation/screens/home/widgets/home_action_buttons.dart';
import 'package:flutter_math_app/features/game/presentation/screens/home/widgets/home_mascot_background.dart';
import 'package:flutter_math_app/features/game/presentation/screens/home/widgets/home_play_canvas.dart';
import 'package:flutter_math_app/features/input_recognition/presentation/input_recognition_cubit/input_recognition_cubit.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<HomePlayCanvasState> homePlayCanvasKey = GlobalKey<HomePlayCanvasState>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Stack(
        children: [
          HomeMascotBackground(),
          BlocBuilder<GameCubit, GameState>(
            buildWhen: (previous, current) {
              if (previous.currentGameStats != current.currentGameStats) {
                return true;
              }

              return false;
            },
            builder: (context, state) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('result: ${state.result}'),
                  Text('Game Mode: ${state.gameMode.name}'),
                  Text('Game Stats: ${state.currentGameStats}'),
                ],
              ),
            ),
          ),
          HomePlayCanvas(key: homePlayCanvasKey),
        ],
      ),
      floatingActionButton: HomeFloatingActionButtons(),
    );
  }
}
