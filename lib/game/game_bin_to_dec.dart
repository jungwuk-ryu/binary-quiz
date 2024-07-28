import 'dart:math';

import 'package:binary_quiz/game/game.dart';
import 'package:binary_quiz/page/game_finish_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../tool/bin_tool.dart';
import '../widget/border_container.dart';

class GameBinToDec extends Game<String, int> {
  int max;

  GameBinToDec(this.max) {
    textInputFormatter =
        FilteringTextInputFormatter.allow(RegExp(r'^[+-]?\d*\.?\d*'));
  }

  @override
  GameRound getNewRound(int roundNo) {
    int answer = _generateAnswer();
    String question = BinTool.int2bin(answer);

    GameRoundBinToDec round = GameRoundBinToDec(roundNo, question, answer);
    return round;
  }

  @override
  void endGame() {
    super.endGame();
    Map<int, GameRoundContainerBinToDec> containers = {};

    for (GameRound round in rounds) {
      GameRoundContainerBinToDec? container = containers[round.getAnswer()];

      if (container == null) {
        container = GameRoundContainerBinToDec(
            question: round.getQuestion(),
            answer: round.getAnswer(),
            totalTimeInSec: round.getEstimatedTime().inSeconds,
            tryCount: 1);
      } else {
        container.tryCount++;
        container.totalTimeInSec += round.getEstimatedTime().inSeconds;
      }

      containers[round.getAnswer()] = container;
    }

    List<GameRoundContainerBinToDec> values = List.from(containers.values);
    Get.off(() => FinishPage(
      containers: List.generate(values.length, (index) => values[index]),
    ));
  }

  int _generateAnswer() {
    return Random().nextInt(max);
  }
}

class GameRoundBinToDec extends GameRound<String, int> {
  GameRoundBinToDec(super.roundNo, super.question, super.answer);

  @override
  int getAnswer() {
    return answer;
  }

  @override
  String getQuestion() {
    String bin = BinTool.int2bin(getAnswer());
    return bin;
  }

  @override
  void setAnswer(int value) {
    answer = value;
  }
}

class GameRoundContainerBinToDec extends GameRoundContainer {
  String question;
  int answer;
  int totalTimeInSec;
  int tryCount;

  GameRoundContainerBinToDec(
      {required this.question,
      required this.answer,
      required this.totalTimeInSec,
      required this.tryCount});

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      title: question,
      body: "답: $answer\n"
          "평균 $totalTimeInSec초 소요\n"
          "$tryCount번 풀었음",
    );
  }
}
