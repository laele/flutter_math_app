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
          hideOperation: true,
          //gameMode: GameMode.menu,
          //currentQuestionMode: GameMode.menu,
          selectedGameModes: GameModes.items.map((e) => e.gameMode).toList(),
          currentExercise: 0,
        ),
      );

  void generateNextLevel() async {
    final nextGameMode = _mixModeSelector.pickNext(
      candidates: state.selectedGameModes,
      stats: state.stats,
    );
    final tiers = DifficultyTiers.byMode[nextGameMode];
    if (tiers == null) return;

    final currentGameStats = state.gameStats(nextGameMode);

    final currentTier = tiers[currentGameStats.currentTierIndex];
    final generator = QuestionGeneratorFactory.forMode(nextGameMode);
    final question = generator.generate(currentTier);
    emit(
      state.copyWith(
        canDraw: true,
        currentGameMode: nextGameMode,
        firstNum: question.firstNum,
        secNum: question.secNum,
        result: question.resultNum,
        hideOperation: false,
        message: _messageFromNewQuestion(
          gameMode: nextGameMode,
          question: question,
        ),
      ),
    );
    await playAnimation(animation: PetAnimation.thinking);
  }

  void checkResult(int result) async {
    emit(state.copyWith(canDraw: false));
    final wasCorrect = (result == state.result);
    final gameMode = state.currentGameMode;
    final tiers = DifficultyTiers.byMode[gameMode];

    var newStats = state.currentGameStats.recordAttempt(wasCorrect);

    final isLevelUp = wasCorrect && tiers != null && newStats.shouldLevelUp && newStats.currentTierIndex < tiers.length - 1;
    final isLevelDown = !wasCorrect && tiers != null && newStats.shouldLevelDown && newStats.currentTierIndex > 0;

    if (isLevelUp) {
      newStats = newStats.copyWith(currentTierIndex: newStats.currentTierIndex + 1).resetRegistry();
    } else if (isLevelDown) {
      newStats = newStats.copyWith(currentTierIndex: newStats.currentTierIndex - 1).resetRegistry();
    }

    _setNewStats(gameMode!, newStats);

    if (isLevelUp) {
      emit(state.copyWith(hideOperation: true));
      await playAnimation(animation: PetAnimation.success, message: 'Excellent! You are getting better!');
    } else if (wasCorrect) {
      emit(state.copyWith(hideOperation: true));
      await playAnimation(animation: PetAnimation.success, message: 'Amazing, Let\'s try next number!');
    } else if (isLevelDown) {
      emit(state.copyWith(hideOperation: true));
      await playAnimation(
        message: 'Let\'s try an easier one!', // change to lower level message
        animation: PetAnimation.failed,
        //clearAfterShow: true,
      );
    } else {
      await playAnimation(message: 'Nope, Try it again!', animation: PetAnimation.failed, clearAfterShow: true);
    }

    if ((wasCorrect || isLevelDown) && !state.showMenu) generateNextLevel();
  }

  String _messageFromNewQuestion({required GameMode gameMode, required GameQuestionEntity question}) {
    return switch (gameMode) {
      GameMode.learnNumbers => 'Draw this number!',
      GameMode.add => 'Let\'s add these numbers!',
      GameMode.sub => 'Time to substract!',
      GameMode.mult => 'Let\'s multiply!',
      GameMode.div => 'Can you solve this division?',
      _ => '',
    };
  }

  void _setNewStats(GameMode mode, GameStatsEntity newStats) {
    final stats = Map<GameMode, GameStatsEntity>.from(state.stats)..[mode] = newStats;
    emit(state.copyWith(stats: stats));
  }

  Future<void> playAnimation({String? message, required PetAnimation animation, bool clearAfterShow = false, bool? canDraw}) async {
    if (canDraw != null && canDraw == false) {
      emit(state.copyWith(canDraw: false));
    }
    if (clearAfterShow) {
      final String? previousMessage = state.message;
      emit(state.copyWith(petAnimation: animation, message: message, playAnimation: true));

      await Future.delayed(Duration(seconds: 6));

      if (!state.showMenu) {
        emit(state.copyWith(message: previousMessage, canDraw: true, petAnimation: PetAnimation.thinking, playAnimation: true));
      }
      return;
    } else {
      emit(state.copyWith(petAnimation: animation, message: message, playAnimation: true));
      await Future.delayed(Duration(seconds: 6));
    }
  }

  void setPlayAnimation({required bool playAnimation}) {
    emit(state.copyWith(playAnimation: playAnimation));
  }

  // Menu Events----

  void startGame() {
    emit(state.copyWith(canDraw: true, showMenu: false));
    generateNextLevel();
  }

  void backToMenu() async {
    _mixModeSelector.reset();
    emit(
      state.copyWith(canDraw: false, showMenu: true, hideOperation: true),
    );
    await playAnimation(message: 'Tap play to start a game!', animation: PetAnimation.success);
  }

  void setGameModes(GameMode gameMode) {
    final selectedGameModes = List<GameMode>.from(state.selectedGameModes);

    if (selectedGameModes.contains(gameMode)) {
      if (selectedGameModes.length < 2) return;
      selectedGameModes.remove(gameMode);
    } else {
      selectedGameModes.add(gameMode);
    }

    emit(state.copyWith(selectedGameModes: selectedGameModes));
  }

  // --------------
}
