import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';

class HomeFloatingActionButtons extends StatelessWidget {
  const HomeFloatingActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () {
            context.read<GameCubit>().playPetSuccess();
          },
          child: Icon(Icons.back_hand),
        ),
        SizedBox(height: 12),
        FloatingActionButton(
          onPressed: () {
            context.read<GameCubit>().playPetFailed();
          },
          child: Icon(Icons.error),
        ),
        SizedBox(height: 12),

        FloatingActionButton(
          onPressed: () {
            context.read<GameCubit>().playPetThinking();
          },
          child: Icon(Icons.done),
        ),
      ],
    );
  }
}
