import 'dart:math';

import 'package:binary_quiz/modules/finish/views/game_finish_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../tools/bin_tool.dart';
import '../../ui/widgets/border_container.dart';
import '../game.dart';

class GameDecToBin extends Game<int, String> {
  int max;

  GameDecToBin(this.max) {
    textInputFormatter =
        FilteringTextInputFormatter.allow(RegExp(r'^[+-]?\d*\.?\d*'));
  }

  @override
  GameRound getNewRound(int roundNo) {
    int question = _generateQuestion();
    String answer = BinTool.int2bin(question);

    GameRoundDecToBin round = GameRoundDecToBin(roundNo: roundNo, question: question, answer: answer);
    return round;
  }

  @override
  void endGame() {
    super.endGame();
    Map<int, GameRoundContainerDecToBin> containers = {};

    for (GameRound round in rounds) {
      GameRoundContainerDecToBin? container = containers[round.getQuestion()];

      if (container == null) {
        container = GameRoundContainerDecToBin(
            question: round.getQuestion(),
            answer: round.getAnswer(),
            totalTimeInSec: round.getEstimatedTime().inSeconds,
            tryCount: 1);
      } else {
        container.tryCount++;
        container.totalTimeInSec += round.getEstimatedTime().inSeconds;
      }

      containers[round.getQuestion()] = container;
    }

    List<GameRoundContainerDecToBin> values = List.from(containers.values);
    Get.off(() => FinishPage(
      game: this,
      containers: List.generate(values.length, (index) => values[index]),
    ));
  }

  int _generateQuestion() {
    return Random().nextInt(max);
  }

  @override
  String getDescription() {
    return "십진수를 이진수로 변환하는 퀴즈입니다.";
  }

  @override
  String getName() {
    return "Decimal To Binary";
  }

  @override
  bool? isAnswer(v) {
    return currentRound.value?.isAnswer(v);
  }
}

class GameRoundDecToBin extends GameRound<int, String> {
  GameRoundDecToBin({required super.roundNo, required super.question, required super.answer});

  @override
  bool isAnswer(value) {
    if (value == null) return false;
    int? num = BinTool.bin2int(value);

    return num == getQuestion();
  }
}

class GameRoundContainerDecToBin extends GameRoundContainer {
  int question;
  String answer;
  int totalTimeInSec;
  int tryCount;

  GameRoundContainerDecToBin(
      {super.key, required this.question,
      required this.answer,
      required this.totalTimeInSec,
      required this.tryCount});

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      title: "$question",
      body: "답: $answer\n"
          "평균 $totalTimeInSec초 소요\n"
          "$tryCount번 풀었음",
    );
  }
}
