import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_math_app/features/audio/domain/entities/background_song_entity.dart';
import 'package:flutter_math_app/features/audio/domain/entities/sound_effect_entity.dart';
import 'package:flutter_math_app/features/audio/domain/repositories/audio_repository.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  final AudioRepository _audioRepository;
  AudioCubit({required AudioRepository audioRepository})
    : _audioRepository = audioRepository,
      super(const AudioState());

  void initAudio() async {
    await _audioRepository.initAudio();
    emit(state.copyWith(audioLoaded: true));
    //playBackgroundMusic();
  }

  void toggleSfxMute() {
    final sfxMuted = !state.sfxMuted;
    _audioRepository.setSfxMuted(muted: sfxMuted);
    emit(state.copyWith(sfxMuted: sfxMuted));
  }

  void toggleMusicMute() {
    final musicMuted = !state.musicMuted;
    _audioRepository.setTrackMuted(muted: musicMuted);
    emit(state.copyWith(musicMuted: musicMuted));
  }

  void setMusicVolume(double volume) {
    _audioRepository.setMusicVolume(volume: volume);
    emit(state.copyWith(musicVolume: volume));
  }

  void playSfxButtonTap() {
    _audioRepository.playSfx(
      soundSfx: SoundEffectEntity.buttonTap,
      volume: 1.0,
    );
  }

  void playSfxCorrect() {
    print('correct');
    _audioRepository.playSfx(soundSfx: SoundEffectEntity.correct, volume: 1.0);
  }

  void playSfxIncorrect() {
    print('incorrect');
    _audioRepository.playSfx(
      soundSfx: SoundEffectEntity.incorrect,
      volume: 1.0,
    );
  }

  void playBackgroundMusic() {
    print('song');
    _audioRepository.playBackgroundMusic(
      song: BackgroundSongEntity.gameplay,
      volume: 1.0,
    );
  }
}
