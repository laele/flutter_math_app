import 'package:dartz/dartz.dart';
import 'package:flutter_math_app/core/error/failure.dart';
import 'package:flutter_math_app/core/usecase/usecase.dart';
import 'package:flutter_math_app/features/input_recognition/domain/repository/input_recognition_repository.dart';

class EnsureModelDownloadedUseCase implements UseCase<Unit, NoParams> {
  final InputRecognitionRepository inputRecognitionRepository;
  EnsureModelDownloadedUseCase({required this.inputRecognitionRepository});

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await inputRecognitionRepository.ensureModelDownloaded();
  }
}
