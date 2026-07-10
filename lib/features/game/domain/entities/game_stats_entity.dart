import 'package:equatable/equatable.dart';

class GameStatsEntity extends Equatable {
  final int correctStreak;
  final int failedStreak;
  final int currentTierIndex;

  GameStatsEntity({
    this.correctStreak = 0,
    this.failedStreak = 0,
    this.currentTierIndex = 0,
  });

  GameStatsEntity copyWith({
    int? correctStreak,
    int? failedStreak,
    int? currentTierIndex,
  }) {
    return GameStatsEntity(
      correctStreak: correctStreak ?? this.correctStreak,
      failedStreak: failedStreak ?? this.failedStreak,
      currentTierIndex: currentTierIndex ?? this.currentTierIndex,
    );
  }

  @override
  List<Object?> get props => [
    correctStreak,
    failedStreak,
    currentTierIndex,
  ];
}
