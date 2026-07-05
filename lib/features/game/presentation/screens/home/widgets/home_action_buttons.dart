import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';
import 'package:flutter_math_app/features/input_recognition/presentation/input_recognition_cubit/input_recognition_cubit.dart';

class HomeFloatingActionButtons extends StatelessWidget {
  final VoidCallback submitOnTap;

  const HomeFloatingActionButtons({super.key, required this.submitOnTap});

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
          child: Icon(Icons.more_horiz),
        ),
        SizedBox(height: 12),
        FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.delete),
        ),
        SizedBox(height: 12),
        FloatingActionButton(
          onPressed: submitOnTap,
          child: Icon(Icons.play_arrow),
        ),
      ],
    );
  }
}
