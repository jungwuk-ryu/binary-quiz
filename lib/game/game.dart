import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'game_setting.dart';

abstract class Game<Q, A> {
  TextInputFormatter? textInputFormatter;
  final RxInt _currentRoundNo = RxInt(-1);
  final Rxn<GameRound> currentRound = Rxn();
  List<GameRound> rounds = [];
  DateTime _startTime = DateTime(0);
  DateTime _endTime = DateTime(0);

  Game() {
    init();
  }

  void init() {
    initGameSettings();
  }

  void initGameSettings() {
    for (GameSetting setting in getAvailableSettings()) {
      setting.init();
    }
  }

  GameSetting? getSetting(GameSetting setting) {
    for (GameSetting sett in getAvailableSettings()) {
      if (sett.runtimeType == setting.runtimeType) return sett;
    }
    return null;
  }

  void reset() {
    _currentRoundNo.value = -1;
    currentRound.value = null;
    rounds.clear();
  }

  @mustCallSuper
  void startGame() {
    if (textInputFormatter == null) {
      throw "textInputFormatter가 null입니다.";
    }

    reset();
    _setStartTime();
    nextRound();
  }

  @mustCallSuper
  void endGame() {
    _endRound();
    _setEndTime();
  }

  @mustCallSuper
  GameRound nextRound() {
    _endRound();

    increaseRoundNo();
    GameRound round = getNewRound(getCurrentRoundNo());
    _setCurrentRound(round);
    _addRound(round);

    _startRound(round);
    return round;
  }

  int increaseRoundNo() {
    return _currentRoundNo.value++;
  }

  int getCurrentRoundNo() {
    return _currentRoundNo.value;
  }

  GameRound getNewRound(int roundNo);

  void _startRound(GameRound round) {
    round.setStartTime();
  }

  void _endRound() {
    if (currentRound.value == null) return;
    currentRound.value!.setEndTime();
  }

  void _addRound(GameRound round) {
    rounds.add(round);
  }

  void _setCurrentRound(GameRound round) {
    currentRound.value = round;
  }

  bool? isAnswer(dynamic v) {
    return currentRound.value?.isAnswer(v);
  }

  Duration getEstimatedTime() {
    return _endTime.difference(_startTime);
  }

  void _setStartTime() {
    _startTime = DateTime.now();
  }

  void _setEndTime() {
    _endTime = DateTime.now();
  }

  dynamic getQuestion() {
    return currentRound.value!.getQuestion();
  }

  String getName();

  String getDescription();

  List<GameSetting> getAvailableSettings();

  List<Widget> getSettingWidgets();

}

abstract class GameRound<Q,A> {
  final Q question;
  final A answer;
  final int roundNo;

  DateTime _startTime = DateTime(0);
  DateTime _endTime = DateTime(0);

  GameRound({required this.roundNo, required this.question, required this.answer});

  A getAnswer() {
    return answer;
  }

  Q getQuestion() {
    return question;
  }
  bool isAnswer(dynamic value);

  void setStartTime() {
    _startTime = DateTime.now();
  }

  void setEndTime() {
    _endTime = DateTime.now();
  }

  Duration getEstimatedTime() {
    return _endTime.difference(_startTime);
  }
}