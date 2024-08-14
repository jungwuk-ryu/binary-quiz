import 'package:binary_quiz/game/game_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/widgets/border_container.dart';

class GameSoundSetting extends GameSetting<bool> {
  final RxBool soundEnabled = RxBool(true);

  GameSoundSetting(super.game);

  @override
  void init() {
    super.init();
    soundEnabled.listen((p0) {
      setValue(p0);
    });
  }

  @override
  bool getValue() {
    return soundEnabled.value;
  }

  @override
  Widget getWidget() {
    return _GameSoundSettingWidget(rxBool: soundEnabled);
  }

  @override
  void setValue(bool value) {
    super.setValue(value);
    soundEnabled.value = value;
  }

  @override
  String getKey() {
    return "game_sound_enable";
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

class _GameSoundSettingWidget extends StatelessWidget {
  final RxBool rxBool;

  const _GameSoundSettingWidget({super.key, required this.rxBool});

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
        title: "game.settings.game_sound.widget.title".tr,
        body: "game.settings.game_sound.widget.body".tr,
        checkBox: rxBool);
  }
}
