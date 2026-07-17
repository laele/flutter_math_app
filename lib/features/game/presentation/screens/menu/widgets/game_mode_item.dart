import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';

class GameModeItem extends StatelessWidget {
  final double itemWidth;
  final String title;
  final GameMode gameMode;
  final bool isSelected;
  const GameModeItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.gameMode,
    required this.itemWidth,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<GameCubit>().setGameModes(gameMode);
      },
      child: SizedBox(
        height: itemWidth,
        width: itemWidth,
        child: Stack(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(32.0)),
              color: const Color.fromARGB(255, 184, 233, 255),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Image.asset('lib/core/assets/images/math_book.png')),
                      FittedBox(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
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
