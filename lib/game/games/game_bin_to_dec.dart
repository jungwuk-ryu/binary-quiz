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

String _formatBinary(String v, int max) {
  String maxQuestion = BinTool.int2bin(max);

  int maLen = maxQuestion.length;

  String ret = v.padLeft(maLen, '0');
  return ret;
}

class GameBinToDec extends Game<String, int> {
  final List<GameSetting> _availSettings = [];

  GameBinToDec() {
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
    int answer = _generateAnswer();
    String question = BinTool.int2bin(answer);

    GameRoundBinToDec round =
        GameRoundBinToDec(getMaxValue(), roundNo: roundNo, question: question, answer: answer);
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
            question: _formatBinary(round.getQuestion(), getMaxValue()),
            answer: round.getAnswer(),
            totalTimeInMS: round.getEstimatedTime().inMilliseconds,
            tryCount: 1);
      } else {
        container.tryCount++;
        container.totalTimeInMS += round.getEstimatedTime().inMilliseconds;
      }

      containers[round.getAnswer()] = container;
    }

    List<GameRoundContainerBinToDec> values = List.from(containers.values);
    Get.offAndToNamed(Routes.finish,
        arguments: FinishPageArguments(
          game: this,
          containers: List.generate(values.length, (index) => values[index]),
    ));
  }

  int _generateAnswer() {
    return Random().nextInt(getMaxValue() + 1);
  }

  int getMaxValue() {
   return getSetting(MaxValueIntSetting)!.getValue();
  }

  @override
  String getDescription() {
    return "game.btd.desc".tr;
  }

  @override
  String getName() {
    return "game.btd.name".tr;
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
    return "BTD";
  }

  @override
  String getQuestionSuffix() {
    return "(2)";
  }
}

class GameRoundBinToDec extends GameRound<String, int> {
  final int max;

  GameRoundBinToDec(this.max,
      {required super.roundNo, required super.question, required super.answer});

  @override
  bool isAnswer(value) {
    if (value == null) return false;

    int? num = int.tryParse(value);
    return num == getAnswer();
  }

  @override
  String getQuestion() {
    return _formatBinary(super.getQuestion(), max);
  }
}

class GameRoundContainerBinToDec extends GameRoundContainer {
  String question;
  int answer;
  int totalTimeInMS;
  int tryCount;

  GameRoundContainerBinToDec(
      {super.key,
      required this.question,
      required this.answer,
      required this.totalTimeInMS,
      required this.tryCount});

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
        title: 'game.btd.con.title'.trParams({'1': question}),
        body: 'game.btd.con.body'.trParams({
          '1': "$answer",
          '2':
              ((totalTimeInMS.toDouble()) / tryCount / 1000).toStringAsFixed(3),
          '3': "$tryCount"
        }));
  }
}
