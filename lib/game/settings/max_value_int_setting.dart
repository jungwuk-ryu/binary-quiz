import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../tools/my_tool.dart';
import '../../ui/widgets/border_container.dart';
import '../game_setting.dart';

class MaxValueIntSetting extends GameSetting<int> {
  final TextEditingController controller = TextEditingController(text: "10");
  final RxInt maxValue = RxInt(10);

  MaxValueIntSetting(super.game);

  @override
  void init() {
    super.init();

    controller.addListener(() {
      int? value = int.tryParse(controller.text);
      if (value == null) return;

      setValue(value);
    });
  }

  @override
  int getValue() {
    return maxValue.value;
  }

  @override
  Widget getWidget() {
    return _MaxValueIntSettingWidget(controller: controller);
  }

  @override
  void setValue(int value) {
    super.setValue(value);
    maxValue.value = value;
  }

  @override
  String getKey() {
    return "max_value_int";
  }

  @override
  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(getStorageKey());
    if (data == null) return;

    int? intData = int.tryParse(data);
    if (intData == null) return;

    setValue(intData);
    controller.text = "$intData";
  }

  @override
  bool validateValueBeforeStart() {
    int maxRounds = getValue();
    if (maxRounds < 1) { // 잘못된 값
      MyTool.snackbar(
          title: 'module.lobby.invalid_setting.max_rounds.title'.tr,
          body: 'module.lobby.invalid_setting.max_rounds.content'.tr);
      return false;
    }

    return true;
  }
}

class _MaxValueIntSettingWidget extends StatelessWidget {
  final TextEditingController controller;

  const _MaxValueIntSettingWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      title: "game.settings.max_value_int.widget.title".tr,
      body: "game.settings.max_value_int.widget.body".tr,
      textEditingController: controller,
      keyboard:
          const TextInputType.numberWithOptions(decimal: false, signed: false),
      textFieldHint: "game.settings.max_value_int.widget.textFieldHint".tr,
      formatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}
