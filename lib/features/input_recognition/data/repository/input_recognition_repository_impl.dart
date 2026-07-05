import 'package:dartz/dartz.dart';
import 'package:flutter_math_app/core/error/failure.dart';
import 'package:flutter_math_app/features/input_recognition/data/datasource/input_recognition_datasource.dart';
import 'package:flutter_math_app/features/input_recognition/domain/entities/drawn_stroke_entity.dart';
import 'package:flutter_math_app/features/input_recognition/domain/failures/input_recognition_exception.dart';
import 'package:flutter_math_app/features/input_recognition/domain/failures/input_recognition_failure.dart';
import 'package:flutter_math_app/features/input_recognition/domain/repository/input_recognition_repository.dart';

class InputRecognitionRepositoryImpl implements InputRecognitionRepository {
  final InputRecognitionDataSource datasource;
  InputRecognitionRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, int>> recognizeNumber({
    required List<DrawnStrokeEntity> strokes,
    required double canvasWidth,
    required double canvasHeight,
  }) async {
    try {
      await datasource.ensureModelDownloaded();
      final input = await datasource.getNumber(
        strokes: strokes,
        canvasWidth: canvasWidth,
        canvasHeight: canvasHeight,
      );
      final filterNumber = input.replaceAll(RegExp(r'[^0-9]'), '');

      if (filterNumber.isEmpty) {
        return left(UnrecognizedInputFailure());
      }

      final number = int.tryParse(filterNumber);
      if (number == null) {
        return left(UnrecognizedInputFailure());
      }

      return right(number);
    } on ModelNotDownloadedException {
      return left(ModelNotDownloadedFailure());
    } on EmptyStrokesException {
      return left(EmptyInputFailure());
    } on NoRecognitionCandidateException {
      return left(UnrecognizedInputFailure());
    } catch (_) {
      return left(UnknownInputRecognitionFailure());
    }
  }
}
