import 'dart:math';

import 'package:flutter_math_app/features/game/domain/entities/min_max_tier_entity.dart';
import 'package:flutter_math_app/features/game/domain/entities/game_question_entity.dart';

abstract interface class QuestionGenerator {
  GameQuestionEntity generate(MinMaxTierEntity tier);
}

class LearnNumbersQuestionGenerator implements QuestionGenerator {
  final Random _random;
  LearnNumbersQuestionGenerator([Random? random]) : _random = random ?? Random();

  @override
  GameQuestionEntity generate(MinMaxTierEntity tier) {
    final number = tier.min + _random.nextInt(tier.max);
    return GameQuestionEntity(resultNum: number);
  }
}

class AddQuestionGenerator implements QuestionGenerator {
  final Random _random;
  AddQuestionGenerator([Random? random]) : _random = random ?? Random();

  @override
  GameQuestionEntity generate(MinMaxTierEntity tier) {
    final a = tier.min + _random.nextInt(tier.max);
    final b = tier.min + _random.nextInt(tier.max);
    return GameQuestionEntity(firstNum: a, secNum: b, resultNum: a + b);
  }
}

class SubQuestionGenerator implements QuestionGenerator {
  final Random _random;
  SubQuestionGenerator([Random? random]) : _random = random ?? Random();

  @override
  GameQuestionEntity generate(MinMaxTierEntity tier) {
    final a = tier.min + _random.nextInt(tier.max);
    final b = tier.min + _random.nextInt(tier.max);
    final higher = max(a, b);
    final lower = max(a, b);
    return GameQuestionEntity(firstNum: higher, secNum: lower, resultNum: higher - lower);
  }
}

class MultQuestionGenerator implements QuestionGenerator {
  final Random _random;
  MultQuestionGenerator([Random? random]) : _random = random ?? Random();

  @override
  GameQuestionEntity generate(MinMaxTierEntity tier) {
    final a = tier.min + _random.nextInt(tier.max);
    final b = tier.min + _random.nextInt(tier.max);
    return GameQuestionEntity(firstNum: a, secNum: b, resultNum: a * b);
  }
}

class DivQuestionGenerator implements QuestionGenerator {
  final Random _random;
  DivQuestionGenerator([Random? random]) : _random = random ?? Random();

  @override
  GameQuestionEntity generate(MinMaxTierEntity tier) {
    final divisor = tier.min;
    final quotient = divisor + _random.nextInt(tier.max);
    final dividend = divisor * quotient;
    return GameQuestionEntity(firstNum: dividend, secNum: divisor, resultNum: quotient);
  }
}
