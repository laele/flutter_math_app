part of 'game_cubit.dart';

enum PetAnimation { idle, thinking, failed, success }

class GameState extends Equatable {
  final PetAnimation petAnimation;
  const GameState({required this.petAnimation});

  GameState copyWith({PetAnimation? petAnimation}) {
    return GameState(
      petAnimation: petAnimation ?? this.petAnimation,
    );
  }

  @override
  List<Object?> get props => [petAnimation];
}
