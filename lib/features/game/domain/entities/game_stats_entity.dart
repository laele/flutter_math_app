import 'package:equatable/equatable.dart';

class GameStatsEntity extends Equatable {
  final int correctStreak;
  final int failedStreak;
  final int currentTierIndex;
  final int attempts;
  final int correctCount;

  const GameStatsEntity({
    this.correctStreak = 0,
    this.failedStreak = 0,
    this.currentTierIndex = 0,
    this.attempts = 0,
    this.correctCount = 0,
  });

  double get errorRate => attempts == 0 ? 1.0 : 1 - (correctCount / attempts);

  GameStatsEntity copyWith({
    int? correctStreak,
    int? failedStreak,
    int? currentTierIndex,
    int? attempts,
    int? correctCount,
  }) {
    return GameStatsEntity(
      correctStreak: correctStreak ?? this.correctStreak,
      failedStreak: failedStreak ?? this.failedStreak,
      currentTierIndex: currentTierIndex ?? this.currentTierIndex,
      attempts: attempts ?? this.attempts,
      correctCount: correctCount ?? this.correctCount,
    );
  }

  @override
  List<Object?> get props => [
    correctStreak,
    failedStreak,
    currentTierIndex,
    correctCount,
    attempts,
  ];
}
