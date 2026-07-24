import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_app/core/theme/app_colors.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';

class StarsScoreSection extends StatelessWidget {
  final double accuracy;
  const StarsScoreSection({super.key, required this.accuracy});

  int get _stars {
    if (accuracy >= 0.8) return 3;
    if (accuracy >= 0.5) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BounceInDown(
            delay: Duration(milliseconds: 200),
            child: StarItem(
              width: 60,
              height: 60,
              isCompleted: _stars > 1 ? true : false,
            ),
          ),
          SizedBox(width: 8),
          BounceInDown(
            child: StarItem(width: 120, height: 120, isCompleted: true),
          ),
          SizedBox(width: 8),
          BounceInDown(
            delay: Duration(milliseconds: 400),
            child: StarItem(
              width: 60,
              height: 60,
              isCompleted: _stars > 2 ? true : false,
            ),
          ),
        ],
      ),
    );
  }
}

class StarItem extends StatelessWidget {
  final double width;
  final double height;
  final bool isCompleted;
  const StarItem({
    super.key,
    required this.width,
    required this.height,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.onPrimaryBorder,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          width: width,
          height: height,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              'lib/core/assets/images/star.png',
              color: isCompleted ? null : const Color.fromARGB(255, 65, 65, 65),
            ),
          ),
        ),
      ),
    );
  }
}
