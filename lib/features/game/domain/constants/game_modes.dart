import 'package:flutter_math_app/features/game/domain/entities/game_mode_entity.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';

class GameModes {
  static List<GameModeEntity> items = [
    //GameModeEntity(gameMode: GameMode.tutorial, title: 'Tutorial'),
    //GameModeEntity(gameMode: GameMode.learnNumbers, title: 'Learn Numbers'),
    GameModeEntity(gameMode: GameMode.add, title: 'Add'),
    GameModeEntity(gameMode: GameMode.sub, title: 'Substract'),
    GameModeEntity(gameMode: GameMode.div, title: 'Division'),
    GameModeEntity(gameMode: GameMode.mult, title: 'Multiplicacion'),
    //GameModeEntity(gameMode: GameMode.mix, title: 'Mixed Mode'),
  ];
}
