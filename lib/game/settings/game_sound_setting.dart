import 'package:binary_quiz/game/game_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/widgets/border_container.dart';

class GameSoundSetting extends GameSetting<bool> {
  final RxBool soundEnabled = RxBool(true);

  @override
  bool getValue() {
    return soundEnabled.value;
  }

  @override
  Widget getWidget() {
    return _GameSoundSettingWidget(rxBool: soundEnabled);
  }

  @override
  void init() {
  }

  @override
  void setValue(bool value) {
    soundEnabled.value = value;
  }

}

class _GameSoundSettingWidget extends StatelessWidget {
  final RxBool rxBool;

  const _GameSoundSettingWidget({super.key, required this.rxBool});

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
        title: "소리 재생",
        body: "퀴즈 정답 여부에 따른 효과음을 재생합니다",
        checkBox: rxBool);

  }

}