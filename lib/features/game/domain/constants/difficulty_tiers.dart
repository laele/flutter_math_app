import 'package:flutter_math_app/features/game/domain/entities/min_max_tier_entity.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';

class DifficultyTiers {
  static const Map<GameMode, List<MinMaxTierEntity>> byMode = {
    GameMode.learnNumbers: [
      MinMaxTierEntity(min: 0, max: 10), // Level 0
      MinMaxTierEntity(min: 1, max: 20), // Level 1
      MinMaxTierEntity(min: 1, max: 50), // Level 2
      MinMaxTierEntity(min: 1, max: 99), // Level 3
    ],
    GameMode.add: [
      MinMaxTierEntity(min: 1, max: 10), // Level 0
      MinMaxTierEntity(min: 1, max: 20), // Level 1
      MinMaxTierEntity(min: 1, max: 50), // Level 2
      MinMaxTierEntity(min: 1, max: 100), // Level 3
    ],
    GameMode.sub: [
      MinMaxTierEntity(min: 1, max: 10), // Level 0
      MinMaxTierEntity(min: 1, max: 20), // Level 1
      MinMaxTierEntity(min: 1, max: 50), // Level 2
      MinMaxTierEntity(min: 1, max: 100), // Level 3
    ],
    GameMode.mult: [
      MinMaxTierEntity(min: 1, max: 5), // Level 0
      MinMaxTierEntity(min: 1, max: 10), // Level 1
      MinMaxTierEntity(min: 1, max: 12), // Level 2
      MinMaxTierEntity(min: 1, max: 15), // Level 3
    ],
    GameMode.div: [
      MinMaxTierEntity(min: 1, max: 5), // Level 0
      MinMaxTierEntity(min: 1, max: 10), // Level 1
      MinMaxTierEntity(min: 1, max: 12), // Level 2
      MinMaxTierEntity(min: 1, max: 20), // Level 3
    ],
  };
}
