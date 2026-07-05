part of 'game_cubit.dart';

enum PetAnimation { idle, thinking, failed, success }

class GameState extends Equatable {
  final PetAnimation petAnimation;
  final Uint8List? imageBytes;
  const GameState({required this.petAnimation, this.imageBytes});

  GameState copyWith({
    PetAnimation? petAnimation,
    Uint8List? imageBytes,
  }) {
    return GameState(
      petAnimation: petAnimation ?? this.petAnimation,
      imageBytes: imageBytes ?? this.imageBytes,
    );
  }

  @override
  List<Object?> get props => [petAnimation, imageBytes];
}
