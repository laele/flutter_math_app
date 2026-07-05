import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState(petAnimation: PetAnimation.idle));

  void clearCanvas() {
    playPetSuccess();
  }

  void submitResult() async {
    playPetSuccess();
  }

  void playPetSuccess() {
    emit(state.copyWith(petAnimation: PetAnimation.success));
    emit(state.copyWith(petAnimation: PetAnimation.idle));
  }

  void playPetThinking() {
    emit(state.copyWith(petAnimation: PetAnimation.thinking));
    emit(state.copyWith(petAnimation: PetAnimation.idle));
  }

  void playPetFailed() {
    emit(state.copyWith(petAnimation: PetAnimation.failed));
    emit(state.copyWith(petAnimation: PetAnimation.idle));
  }
}
