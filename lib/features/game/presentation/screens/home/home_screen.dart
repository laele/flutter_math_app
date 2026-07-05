import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        title: const Text('Froggy Math'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          HomeMascotBackground(),
          HomePlayCanvas(key: homePlayCanvasKey),
        ],
      ),
      floatingActionButton: HomeFloatingActionButtons(
        submitOnTap: () async {
          context.read<InputRecognitionCubit>().submitResult(
            canvasWidth: MediaQuery.sizeOf(context).width,
            canvasHeight: MediaQuery.sizeOf(context).height,
          );
          await homePlayCanvasKey.currentState?.playOutAnimation();
          context.read<InputRecognitionCubit>().clearCanvas();
          homePlayCanvasKey.currentState?.resetAnimation();
        },
      ),
    );
  }
}
