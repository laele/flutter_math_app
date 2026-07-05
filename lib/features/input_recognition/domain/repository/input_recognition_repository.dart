import 'package:dartz/dartz.dart';
import 'package:flutter_math_app/core/error/failure.dart';
import 'package:flutter_math_app/features/input_recognition/domain/entities/drawn_stroke_entity.dart';

abstract interface class InputRecognitionRepository {
  Future<Either<Failure, int>> recognizeNumber({
    required List<DrawnStrokeEntity> strokes,
    required double canvasWidth,
    required double canvasHeight,
  });

  Future<Either<Failure, Unit>> ensureModelDownloaded();
}
