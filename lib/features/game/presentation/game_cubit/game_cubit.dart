import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_math_app/features/game/domain/constants/difficulty_tiers.dart';
import 'package:flutter_math_app/features/game/domain/entities/game_question_entity.dart';
import 'package:flutter_math_app/features/game/domain/entities/game_stats_entity.dart';
import 'package:flutter_math_app/features/game/domain/services/question_generator_factory.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit()
    : super(
        GameState(
          petAnimation: PetAnimation.idle,
          gameMode: GameMode.learnNumbers,
        ),
      );

  void initStats() {
    final Map<GameMode, GameStatsEntity> stats = {
      GameMode.learnNumbers: GameStatsEntity(
        correctStreak: 0,
        failedStreak: 0,
        currentTierIndex: 0,
      ),
      GameMode.add: GameStatsEntity(
        correctStreak: 0,
        failedStreak: 0,
        currentTierIndex: 0,
      ),
      GameMode.sub: GameStatsEntity(
        correctStreak: 0,
        failedStreak: 0,
        currentTierIndex: 0,
      ),
      GameMode.div: GameStatsEntity(
        correctStreak: 0,
        failedStreak: 0,
        currentTierIndex: 0,
      ),
      GameMode.mult: GameStatsEntity(
        correctStreak: 0,
        failedStreak: 0,
        currentTierIndex: 0,
      ),
    };

    emit(state.copyWith(stats: stats));
  }

  void setClearMessageToTrue() {
    emit(state.copyWith(readyToClearMessage: true));
  }

  void setClearMessageToFalse() {
    emit(state.copyWith(readyToClearMessage: false));
  }

  void generateNextLevel() {
    // Check gameMode
    final tiers = DifficultyTiers.byMode[state.gameMode];
    if (tiers == null) return;

    final currentTier = tiers[state.currentGameStats.currentTierIndex];
    final generator = QuestionGeneratorFactory.forMode(state.gameMode);
    final question = generator.generate(currentTier);
    emit(
      state.copyWith(
        firstNum: question.firstNum,
        secNum: question.secNum,
        result: question.resultNum,
        message: _messageFromNewQuestion(question: question),
      ),
    );
  }

  String _messageFromNewQuestion({required GameQuestionEntity question}) {
    return switch (state.gameMode) {
      GameMode.learnNumbers => 'Draw ${question.resultNum} number!',
      GameMode.learnLetters => '',
      GameMode.add => 'Let\'s add these numbers! ${question.firstNum} + ${question.secNum}',
      GameMode.sub => 'Time to subtract! ${question.firstNum} - ${question.secNum}',
      GameMode.mult => 'Let\'s multiply!  ${question.firstNum} * ${question.secNum}',
      GameMode.div => 'Can you solve this division? ${question.firstNum} / ${question.secNum} ',
      _ => '',
    };
  }

  void checkResult(int result) {
    if (result == state.result) {
      final tier = DifficultyTiers.byMode[state.gameMode];
      final newCorrectStreaks = state.currentGameStats.correctStreak + 1;
      final isChangetoNextLevel = tier != null && newCorrectStreaks > 1 && state.currentGameStats.currentTierIndex < tier.length - 1;

      final newStats = isChangetoNextLevel
          ? state.currentGameStats.copyWith(
              correctStreak: 0,
              failedStreak: 0,
              currentTierIndex: state.currentGameStats.currentTierIndex + 1,
            )
          : state.currentGameStats.copyWith(
              correctStreak: newCorrectStreaks,
              failedStreak: 0,
            );

      _setNewStats(state.gameMode, newStats);

      if (isChangetoNextLevel) {
        playAnimation(PetAnimation.success, 'Excellent! Here comes the next level!');
      } else {
        playAnimation(PetAnimation.success, 'Amazing, Let\'s try next number!');
      }
      generateNextLevel();
    } else {
      final newFailedStreaks = state.currentGameStats.failedStreak + 1;
      final isChangeToLowerLevel = newFailedStreaks > 2 && state.currentGameStats.currentTierIndex > 0;

      final newStats = isChangeToLowerLevel
          ? state.currentGameStats.copyWith(
              correctStreak: 0,
              failedStreak: 0,
              currentTierIndex: state.currentGameStats.currentTierIndex - 1,
            )
          : state.currentGameStats.copyWith(
              correctStreak: 0,
              failedStreak: newFailedStreaks,
            );
      _setNewStats(state.gameMode, newStats);

      if (isChangeToLowerLevel) {
        playAnimation(PetAnimation.failed, 'Let\'s try an easier one!');
        generateNextLevel();
      } else {
        playAnimation(PetAnimation.failed, 'Nope, Try it again!');
      }
    }
  }

  void _setNewStats(GameMode mode, GameStatsEntity newStats) {
    final stats = Map<GameMode, GameStatsEntity>.from(state.stats)..[mode] = newStats;
    emit(state.copyWith(stats: stats));
  }

  void playPetSuccess({String? message, int? num}) {
    playAnimation(PetAnimation.success, 'It looks like a $num!');
  }

  void playPetThinking({String? message}) {
    playAnimation(PetAnimation.thinking, message);
  }

  void playPetFailed({String? message}) {
    playAnimation(PetAnimation.failed, message);
  }

  void playAnimation(PetAnimation animation, String? message) {
    emit(
      state.copyWith(petAnimation: animation, message: message),
    );
  }

  void clearMessage() {
    emit(state.copyWith(petAnimation: PetAnimation.idle, message: null));
  }
}
