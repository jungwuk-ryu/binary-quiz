import 'package:binary_quiz/game/game_setting.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/widgets/border_container.dart';

class AutoSubmitSetting extends GameSetting<bool> {
  final RxBool autoSubmit = RxBool(true);

  AutoSubmitSetting(super.game);

  @override
  void init() {
    super.init();
    autoSubmit.listen((p0) {
      setValue(p0);
    });
  }

  @override
  bool getValue() {
    return autoSubmit.value;
  }

  @override
  Widget getWidget() {
    return _AutoSubmitSettingWidget(rxBool: autoSubmit);
  }

  @override
  void setValue(bool value) {
    super.setValue(value);
    autoSubmit.value = value;
  }

  @override
  String getKey() {
    return "auto_submit";
  }

  @override
  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(getStorageKey());
    if (data == null) return;

    bool? boolData = bool.tryParse(data, caseSensitive: false);
    if (boolData == null) return;

    setValue(boolData);
  }

}

class _AutoSubmitSettingWidget extends StatelessWidget {
  final RxBool rxBool;

  const _AutoSubmitSettingWidget({super.key, required this.rxBool});

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
        title: "game.settings.auto_submit.widget.title".tr,
        body: "game.settings.auto_submit.widget.body".tr,
        checkBox: rxBool);
  }

}