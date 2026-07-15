import 'dart:math';
import 'package:flutter_math_app/features/game/domain/entities/game_stats_entity.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';

class MixModeSelector {
  MixModeSelector([Random? random]) : _random = random ?? Random();

  final Random _random;
  final List<GameMode> _rencentPicks = [];

  static const int _historySize = 2;
  static const double _strugglingBoost = 2.0;
  static const double _inmediateRepeatPenalty = 0.05;

  GameMode pickNext({
    required List<GameMode> candidates,
    required Map<GameMode, GameStatsEntity> stats,
  }) {
    assert(candidates.isNotEmpty, 'selectedGameModes must not be null');
    if (candidates.length == 1) return candidates.first;

    final weights = <GameMode, double>{for (final mode in candidates) mode: _weightFor(stats[mode])};

    if (_rencentPicks.isNotEmpty) {
      final last = _rencentPicks.last;
      weights[last] = (weights[last] ?? 1.0) * _inmediateRepeatPenalty;
    }

    final picked = _weightedPick(weights);
    _registerPick(picked);
    return picked;
  }

  double _weightFor(GameStatsEntity? entity) {
    final stats = entity ?? const GameStatsEntity();
    return 1.0 + stats.errorRate * _strugglingBoost;
  }

  GameMode _weightedPick(Map<GameMode, double> weights) {
    final total = weights.values.fold<double>(0, (a, b) => a + b);
    double roll = _random.nextDouble() * total;

    for (final entry in weights.entries) {
      roll -= entry.value;
      if (roll <= 0) return entry.key;
    }

    return weights.keys.last;
  }

  void _registerPick(GameMode mode) {
    _rencentPicks.add(mode);
    if (_rencentPicks.length > _historySize) _rencentPicks.removeAt(0);
  }

  void reset() => _rencentPicks.clear();
}
