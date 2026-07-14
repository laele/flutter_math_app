import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_math_app/features/game/domain/constants/difficulty_tiers.dart';
import 'package:flutter_math_app/features/game/domain/constants/game_modes.dart';
import 'package:flutter_math_app/features/game/domain/entities/game_question_entity.dart';
import 'package:flutter_math_app/features/game/domain/entities/game_stats_entity.dart';
import 'package:flutter_math_app/features/game/domain/services/question_generator_factory.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit()
    : super(
        GameState(
          petAnimation: PetAnimation.idle,
          gameMode: GameMode.menu,
          selectedGameModes: GameModes.items.map((e) => e.gameMode).toList(),
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
      GameMode.sub => 'Time to substract! ${question.firstNum} - ${question.secNum}',
      GameMode.mult => 'Let\'s multiply!  ${question.firstNum} * ${question.secNum}',
      GameMode.div => 'Can you solve this division? ${question.firstNum} / ${question.secNum} ',
      _ => '',
    };
  }

  void checkResult(int result) async {
    if (result == state.result) {
      final tier = DifficultyTiers.byMode[state.gameMode];
      final newCorrectStreaks = state.currentGameStats.correctStreak + 1;
      final isChangetoNextLevel = tier != null && newCorrectStreaks > 4 && state.currentGameStats.currentTierIndex < tier.length - 1;

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
        await playAnimationWithMessageAndDelay(PetAnimation.success, 'Excellent! Here comes the next level!');
      } else {
        await playAnimationWithMessageAndDelay(PetAnimation.success, 'Amazing, Let\'s try next number!');
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
        await playAnimationWithMessageAndDelay(PetAnimation.failed, 'Let\'s try an easier one!');
        //playAnimation(PetAnimation.failed, 'Let\'s try an easier one!', clearAfterShow: true);
        generateNextLevel();
      } else {
        playAnimation(PetAnimation.failed, 'Nope, Try it again!', clearAfterShow: true);
      }
    }
  }

  void _setNewStats(GameMode mode, GameStatsEntity newStats) {
    final stats = Map<GameMode, GameStatsEntity>.from(state.stats)..[mode] = newStats;
    emit(state.copyWith(stats: stats));
  }

  void playPetSuccess({String? message, int? num, bool clearAfterShow = false}) {
    playAnimation(PetAnimation.success, 'It looks like a $num!', clearAfterShow: clearAfterShow);
  }

  void playPetThinking({String? message, bool clearAfterShow = false}) {
    playAnimation(PetAnimation.thinking, message, clearAfterShow: clearAfterShow);
  }

  void playPetFailed({String? message, bool clearAfterShow = false}) {
    playAnimation(PetAnimation.failed, message, clearAfterShow: clearAfterShow);
  }

  Future<void> playAnimationWithMessageAndDelay(PetAnimation animation, String? message) async {
    emit(state.copyWith(petAnimation: animation, message: message));
    await Future.delayed(Duration(seconds: 4));
  }

  void playAnimation(PetAnimation animation, String? message, {bool clearAfterShow = false}) async {
    if (clearAfterShow) {
      final String? previousMessage = state.message;

      emit(state.copyWith(petAnimation: animation, message: message));
      await Future.delayed(Duration(seconds: 4));
      if (state.gameMode != GameMode.menu) emit(state.copyWith(message: previousMessage));
      return;
    }
    emit(state.copyWith(petAnimation: animation, message: message));
  }

  void startGameBySelectedMode({required GameMode gameMode}) {
    emit(state.copyWith(gameMode: gameMode, canDraw: true));
    generateNextLevel();
  }

  void backToMenu() {
    emit(state.copyWith(gameMode: GameMode.menu, canDraw: false));
    clearMessage();
  }

  void setGameModes(GameMode gameMode) {
    final selectedGameModes = List<GameMode>.from(state.selectedGameModes);

    if (selectedGameModes.contains(gameMode)) {
      selectedGameModes.remove(gameMode);
    } else {
      selectedGameModes.add(gameMode);
    }

    emit(state.copyWith(selectedGameModes: selectedGameModes));
  }

  void clearMessage() {
    emit(state.copyWith(petAnimation: PetAnimation.idle, message: ''));
  }
}
