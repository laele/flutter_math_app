import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState(petAnimation: PetAnimation.idle));

  void playPetSuccess() {
    emit(state.copyWith(petAnimation: PetAnimation.success));
  }

  void playPetThinking() {
    emit(state.copyWith(petAnimation: PetAnimation.thinking));
  }

  void playPetFailed() {
    emit(state.copyWith(petAnimation: PetAnimation.failed));
  }
}
