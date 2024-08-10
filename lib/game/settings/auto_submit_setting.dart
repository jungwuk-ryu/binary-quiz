import 'package:binary_quiz/game/game_setting.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../ui/widgets/border_container.dart';

class AutoSubmitSetting extends GameSetting<bool> {
  final RxBool autoSubmit = RxBool(true);

  @override
  bool getValue() {
    return autoSubmit.value;
  }

  @override
  Widget getWidget() {
    return _AutoSubmitSettingWidget(rxBool: autoSubmit);
  }

  @override
  void init() {
  }

  @override
  void setValue(bool value) {
    autoSubmit.value = value;
  }

}

class _AutoSubmitSettingWidget extends StatelessWidget {
  final RxBool rxBool;

  const _AutoSubmitSettingWidget({super.key, required this.rxBool});

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
        title: "자동 제출",
        body: "정답을 입력할 경우 자동으로 다음으로 넘어갑니다.",
        checkBox: rxBool);
  }

}