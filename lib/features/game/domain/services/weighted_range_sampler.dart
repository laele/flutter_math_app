// domain/services/weighted_range_sampler.dart
import 'dart:math';

import 'package:flutter_math_app/features/game/domain/constants/difficulty_tiers.dart';
import 'package:flutter_math_app/features/game/domain/entities/min_max_tier_entity.dart';

class WeightedRangeSampler {
  final Random _random;
  WeightedRangeSampler([Random? random]) : _random = random ?? Random();

  // Generate a number from min max Tier entity range, using  small / medium / large mixed values, instead just random
  int sample(MinMaxTierEntity tier) {
    final rango = tier.max - tier.min;

    if (rango <= 6) {
      return tier.min + _random.nextInt(rango + 1);
    }

    final tercio = (rango / 3).round();
    final roll = _random.nextDouble();

    late int bandaMin, bandaMax;
    if (roll < 0.45) {
      bandaMin = tier.min;
      bandaMax = tier.min + tercio;
    } else if (roll < 0.80) {
      bandaMin = tier.min + tercio;
      bandaMax = tier.min + (tercio * 2);
    } else {
      bandaMin = tier.min + (tercio * 2);
      bandaMax = tier.max;
    }

    return bandaMin + _random.nextInt(bandaMax - bandaMin + 1);
  }
}
