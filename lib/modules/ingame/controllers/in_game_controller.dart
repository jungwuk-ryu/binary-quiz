import 'package:binary_quiz/game/settings/auto_submit_setting.dart';
import 'package:binary_quiz/game/settings/game_sound_setting.dart';
import 'package:binary_quiz/game/settings/max_rounds_setting.dart';
import 'package:binary_quiz/game/settings/max_value_dec_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../game/game.dart';
import '../../../services/game_sound_service.dart';
import '../../../ui/widgets/custom_keypad.dart';


class InGameController extends GetxController {
  final GameSoundService _soundService = Get.find<GameSoundService>();
  Function()? _onPass;
  Function()? _onFail;

  TextEditingController teController = TextEditingController();
  Game game;

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
    return game.getSetting(MaxRoundsSetting())!.getValue();
  }

  void _textEditingListener() {
    if (game.getSetting(AutoSubmitSetting())!.getValue() == false) return;
    bool? result = check(false);
    if (result == true) {
      makeOnPassEvent(true);
    }
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
    if (game.getCurrentRoundNo() + 1 >= getMaxRounds()) {
      endGame();
      return;
    }
    teController.clear();
    game.nextRound();
  }

  bool? check(bool makeEvent) {
    bool result;
    result = game.isAnswer(teController.text) ?? false;

    if (makeEvent) {
      if (result) {
        makeOnPassEvent(false);
      } else {
        makeOnFailEvent(false);
      }
    }

    return result;
  }

  Future<void> _playSound(GameSound sound) async {
    if (game.getSetting(GameSoundSetting())!.getValue() == false) return;
    await _soundService.playGameSound(sound);
  }

  void makeOnPassEvent(bool async) {
    _makeEvent(async, _onPass);
    _playSound(GameSound.correct);
  }

  void makeOnFailEvent(bool async) {
    _makeEvent(async, _onFail);
    _playSound(GameSound.incorrect);
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
