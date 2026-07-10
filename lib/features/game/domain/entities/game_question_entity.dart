import 'package:equatable/equatable.dart';

class GameQuestionEntity extends Equatable {
  final int? firstNum;
  final int? secNum;
  final int? resultNum;
  final String? resultLetter;

  const GameQuestionEntity({
    this.firstNum,
    this.secNum,
    this.resultNum,
    this.resultLetter,
  });

  @override
  List<Object?> get props => [
    firstNum,
    secNum,
    resultLetter,
    resultNum,
  ];
}
