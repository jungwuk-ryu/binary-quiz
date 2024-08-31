import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

import '../../../game/game.dart';
import '../../../game/game_setting.dart';
import '../../../game/settings/max_rounds_setting.dart';
import '../../../routes/app_pages.dart';
import '../../../tools/my_tool.dart';
import '../../home/controllers/home_controller.dart';

class GameLobbyController extends GetxController {
  Game getGame() {
    return Get.find<HomeController>().selectedGame.value!;
  }

  void startGame() {
    Game game = getGame();

    /**
     * MaxRounds 유효성 체크
     */
    int? maxRounds = game.getSetting(MaxRoundsSetting)?.getValue();
    if (maxRounds == null || maxRounds < 1) { // 잘못된 값
      MyTool.snackbar(
          title: 'module.lobby.invalid_setting.max_rounds.title'.tr,
          body: 'module.lobby.invalid_setting.max_rounds.content'.tr);
      return;
    }

    /**
     * Analytics에 설정 및 게임 시작 로깅
     */
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    Map<String, String> settings = {};

    for (GameSetting setting in getGame().getAvailableSettings()) {
      String key = setting.getStorageKey(); // 게임 이름 + 세팀 이름
      String value = "${setting.getValue()}";

      settings[key] = value;
    }
    analytics.logEvent(
        name: "game_start",
        parameters: settings);

    /**
     * 시작
     */
    Get.toNamed(Routes.inGame);
  }
}
