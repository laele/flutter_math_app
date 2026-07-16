import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';

class HomeAnimatedTextBubble extends StatefulWidget {
  const HomeAnimatedTextBubble({super.key});

  @override
  State<HomeAnimatedTextBubble> createState() => _HomeAnimatedTextBubbleState();
}

class _HomeAnimatedTextBubbleState extends State<HomeAnimatedTextBubble> {
  double _scale = 1;
  void _bounce() async {
    setState(() => _scale = 0.55);

    await Future.delayed(const Duration(milliseconds: 100));

    setState(() => _scale = 1.55);

    await Future.delayed(const Duration(milliseconds: 150));

    setState(() => _scale = 1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      buildWhen: (previous, current) {
        if (previous.message != current.message) {
          _bounce();
          return true;
        }
        return false;
      },
      builder: (context, state) => state.message != '' && state.message != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedScale(
                scale: _scale,
                duration: Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                child: Container(
                  //color: Colors.yellow,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      32.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: AnimatedTextKit(
                      key: ValueKey(state.message),
                      totalRepeatCount: 1,
                      animatedTexts: [
                        TyperAnimatedText(
                          state.message!,
                          textAlign: TextAlign.center,
                          textStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            color: Colors.pink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
