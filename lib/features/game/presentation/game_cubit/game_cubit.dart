import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_math_app/features/game/domain/constants/difficulty_tiers.dart';
import 'package:flutter_math_app/features/game/domain/constants/game_modes.dart';
import 'package:flutter_math_app/features/game/domain/entities/game_question_entity.dart';
import 'package:flutter_math_app/features/game/domain/entities/game_stats_entity.dart';
import 'package:flutter_math_app/features/game/domain/services/mix_mode_selector.dart';
import 'package:flutter_math_app/features/game/domain/services/question_generator_factory.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  final MixModeSelector _mixModeSelector;

  GameCubit({MixModeSelector? mixModeSelector})
    : _mixModeSelector = mixModeSelector ?? MixModeSelector(),
      super(
        GameState(
          petAnimation: PetAnimation.idle,
          gameMode: GameMode.menu,
          currentQuestionMode: GameMode.menu,
          selectedGameModes: GameModes.items.map((e) => e.gameMode).toList(),
          currentExercise: 0,
        ),
      );

  void initStats() {
    final Map<GameMode, GameStatsEntity> stats = {
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
    final nextGameMode = _mixModeSelector.pickNext(candidates: state.selectedGameModes, stats: state.stats);
    final tiers = DifficultyTiers.byMode[nextGameMode];
    if (tiers == null) return;

    final currentTier = tiers[state.currentGameStats.currentTierIndex];
    final generator = QuestionGeneratorFactory.forMode(nextGameMode);
    final question = generator.generate(currentTier);
    emit(
      state.copyWith(
        currentQuestionMode: nextGameMode,
        firstNum: question.firstNum,
        secNum: question.secNum,
        result: question.resultNum,
        message: _messageFromNewQuestion(gameMode: nextGameMode, question: question),
      ),
    );
  }

  String _messageFromNewQuestion({required GameMode gameMode, required GameQuestionEntity question}) {
    return switch (gameMode) {
      GameMode.learnNumbers => 'Draw ${question.resultNum} number!',
      GameMode.add => 'Let\'s add these numbers! ${question.firstNum} + ${question.secNum}',
      GameMode.sub => 'Time to substract! ${question.firstNum} - ${question.secNum}',
      GameMode.mult => 'Let\'s multiply!  ${question.firstNum} * ${question.secNum}',
      GameMode.div => 'Can you solve this division? ${question.firstNum} / ${question.secNum} ',
      _ => '',
    };
  }

  void checkResult(int result) async {
    if (result == state.result) {
      final tier = DifficultyTiers.byMode[state.currentQuestionMode];
      final newCorrectStreaks = state.currentGameStats.correctStreak + 1;
      final isChangetoNextLevel = tier != null && newCorrectStreaks > 4 && state.currentGameStats.currentTierIndex < tier.length - 1;

      final newStats = isChangetoNextLevel
          ? state.currentGameStats.copyWith(
              correctStreak: 0,
              failedStreak: 0,
              currentTierIndex: state.currentGameStats.currentTierIndex + 1,
            )
          : state.currentGameStats
                .copyWith(
                  correctStreak: newCorrectStreaks,
                  failedStreak: 0,
                )
                .copyWith(attempts: state.currentGameStats.attempts + 1, correctCount: state.currentGameStats.correctCount + 1);

      _setNewStats(state.currentQuestionMode, newStats);

      if (isChangetoNextLevel) {
        await playAnimation(animation: PetAnimation.success, 'Excellent! Here comes the next level!');
      } else {
        await playAnimation(animation: PetAnimation.success, 'Amazing, Let\'s try next number!');
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
          : state.currentGameStats
                .copyWith(
                  correctStreak: 0,
                  failedStreak: newFailedStreaks,
                )
                .copyWith(attempts: state.currentGameStats.attempts + 1, correctCount: state.currentGameStats.correctCount - 1);
      print(newStats);
      _setNewStats(state.currentQuestionMode, newStats);

      if (isChangeToLowerLevel) {
        await playAnimation('Let\'s try an easier one!', animation: PetAnimation.failed, clearAfterShow: true);
        //playAnimation(PetAnimation.failed, 'Let\'s try an easier one!', clearAfterShow: true);
        generateNextLevel();
      } else {
        await playAnimation('Nope, Try it again!', animation: PetAnimation.failed, clearAfterShow: true);
      }
    }
  }

  void _setNewStats(GameMode mode, GameStatsEntity newStats) {
    final stats = Map<GameMode, GameStatsEntity>.from(state.stats)..[mode] = newStats;
    emit(state.copyWith(stats: stats));
  }

  void playPetThinking({String? message, bool clearAfterShow = false}) {
    playAnimation(message, animation: PetAnimation.thinking, clearAfterShow: clearAfterShow);
  }

  /*Future<void> playAnimationWithMessageAndDelay(PetAnimation animation, String? message) async {
    emit(state.copyWith(petAnimation: animation, message: message));
    await Future.delayed(Duration(seconds: 4));
  }*/

  Future<void> playAnimation(String? message, {required PetAnimation animation, bool clearAfterShow = false}) async {
    if (clearAfterShow) {
      final String? previousMessage = state.message;

      emit(state.copyWith(petAnimation: animation, message: message));
      await Future.delayed(Duration(seconds: 4));
      if (state.gameMode != GameMode.menu) emit(state.copyWith(message: previousMessage));
      return;
    } else {
      emit(state.copyWith(petAnimation: animation, message: message));
      await Future.delayed(Duration(seconds: 4));
    }
  }

  void clearMessage() {
    emit(state.copyWith(petAnimation: PetAnimation.idle, message: ''));
  }

  // Menu Events----

  void startGameBySelectedMode({required GameMode gameMode}) {
    emit(state.copyWith(gameMode: gameMode, canDraw: true));
    generateNextLevel();
  }

  void backToMenu() {
    _mixModeSelector.reset();
    emit(state.copyWith(gameMode: GameMode.menu, canDraw: false));
    playAnimation('Tap play to start a game!', animation: PetAnimation.success);
    //clearMessage();
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

  // --------------
}
