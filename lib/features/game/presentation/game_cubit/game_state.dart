part of 'game_cubit.dart';

enum PetAnimation { idle, thinking, failed, success }

enum GameMode { learnNumbers, add, sub, mult, div }

class GameState extends Equatable {
  final Map<GameMode, GameStatsEntity> stats;
  final PetAnimation petAnimation;
  final bool playAnimation;

  final GameMode? currentGameMode;
  final List<GameMode> selectedGameModes;

  final int currentExercise;

  final String? message;

  final int? firstNum;
  final int? secNum;
  final int? result;

  final bool canDraw;
  final bool showMenu;

  const GameState({
    required this.petAnimation,
    required this.selectedGameModes,
    required this.currentExercise,
    this.currentGameMode,
    this.stats = const {},
    this.message,
    this.result,
    this.firstNum,
    this.secNum,
    this.playAnimation = false,
    this.canDraw = false,
    this.showMenu = true,
  });

  GameStatsEntity get currentGameStats => stats[currentGameMode] ?? GameStatsEntity();
  GameStatsEntity gameStats(GameMode gameMode) => stats[gameMode] ?? GameStatsEntity();

  GameState copyWith({
    bool? playAnimation,
    bool? showMenu,
    Map<GameMode, GameStatsEntity>? stats,
    PetAnimation? petAnimation,
    GameMode? gameMode,
    GameMode? currentGameMode,
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
      playAnimation: playAnimation ?? this.playAnimation,
      showMenu: showMenu ?? this.showMenu,
      currentGameMode: currentGameMode ?? this.currentGameMode,
      selectedGameModes: selectedGameModes ?? this.selectedGameModes,
      stats: stats ?? this.stats,
      petAnimation: petAnimation ?? this.petAnimation,
      message: message ?? this.message,
      result: result ?? this.result,
      firstNum: firstNum ?? this.firstNum,
      secNum: secNum ?? this.secNum,
      canDraw: canDraw ?? this.canDraw,
      currentExercise: currentExercise ?? this.currentExercise,
    );
  }

  @override
  List<Object?> get props => [
    playAnimation,
    showMenu,
    stats,
    petAnimation,
    message,
    result,
    firstNum,
    secNum,
    canDraw,
    selectedGameModes,
    currentExercise,
    currentGameMode,
  ];
}
