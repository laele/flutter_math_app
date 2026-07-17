import 'dart:math';

import 'package:flutter_math_app/features/game/domain/entities/min_max_tier_entity.dart';
import 'package:flutter_math_app/features/game/domain/entities/game_question_entity.dart';
import 'package:flutter_math_app/features/game/domain/services/weighted_range_sampler.dart';

abstract interface class QuestionGenerator {
  GameQuestionEntity generate(MinMaxTierEntity tier);
}

class LearnNumbersQuestionGenerator implements QuestionGenerator {
  final WeightedRangeSampler _sampler;
  //final Random _random;
  LearnNumbersQuestionGenerator([
    /*Random? randomm, */ WeightedRangeSampler? sampler,
  ]) : /*_random = random ?? Random()*/ _sampler = sampler ?? WeightedRangeSampler();

  @override
  GameQuestionEntity generate(MinMaxTierEntity tier) {
    //final number = tier.min + _random.nextInt(tier.max - tier.min + 1);
    final number = _sampler.sample(tier);
    return GameQuestionEntity(resultNum: number);
  }
}

class AddQuestionGenerator implements QuestionGenerator {
  final WeightedRangeSampler _sampler;
  AddQuestionGenerator([WeightedRangeSampler? sampler]) : _sampler = sampler ?? WeightedRangeSampler();

  @override
  GameQuestionEntity generate(MinMaxTierEntity tier) {
    final a = _sampler.sample(tier);
    final b = _sampler.sample(tier);
    return GameQuestionEntity(firstNum: a, secNum: b, resultNum: a + b);
  }
}

class SubQuestionGenerator implements QuestionGenerator {
  final WeightedRangeSampler _sampler;
  SubQuestionGenerator([WeightedRangeSampler? sampler]) : _sampler = sampler ?? WeightedRangeSampler();

  @override
  GameQuestionEntity generate(MinMaxTierEntity tier) {
    final a = _sampler.sample(tier);
    final b = _sampler.sample(tier);
    final higher = max(a, b);
    final lower = min(a, b);
    return GameQuestionEntity(firstNum: higher, secNum: lower, resultNum: higher - lower);
  }
}

class MultQuestionGenerator implements QuestionGenerator {
  final WeightedRangeSampler _sampler;
  MultQuestionGenerator([WeightedRangeSampler? sampler]) : _sampler = sampler ?? WeightedRangeSampler();

  @override
  GameQuestionEntity generate(MinMaxTierEntity tier) {
    final a = _sampler.sample(tier);
    final b = _sampler.sample(tier);
    return GameQuestionEntity(firstNum: a, secNum: b, resultNum: a * b);
  }
}

class DivQuestionGenerator implements QuestionGenerator {
  final WeightedRangeSampler _sampler;
  DivQuestionGenerator([WeightedRangeSampler? sampler]) : _sampler = sampler ?? WeightedRangeSampler();

  @override
  GameQuestionEntity generate(MinMaxTierEntity tier) {
    final divisor = _sampler.sample(tier);
    final quotient = _sampler.sample(tier);
    final dividend = divisor * quotient;

    return GameQuestionEntity(firstNum: dividend, secNum: divisor, resultNum: quotient);
  }
}
