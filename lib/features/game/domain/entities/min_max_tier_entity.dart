import 'package:equatable/equatable.dart';

class MinMaxTierEntity extends Equatable {
  final int min;
  final int max;

  const MinMaxTierEntity({required this.min, required this.max});

  @override
  List<Object?> get props => [min, max];
}
