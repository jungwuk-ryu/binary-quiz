import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/widgets/border_container.dart';
import '../game_setting.dart';

class UniqueModeSetting extends GameSetting<bool> {
  final RxBool enable = RxBool(false);
  final Set<dynamic> _used = {};

  UniqueModeSetting(super.game);

  @override
  String getKey() {
    return "unique_mode";
  }

  @override
  void init() {
    super.init();
    enable.listen((p0) {
      setValue(p0);
    });
  }

  @override
  void setValue(bool value) {
    super.setValue(value);
    enable.value = value;
  }

  @override
  bool getValue() {
    return enable.value;
  }

  @override
  Widget getWidget() {
    return _UniqueModeSettingWidget(rxBool: enable);
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

  /// @return: 새롭게 추가되는 값일 경우 true
  bool add(dynamic value) {
    return _used.add(value);
  }

  int count() {
    return _used.length;
  }

  @override
  bool validateValueBeforeStart() {
    _used.clear();
    return super.validateValueBeforeStart();
  }
}

class _UniqueModeSettingWidget extends StatelessWidget {
  final RxBool rxBool;

  const _UniqueModeSettingWidget({super.key, required this.rxBool});

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
        title: "game.settings.unique_mode.widget.title".tr,
        body: "game.settings.unique_mode.widget.body".tr,
        checkBox: rxBool);
  }
}