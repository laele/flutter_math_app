import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';
import 'package:flutter_math_app/features/input_recognition/data/datasource/input_recognition_datasource.dart';
import 'package:flutter_math_app/features/input_recognition/data/repository/input_recognition_repository_impl.dart';
import 'package:flutter_math_app/features/input_recognition/domain/repository/input_recognition_repository.dart';
import 'package:flutter_math_app/features/input_recognition/domain/usecases/ensure_model_downloaded_usecase.dart';
import 'package:flutter_math_app/features/input_recognition/domain/usecases/recognize_number_usecase.dart';
import 'package:flutter_math_app/features/input_recognition/presentation/input_recognition_cubit/input_recognition_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await initInputRecognizer();
  sl.registerFactory<GameCubit>(() => GameCubit());
}

Future<void> initInputRecognizer() async {
  sl
    ..registerLazySingleton<InputRecognitionDataSource>(
      () => InputRecognitionDataSourceImpl(),
    )
    ..registerLazySingleton<InputRecognitionRepository>(
      () => InputRecognitionRepositoryImpl(datasource: sl()),
    )
    ..registerFactory<RecognizeNumberUseCase>(
      () => RecognizeNumberUseCase(inputRecognitionRepository: sl()),
    )
    ..registerFactory<EnsureModelDownloadedUseCase>(
      () => EnsureModelDownloadedUseCase(inputRecognitionRepository: sl()),
    )
    ..registerFactory<InputRecognitionCubit>(
      () => InputRecognitionCubit(
        recognizeNumberUseCase: sl(),
        ensureModelDownloaded: sl(),
      ),
    );
}
