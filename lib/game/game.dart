import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

abstract class Game<Q, A> {
  TextInputFormatter? textInputFormatter;
  RxInt _currentRoundNo = RxInt(-1);
  Rxn<GameRound> _currentRound = Rxn();
  List<GameRound> rounds = [];
  DateTime _startTime = DateTime(0);
  DateTime _endTime = DateTime(0);

  @mustCallSuper
  void startGame() {
    if (textInputFormatter == null) {
      throw "textInputFormatter가 null입니다.";
    }

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
    if (_currentRound.value == null) return;
    _currentRound.value!.setEndTime();
  }

  void _addRound(GameRound round) {
    rounds.add(round);
  }

  void _setCurrentRound(GameRound round) {
    _currentRound.value = round;
  }

  bool isAnswer(A v) {
    return _currentRound.value!.isAnswer(v);
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
    return _currentRound.value!.getQuestion();
  }

}

abstract class GameRound<Q,A> {
  late Q question;
  late A answer;
  int roundNo;

  DateTime _startTime = DateTime(0);
  DateTime _endTime = DateTime(0);

  GameRound(this.roundNo, this.question, this.answer);

  A getAnswer();

  Q getQuestion();

  void setQuestion(Q value) {
    this.question = value;
  }

  bool isAnswer(A value) {
    return getAnswer() == value;
  }

  void setStartTime() {
    _startTime = DateTime.now();
  }

  void setAnswer(A answer);

  void setEndTime() {
    _endTime = DateTime.now();
  }

  Duration getEstimatedTime() {
    return _endTime.difference(_startTime);
  }
}