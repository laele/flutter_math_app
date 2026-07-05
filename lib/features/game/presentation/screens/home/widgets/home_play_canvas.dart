import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';
import 'package:flutter_math_app/features/input_recognition/presentation/input_recognition_cubit/input_recognition_cubit.dart';
import 'package:scribble/scribble.dart';

class HomePlayCanvas extends StatefulWidget {
  const HomePlayCanvas({super.key});

  @override
  State<HomePlayCanvas> createState() => HomePlayCanvasState();
}

class HomePlayCanvasState extends State<HomePlayCanvas> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _fade = Tween<double>(begin: 1, end: 0).animate(
    CurvedAnimation(
      parent: controller,
      curve: const Interval(0.6, 1.0),
    ),
  );

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.5), weight: 40),
    //TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.5), weight: 60),
  ]).animate(CurvedAnimation(parent: controller, curve: const Interval(0.0, 1)));

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> playOutAnimation() async {
    await controller.forward();
    //context.read<GameCubit>().clearCanvas();
    //controller.reset();
  }

  void resetAnimation() async {
    controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final inputRecognitionCubit = context.read<InputRecognitionCubit>();
    return Column(
      children: [
        Expanded(
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fade.value,
                child: Transform.scale(
                  scale: _scale.value,
                  child: Scribble(
                    notifier: inputRecognitionCubit.notifier,
                    drawPen: true,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
