import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';
import 'package:scribble/scribble.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState(petAnimation: PetAnimation.idle));

  final ScribbleNotifier notifier = ScribbleNotifier();

  void initNotifier() {
    notifier.setColor(Color.fromARGB(255, 255, 255, 255));
    notifier.setStrokeWidth(8.0);
  }

  void clearCanvas() {
    playPetSuccess();
    notifier.clear();
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

  @override
  Future<void> close() {
    // TODO: implement close
    notifier.dispose();
    return super.close();
  }
}
