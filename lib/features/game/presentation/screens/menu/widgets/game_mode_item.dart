import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';

class GameModeItem extends StatelessWidget {
  final String title;
  final GameMode gameMode;
  final bool isSelected;
  const GameModeItem({super.key, required this.title, required this.isSelected, required this.gameMode});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<GameCubit>().setGameModes(gameMode);
      },
      child: SizedBox(
        height: 100,
        width: 100,
        child: Stack(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(32.0)),
              color: Colors.green,
              child: Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              //),
            ),
            Align(
              alignment: AlignmentGeometry.topRight,
              child: isSelected
                  ? BounceInDown(
                      duration: Duration(milliseconds: 500),
                      from: 20,
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
