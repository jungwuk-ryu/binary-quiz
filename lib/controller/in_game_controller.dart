import 'package:binary_quiz/game_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

abstract class InGameController extends GetxController {
  TextEditingController teController = TextEditingController();

  final GameSettings _gameSettings = GameSettings.instance;
  final RxInt _currentRounds = RxInt(0);
  final RxString _currentBinary = RxString("");
  final RxDouble _currentDecimal = RxDouble(0);
  TextInputFormatter? textInputFormatter;

  @override
  void onInit() {
    super.onInit();
    teController.addListener(textEditingListener);
    init();

    if (textInputFormatter == null) {
      throw "textInputFormatter가 null입니다.";
    }
  }

  String getCurrentBinary() {
    return _currentBinary.value;
  }

  void setCurrentBinary(String binStr) {
    _currentBinary.value = binStr;
  }

  double getCurrentDecimal() {
    return _currentDecimal.value;
  }

  void setCurrentDecimal(double num) {
    _currentDecimal.value = num;
  }

  int getCurrentRounds() {
    return _currentRounds.value;
  }

  void setCurrentRounds(int value) {
    _currentRounds.value = value;
  }

  void increaseRounds() {
    _currentRounds.value++;
  }

  int getMaxRounds() {
    return _gameSettings.maxRounds.value;
  }

  void textEditingListener() {
    if (_gameSettings.autoSubmit.isFalse) return;
    bool? result = check();
    if (result == true) onPass();
  }

  void handleKeypadInput(String str);

  void onPass();

  void onNonPass();

  void endGame();

  void init();

  void nextGame();

  bool? check();
}
