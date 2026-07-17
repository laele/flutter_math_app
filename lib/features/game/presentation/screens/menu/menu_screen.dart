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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Menu Options', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              SizedBox(height: 16.0),
              FilledButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 32, width: 32, child: Image.asset('lib/core/assets/images/how_to_play_icon.png')),
                    SizedBox(width: 8.0),
                    Text('How to play'),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Text('Selected modes you want to integrate playing', style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 4.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<GameCubit, GameState>(
                    buildWhen: (previous, current) {
                      if (previous.selectedGameModes != current.selectedGameModes) {
                        return true;
                      }
                      return true;
                    },
                    builder: (context, state) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final itemsPerRow = 4;
                          final minItemWidth = 20.0;
                          final maxItemWidth = 150.0;
                          final calculateWidth = constraints.maxWidth / itemsPerRow;
                          double finalWidth;
                          if (calculateWidth < minItemWidth) {
                            finalWidth = minItemWidth;
                          } else if (calculateWidth > maxItemWidth) {
                            finalWidth = maxItemWidth;
                          } else {
                            finalWidth = calculateWidth;
                          }
                          return Wrap(
                            alignment: WrapAlignment.center,
                            children: GameModes.items
                                .map(
                                  (gameMode) => GameModeItem(
                                    itemWidth: finalWidth,
                                    title: gameMode.title,
                                    isSelected: state.selectedGameModes.contains(gameMode.gameMode),
                                    gameMode: gameMode.gameMode,
                                  ),
                                )
                                .toList(),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 8.0),

              FilledButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 32, width: 32, child: Image.asset('lib/core/assets/images/lang_icon.png')),
                    SizedBox(width: 8.0),
                    Text('Change Language'),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Close'),
                    SizedBox(width: 8.0),
                    Icon(Icons.close),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
