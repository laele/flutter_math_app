import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';
import 'package:flutter_svg/svg.dart';

class HomeLearnNumbers extends StatelessWidget {
  const HomeLearnNumbers({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      buildWhen: (previous, current) {
        if (previous.gameMode != current.gameMode) {
          return true;
        }

        if (current.gameMode == GameMode.learnNumbers && previous.result != current.result) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        //final svgShowing =  state.result != null && state.result < 10;

        return Opacity(
          opacity: 0.2,
          child: Container(
            //color: Colors.yellow,
            child: Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final side = constraints.maxWidth < constraints.maxHeight ? constraints.maxWidth : constraints.maxHeight;
                      const sizeMin = 220.0;
                      const sizeMax = 480.0;
                      final size = side.clamp(sizeMin, sizeMax);
                      return Center(
                        child: SizedBox(
                          width: size,
                          height: size,
                          child: Container(
                            //color: Colors.red,
                            child: FittedBox(
                              child: Column(
                                children: [
                                  SvgPicture.asset('lib/core/assets/images/numero_${state.result}.svg'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
