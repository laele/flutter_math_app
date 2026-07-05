import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Ink;
import 'package:flutter_math_app/core/usecase/usecase.dart';
import 'package:flutter_math_app/features/input_recognition/domain/entities/drawn_point_entity.dart';
import 'package:flutter_math_app/features/input_recognition/domain/entities/drawn_stroke_entity.dart';
import 'package:flutter_math_app/features/input_recognition/domain/usecases/ensure_model_downloaded_usecase.dart';
import 'package:flutter_math_app/features/input_recognition/domain/usecases/recognize_number_usecase.dart';
import 'package:scribble/scribble.dart';

part 'input_recognition_state.dart';

class InputRecognitionCubit extends Cubit<InputRecognitionState> {
  final ScribbleNotifier notifier = ScribbleNotifier();
  final RecognizeNumberUseCase _recognizeNumberUseCase;
  final EnsureModelDownloadedUseCase _ensureModelDownloadedUseCase;

  InputRecognitionCubit({
    required RecognizeNumberUseCase recognizeNumberUseCase,
    required EnsureModelDownloadedUseCase ensureModelDownloaded,
  }) : _recognizeNumberUseCase = recognizeNumberUseCase,
       _ensureModelDownloadedUseCase = ensureModelDownloaded,
       super(InputRecognitionInitial());

  void initNotifier() {
    notifier.setColor(Color.fromARGB(255, 255, 255, 255));
    notifier.setStrokeWidth(8.0);
  }

  void ensureModelDownloaded() async {
    final ensuremodelDownloaded = await _ensureModelDownloadedUseCase(
      NoParams(),
    );
    ensuremodelDownloaded.fold(
      (failure) {
        print(failure.runtimeType);
      },
      (_) {
        print('success');
      },
    );
  }

  void submitResult({
    required double canvasWidth,
    required double canvasHeight,
  }) async {
    final strokes = notifier.currentSketch.lines.map(
      (line) {
        return DrawnStrokeEntity(
          points: line.points
              .map(
                (point) => DrawnPointEntity(
                  x: point.x,
                  y: point.y,
                ),
              )
              .toList(),
        );
      },
    ).toList();

    final result = await _recognizeNumberUseCase(
      RecognizeNumberParams(
        strokes: strokes,
        canvasWidth: canvasWidth,
        canvasHeight: canvasHeight,
      ),
    );

    result.fold(
      (failure) {
        print(failure.runtimeType);
      },
      (number) {
        print(number);
      },
    );
  }

  void clearCanvas() {
    notifier.clear();
  }

  @override
  Future<void> close() {
    notifier.dispose();
    return super.close();
  }
}
