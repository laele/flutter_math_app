part of 'game_cubit.dart';

enum PetAnimation { idle, thinking, failed, success }

enum GameMode { tutorial, learnNumbers, add, sub, mult, div, menu }

class GameState extends Equatable {
  final Map<GameMode, GameStatsEntity> stats;
  final PetAnimation petAnimation;

  final GameMode gameMode;
  final GameMode currentQuestionMode;
  final List<GameMode> selectedGameModes;

  final int currentExercise;
  final bool readyToClearMessage;
  final String? message;
  final int? firstNum;
  final int? secNum;
  final int? result;
  final String? letter;
  final bool canDraw;

  const GameState({
    required this.petAnimation,
    required this.gameMode,
    required this.selectedGameModes,
    required this.currentExercise,
    required this.currentQuestionMode,
    this.readyToClearMessage = false,
    this.stats = const {},
    this.message,
    this.result,
    this.firstNum,
    this.secNum,
    this.letter,
    this.canDraw = false,
  });

  GameStatsEntity get currentGameStats => stats[currentQuestionMode] ?? GameStatsEntity();

  GameState copyWith({
    Map<GameMode, GameStatsEntity>? stats,
    PetAnimation? petAnimation,
    GameMode? gameMode,
    GameMode? currentQuestionMode,
    List<GameMode>? selectedGameModes,
    String? message,
    int? result,
    int? firstNum,
    int? secNum,
    String? letter,
    bool? readyToClearMessage,
    bool? canDraw,
    int? currentExercise,
  }) {
    return GameState(
      currentQuestionMode: currentQuestionMode ?? this.currentQuestionMode,
      selectedGameModes: selectedGameModes ?? this.selectedGameModes,
      readyToClearMessage: readyToClearMessage ?? this.readyToClearMessage,
      stats: stats ?? this.stats,
      petAnimation: petAnimation ?? this.petAnimation,
      gameMode: gameMode ?? this.gameMode,
      message: message ?? this.message,
      result: result ?? this.result,
      firstNum: firstNum ?? this.firstNum,
      secNum: secNum ?? this.secNum,
      letter: letter ?? this.letter,
      canDraw: canDraw ?? this.canDraw,
      currentExercise: currentExercise ?? this.currentExercise,
    );
  }

  @override
  List<Object?> get props => [
    readyToClearMessage,
    stats,
    petAnimation,
    gameMode,
    message,
    result,
    firstNum,
    secNum,
    letter,
    canDraw,
    selectedGameModes,
    currentExercise,
    currentQuestionMode,
  ];
}
