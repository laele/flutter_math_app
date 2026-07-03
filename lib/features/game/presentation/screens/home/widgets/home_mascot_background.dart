import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';
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
    fileLoader = FileLoader.fromAsset('assets/greg_the_frog.riv', riveFactory: Factory.rive);
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameCubit, GameState>(
      listenWhen: (previous, current) {
        if (previous.petAnimation != current.petAnimation) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        _animationState(state.petAnimation);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
