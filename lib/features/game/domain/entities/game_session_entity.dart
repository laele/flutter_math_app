import 'package:equatable/equatable.dart';
import 'package:flutter_math_app/core/constants/app_game.dart';

class GameSessionEntity extends Equatable {
  final int questionsPerSession = 5;

  final int questionsAnswered;
  final int correctCount;
  final int incorrectCount;
  final int incorrectStreak;

  const GameSessionEntity({
    this.questionsAnswered = 0,
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.incorrectStreak = 0,
  });

  bool get isCompleted => questionsAnswered >= questionsPerSession;
  bool get isQuestionAnsweredByIncorrectTries =>
      this.incorrectStreak >= AppGame.maxIncorectStreak;
  double get accuracy =>
      questionsAnswered == 0 ? 0 : (correctCount / questionsAnswered);
  GameSessionEntity recordAttempt({
    required bool wasCorrect,
  }) {
    final bool increaseIncorrectCount =
        (wasCorrect ? this.incorrectStreak : this.incorrectStreak + 1) >=
        AppGame.maxIncorectStreak;

    return GameSessionEntity(
      correctCount: this.correctCount + (wasCorrect ? 1 : 0),
      incorrectCount: increaseIncorrectCount
          ? this.incorrectCount + 1
          : this.incorrectCount,
      incorrectStreak: this.incorrectStreak + (!wasCorrect ? 1 : 0),
      questionsAnswered: (wasCorrect || increaseIncorrectCount)
          ? this.questionsAnswered + 1
          : this.questionsAnswered,
    );
  }

  GameSessionEntity cleanIncorrectStreak() {
    return GameSessionEntity(
      correctCount: this.correctCount,
      incorrectCount: this.incorrectCount,
      incorrectStreak: 0,
      questionsAnswered: this.questionsAnswered,
    );
  }

  GameSessionEntity copyWith({
    int? incorrectStreak,
    int? correctCount,
    int? incorrectCount,
    int? questionsAnswered,
  }) {
    return GameSessionEntity(
      incorrectStreak: incorrectStreak ?? this.incorrectStreak,
      questionsAnswered: questionsAnswered ?? this.questionsAnswered,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
    );
  }

  @override
  List<Object?> get props => [
    questionsAnswered,
    correctCount,
    incorrectCount,
    incorrectStreak,
  ];
}
