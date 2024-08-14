import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/widgets/border_container.dart';
import '../game_setting.dart';

class MaxRoundsSetting extends GameSetting<int> {
  final TextEditingController controller = TextEditingController(text: "20");
  final RxInt maxRounds = RxInt(20);

  MaxRoundsSetting(super.game);

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
    return maxRounds.value;
  }

  @override
  Widget getWidget() {
    return _MaxRoundsSettingWidget(controller: controller);
  }

  @override
  void setValue(int value) {
    super.setValue(value);
    maxRounds.value = value;
  }

  @override
  String getKey() {
    return "max_rounds";
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
}

class _MaxRoundsSettingWidget extends StatelessWidget {
  final TextEditingController controller;

  const _MaxRoundsSettingWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      title: "game.settings.max_rounds.widget.title".tr,
      body: "game.settings.max_rounds.widget.body".tr,
      textEditingController: controller,
      keyboard:
          const TextInputType.numberWithOptions(decimal: false, signed: false),
      textFieldHint: "game.settings.max_rounds.widget.textFieldHint".tr,
      formatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}
