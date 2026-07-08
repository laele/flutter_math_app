import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            context.read<InputRecognitionCubit>().clearCanvas();
          },
          child: Icon(Icons.delete),
        ),
      ],
    );
  }
}
