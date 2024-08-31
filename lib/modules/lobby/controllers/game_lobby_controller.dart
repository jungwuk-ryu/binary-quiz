import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

import '../../../game/game.dart';
import '../../../game/game_setting.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';

class GameLobbyController extends GetxController {
  Game getGame() {
    return Get.find<HomeController>().selectedGame.value!;
  }

  void startGame() {
    Game game = getGame();

    /**
     * 각 설정 유효성 검사
     * false를 반환한 setting이 하나라도 존재할 경우
     * 게임을 시작하지 않습니다.
     */
    for (GameSetting setting in game.getAvailableSettings()) {
      if (!setting.validateValue()) return;
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
