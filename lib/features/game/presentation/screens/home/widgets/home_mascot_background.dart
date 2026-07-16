import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_app/core/theme/app_gradients.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';
import 'package:flutter_math_app/features/game/presentation/screens/home/widgets/home_animated_text_bubble.dart';
import 'package:rive/rive.dart';

class HomeMascotBackground extends StatefulWidget {
  const HomeMascotBackground({super.key});

  @override
  State<HomeMascotBackground> createState() => _HomeMascotBackgroundState();
}

class _HomeMascotBackgroundState extends State<HomeMascotBackground> {
  late final FileLoader fileLoader;
  RiveWidgetController? _controller;
  TriggerInput? _triggerSuccess;
  TriggerInput? _triggerFailed;
  TriggerInput? _triggerThinking;

  @override
  void initState() {
    super.initState();
    fileLoader = FileLoader.fromAsset('lib/core/assets/rive/greg_the_frog.riv', riveFactory: Factory.rive);
    //context.read<GameCubit>().backToMenu();
  }

  @override
  void dispose() {
    super.dispose();
    fileLoader.dispose();
  }

  void _animationState(PetAnimation petAnimation) {
    switch (petAnimation) {
      case (PetAnimation.success):
        _triggerSuccess?.fire();
        break;
      case (PetAnimation.failed):
        _triggerFailed?.fire();
        break;
      case (PetAnimation.thinking):
        _triggerThinking?.fire();
        break;
      case _:
        break;
    }
    context.read<GameCubit>().setPlayAnimation(playAnimation: false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameCubit, GameState>(
      listenWhen: (previous, current) {
        if (previous.playAnimation != current.playAnimation) {
          print('prevous animation is diffentet from current animaiton');
          return true;
        }
        return false;
      },
      listener: (context, state) {
        _animationState(state.petAnimation);
      },
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppGradients.background,
                  ),
                ),
                //HomeLearnNumbers(),
                Align(
                  alignment: AlignmentGeometry.bottomCenter,
                  child: HomeAnimatedTextBubble(),
                ),
                BlocBuilder<GameCubit, GameState>(
                  buildWhen: (previous, current) {
                    if (previous.canDraw != current.canDraw) {
                      return true;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    return state.canDraw
                        ? BounceInDown(
                            from: 20,
                            duration: Duration(milliseconds: 300),
                            child: Align(
                              alignment: AlignmentGeometry.center,
                              child: Icon(
                                Icons.draw,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: RiveWidgetBuilder(
                fileLoader: fileLoader,
                builder: (context, state) => switch (state) {
                  RiveLoading() => Center(child: CircularProgressIndicator()),
                  RiveFailed() => Center(child: Text(state.error.toString())),
                  RiveLoaded() => Builder(
                    builder: (context) {
                      if (_controller != state.controller) {
                        _controller = state.controller;
                        _triggerSuccess = state.controller.stateMachine.trigger('Hi');

                        _triggerFailed = state.controller.stateMachine.trigger('Annoyed');
                        _triggerThinking = state.controller.stateMachine.trigger('Curious');
                        context.read<GameCubit>().backToMenu(); // TODO cambiar a cuando se genera el menu
                      }

                      return RiveWidget(controller: state.controller, fit: Fit.cover);
                    },
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
