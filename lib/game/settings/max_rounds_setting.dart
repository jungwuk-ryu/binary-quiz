import 'package:binary_quiz/game/game_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../ui/widgets/border_container.dart';

class MaxRoundsSetting extends GameSetting<int> {
  final TextEditingController controller = TextEditingController(text: "20");
  final RxInt maxRounds = RxInt(20);

  @override
  void init() {
    controller.addListener(() {
      int? value = int.tryParse(controller.text);
      if (value == null) return;

      maxRounds.value = value;
    });
  }

  @override
  int getValue() {
    return maxRounds.value;
  }

  @override
  Widget getWidget() {
    return _MaxRoundsSettingWidget(controller: controller);
  }

  @override
  void setValue(int value) {
    maxRounds.value = value;
  }

}

class _MaxRoundsSettingWidget extends StatelessWidget {
  final TextEditingController controller;

  const _MaxRoundsSettingWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      title: "라운드",
      body: "최대 라운드 수를 지정합니다",
      textEditingController:
      controller,
      keyboard: const TextInputType.numberWithOptions(
          decimal: false, signed: false),
      textFieldHint: "라운드 수 (정수)",
      formatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}