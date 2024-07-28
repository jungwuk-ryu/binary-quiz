import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GameSettings {
  static final GameSettings instance = GameSettings();

  RxDouble maxValue = RxDouble(10);
  RxInt maxRounds = RxInt(20);
  RxBool autoSubmit = RxBool(true);

  int getMaxRounds() {
    return maxRounds.value;
  }

  bool isAutoSubmitEnabled() {
    return autoSubmit.value;
  }
}
