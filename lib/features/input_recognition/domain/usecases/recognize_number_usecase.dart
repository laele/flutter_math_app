import 'package:dartz/dartz.dart';
import 'package:flutter_math_app/core/error/failure.dart';
import 'package:flutter_math_app/core/usecase/usecase.dart';
import 'package:flutter_math_app/features/input_recognition/domain/entities/drawn_stroke_entity.dart';
import 'package:flutter_math_app/features/input_recognition/domain/repository/input_recognition_repository.dart';

class RecognizeNumberUseCase implements UseCase<int, RecognizeNumberParams> {
  final InputRecognitionRepository inputRecognitionRepository;
  RecognizeNumberUseCase({required this.inputRecognitionRepository});

  @override
  Future<Either<Failure, int>> call(RecognizeNumberParams params) async {
    return await inputRecognitionRepository.recognizeNumber(strokes: params.strokes, canvasWidth: params.canvasWidth, canvasHeight: params.canvasHeight);
  }
}

class RecognizeNumberParams {
  final List<DrawnStrokeEntity> strokes;
  final double canvasWidth;
  final double canvasHeight;

  RecognizeNumberParams({required this.strokes, required this.canvasWidth, required this.canvasHeight});
}
