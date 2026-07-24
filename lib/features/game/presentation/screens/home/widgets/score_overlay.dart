import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_app/core/theme/app_colors.dart';

import 'package:flutter_math_app/features/audio/presentation/cubit/audio_cubit.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';
import 'package:flutter_math_app/features/game/presentation/screens/home/widgets/stars_score_section.dart';

class ScoreOverlay extends StatefulWidget {
  const ScoreOverlay({super.key});

  @override
  State<ScoreOverlay> createState() => _ScoreOverlayState();
}

class _ScoreOverlayState extends State<ScoreOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _fade = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(parent: controller, curve: const Interval(0.0, 1.0)),
  );

  late final Animation<double> _scale = TweenSequence<double>(
    [
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 40),
    ],
  ).animate(CurvedAnimation(parent: controller, curve: const Interval(0.0, 1)));

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> playInAnimation() async {
    await controller.forward(from: 0);
  }

  Future<void> playOutAnimation() async {
    await controller.reverse(from: 1);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<GameCubit, GameState>(
      listenWhen: (previous, current) =>
          previous.showScore != current.showScore,
      listener: (context, state) async {
        // TODO: implement listener
        if (state.showScore) {
          await playInAnimation();
          context.read<AudioCubit>().playSfxCorrect();
        }
      },
      buildWhen: (previous, current) => previous.showScore != current.showScore,

      builder: (context, state) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return state.showScore
                ? Opacity(
                    opacity: _fade.value,
                    child: Transform.scale(
                      scale: _scale.value,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 300),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Card(
                                color: colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    36.0,
                                  ),
                                ),
                                elevation: 25,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      StarsScoreSection(
                                        accuracy: state.gameSession.accuracy,
                                      ),
                                      SizedBox(height: 8.0),
                                      FittedBox(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AnimatedTextKit(
                                              pause: Duration(
                                                milliseconds: 200,
                                              ),
                                              repeatForever: true,
                                              isRepeatingAnimation: true,
                                              animatedTexts: [
                                                WavyAnimatedText(
                                                  'Game Completed!',
                                                  textStyle:
                                                      textTheme.displayLarge,
                                                  speed: Duration(
                                                    milliseconds: 300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 12.0),
                                      FilledButton(
                                        style: FilledButton.styleFrom(
                                          backgroundColor:
                                              AppColors.onPrimaryBorder,
                                        ),
                                        onPressed: () {},
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Play Again'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink();
          },
        );
      },
    );
  }
}
