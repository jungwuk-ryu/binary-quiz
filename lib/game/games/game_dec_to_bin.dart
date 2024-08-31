import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../modules/finish/models/finish_page_arguments.dart';
import '../../modules/finish/views/game_finish_page.dart';
import '../../routes/app_pages.dart';
import '../../tools/bin_tool.dart';
import '../../ui/widgets/border_container.dart';
import '../game.dart';
import '../game_setting.dart';
import '../settings/auto_submit_setting.dart';
import '../settings/game_sound_setting.dart';
import '../settings/max_rounds_setting.dart';
import '../settings/max_value_int_setting.dart';

class GameDecToBin extends Game<int, String> {
  final List<GameSetting> _availSettings = [];

  GameDecToBin() {
    textInputFormatter =
        FilteringTextInputFormatter.allow(RegExp(r'^[+-]?\d*\.?\d*'));
    _availSettings.addAll([
      MaxRoundsSetting(this),
      MaxValueIntSetting(this),
      GameSoundSetting(this),
      AutoSubmitSetting(this)
    ]);
  }

  @override
  GameRound getNewRound(int roundNo) {
    int question = _generateQuestion();
    String answer = BinTool.int2bin(question);

    GameRoundDecToBin round =
        GameRoundDecToBin(roundNo: roundNo, question: question, answer: answer);
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
            answer: formatAnswer(round.answer),
            totalTimeInMS: round.getEstimatedTime().inMilliseconds,
            tryCount: 1);
      } else {
        container.tryCount++;
        container.totalTimeInMS += round.getEstimatedTime().inMilliseconds;
      }

      containers[round.getQuestion()] = container;
    }

    List<GameRoundContainerDecToBin> values = List.from(containers.values);
    Get.offAndToNamed(Routes.finish,
        arguments: FinishPageArguments(
        game: this,
        containers: List.generate(values.length, (index) => values[index])));
  }

  int _generateQuestion() {
    return Random().nextInt(getMaxValue() + 1);
  }

  int getMaxValue() {
    return getSetting(MaxValueIntSetting)!.getValue();
  }

  String formatAnswer(String v) {
    int maxQuestion = getMaxValue();
    String maxAnswer = BinTool.int2bin(maxQuestion);

    int maLen = maxAnswer.length;

    String ret = v.padLeft(maLen, '0');
    return ret;
  }

  @override
  String getDescription() {
    return "game.dtb.desc".tr;
  }

  @override
  String getName() {
    return "Decimal To Binary";
  }

  @override
  bool? isAnswer(v) {
    return currentRound.value?.isAnswer(v);
  }

  @override
  List<GameSetting> getAvailableSettings() {
    return List<GameSetting>.from(_availSettings);
  }

  @override
  List<Widget> getSettingWidgets() {
    return List<Widget>.generate(
        _availSettings.length, (index) => _availSettings[index].getWidget());
  }

  @override
  String getKey() {
    return "DTB";
  }

  @override
  String getQuestionSuffix() {
    return "(10)";
  }
}

class GameRoundDecToBin extends GameRound<int, String> {
  GameRoundDecToBin(
      {required super.roundNo, required super.question, required super.answer});

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
  int totalTimeInMS;
  int tryCount;

  GameRoundContainerDecToBin(
      {super.key,
      required this.question,
      required this.answer,
      required this.totalTimeInMS,
      required this.tryCount});

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
        title: "game.dtb.con.title".trParams({'1': "$question"}),
        body: "game.dtb.con.body".trParams({
          '1': answer,
          '2':
              ((totalTimeInMS.toDouble()) / tryCount / 1000).toStringAsFixed(3),
          '3': "$tryCount"
        }));
  }
}
