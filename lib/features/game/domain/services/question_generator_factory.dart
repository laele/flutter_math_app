import 'package:flutter_math_app/features/game/domain/services/question_generator.dart';
import 'package:flutter_math_app/features/game/presentation/game_cubit/game_cubit.dart';

class QuestionGeneratorFactory {
  static QuestionGenerator forMode(GameMode mode) {
    return switch (mode) {
      GameMode.learnNumbers => LearnNumbersQuestionGenerator(),
      GameMode.add => AddQuestionGenerator(),
      GameMode.sub => SubQuestionGenerator(),
      GameMode.mult => MultQuestionGenerator(),
      GameMode.div => DivQuestionGenerator(),
      GameMode.menu => throw UnimplementedError(),
      GameMode.tutorial => throw UnimplementedError(),
    };
  }
}
