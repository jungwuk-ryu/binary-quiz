import 'package:binary_quiz/game/game.dart';
import 'package:binary_quiz/game_settings.dart';
import 'package:binary_quiz/service/game_sound_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../widget/CustomKeypad.dart';

class InGameController extends GetxController {
  final GameSoundService _soundService = Get.find<GameSoundService>();
  Function()? _onPass;
  Function()? _onFail;

  TextEditingController teController = TextEditingController();
  Game game;

  final GameSettings _gameSettings = GameSettings.instance;

  InGameController(this.game);

  @override
  void onInit() {
    super.onInit();
    teController.addListener(_textEditingListener);
    init();
  }


  int getCurrentRounds() {
    return game.getCurrentRoundNo();
  }

  int getMaxRounds() {
    return _gameSettings.maxRounds.value;
  }

  void _textEditingListener() {
    if (_gameSettings.autoSubmit.isFalse) return;
    bool? result = check(false);
    if (result == true) {
      makeOnPassEvent(true);
    };
  }

  void handleKeypadInput(String str) {
    final String text = teController.text;

    if (str == CustomKeypad.deletionMagicKey) {
      if (text.isEmpty) return;
      teController.text =
          teController.text.substring(0, teController.text.length - 1);
    } else {
      String tmp = teController.text + str;

      TextEditingValue? tev = game.textInputFormatter?.formatEditUpdate(
          TextEditingValue(text: teController.text),
          TextEditingValue(text: tmp));
      if (tev != null) {
        teController.text = tev.text;
      }
    }
  }

  dynamic getQuestion() {
    return game.getQuestion();
  }

  void endGame() {
    game.endGame();
  }

  void init() {
    game.startGame();
  }

  void nextGame() {
    if (game.getCurrentRoundNo() + 1 >= _gameSettings.getMaxRounds()) {
      endGame();
      return;
    }
    teController.clear();
    game.nextRound();
  }

  bool? check(bool makeEvent) {
    int? input = int.tryParse(teController.text);
    bool result;

    if (input == null) {
      result = false;
    } else {
      result = game.isAnswer(input);
    }

    if (makeEvent) {
      if (result) makeOnPassEvent(false);
      else makeOnFailEvent(false);
    }

    return result;
  }

  void makeOnPassEvent(bool async) {
    _soundService.playGameSound(GameSound.correct);
    _makeEvent(async, _onPass);
  }

  void makeOnFailEvent(bool async) {
    _soundService.playGameSound(GameSound.incorrect);
    _makeEvent(async, _onFail);
  }

  void _makeEvent(bool async, Function? func) {
    if (async) {
      Future.delayed(const Duration(seconds: 0), () => {
        if (func != null) func.call()
      });
    } else {
      func?.call();
    }
  }

  void setOnPassListener(Function() func) {
    _onPass = func;
  }

  void setOnFailListener(Function() func) {
    _onFail = func;
  }
}
