part of 'game_cubit.dart';

enum PetAnimation { idle, thinking, failed, success }

enum GameMode { tutorial, learnNumbers, learnLetters, add, sub, mult, div, mix }

class GameState extends Equatable {
  final Map<GameMode, GameStatsEntity> stats;
  final PetAnimation petAnimation;
  final GameMode gameMode;
  final bool readyToClearMessage;
  final String? message;
  final int? firstNum;
  final int? secNum;
  final int? result;
  final String? letter;

  const GameState({
    required this.petAnimation,
    required this.gameMode,
    this.readyToClearMessage = false,
    this.stats = const {},
    this.message,
    this.result,
    this.firstNum,
    this.secNum,
    this.letter,
  });

  GameStatsEntity get currentGameStats => stats[gameMode] ?? GameStatsEntity();

  GameState copyWith({
    Map<GameMode, GameStatsEntity>? stats,
    PetAnimation? petAnimation,
    GameMode? gameMode,
    String? message,
    int? result,
    int? firstNum,
    int? secNum,
    String? letter,
    bool? readyToClearMessage,
  }) {
    return GameState(
      readyToClearMessage: readyToClearMessage ?? this.readyToClearMessage,
      stats: stats ?? this.stats,
      petAnimation: petAnimation ?? this.petAnimation,
      gameMode: gameMode ?? this.gameMode,
      message: message,
      result: result ?? this.result,
      firstNum: firstNum ?? this.firstNum,
      secNum: secNum ?? this.secNum,
      letter: letter ?? this.letter,
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
  ];
}
