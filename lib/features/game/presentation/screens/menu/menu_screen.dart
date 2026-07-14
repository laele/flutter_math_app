import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_app/core/theme/app_colors.dart';
import 'package:flutter_math_app/features/game/domain/constants/game_modes.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';
import 'package:flutter_math_app/features/game/presentation/screens/menu/widgets/game_mode_item.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.appBackground,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      context: context,
      builder: (context) => MenuScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Menu Options', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 12.0),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: FilledButton(
                      onPressed: () {
                        context.read<GameCubit>().startGameBySelectedMode(gameMode: GameMode.tutorial);
                        Navigator.pop(context);
                      },
                      child: Text('How to play ? '),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Text('Selected modes you want to integrate playing', style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 8.0),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: BlocBuilder<GameCubit, GameState>(
                      buildWhen: (previous, current) {
                        print('hello');
                        if (previous.selectedGameModes != current.selectedGameModes) {
                          print(current.selectedGameModes);
                          return true;
                        }
                        return true;
                      },
                      builder: (context, state) {
                        return Wrap(
                          children: GameModes.items
                              .map(
                                (gameMode) => GameModeItem(
                                  title: gameMode.title,
                                  isSelected: state.selectedGameModes.contains(gameMode.gameMode),
                                  gameMode: gameMode.gameMode,
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: FilledButton(onPressed: () {}, child: Text('Change Language')),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
