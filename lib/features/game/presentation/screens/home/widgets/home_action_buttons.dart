import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';
import 'package:flutter_math_app/features/game/presentation/screens/menu/menu_screen.dart';

class HomeFloatingActionButtons extends StatelessWidget {
  const HomeFloatingActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      buildWhen: (previous, current) => previous.currentGameMode != current.currentGameMode,
      builder: (context, state) {
        if (state.showMenu) {
          // return Game Menu
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BounceInDown(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          MenuScreen.show(context);
                        },
                        child: Icon(Icons.menu),
                      ),
                    ),
                  ],
                ),
              ),

              BounceInDown(
                delay: Duration(milliseconds: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        context.read<GameCubit>().startGame();
                      },
                      child: Icon(Icons.play_arrow),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          // return Game Mode Menu
          return Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: BounceInDown(
                      child: FloatingActionButton(
                        onPressed: () {
                          context.read<GameCubit>().backToMenu();
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
