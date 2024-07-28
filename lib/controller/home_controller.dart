import 'package:binary_quiz/controller/in_game_controller.dart';
import 'package:binary_quiz/game/game_bin_to_dec.dart';
import 'package:binary_quiz/game_settings.dart';
import 'package:binary_quiz/page/in_game_page.dart';
import 'package:binary_quiz/tool/my_tool.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final TextEditingController maxRoundsEditingController =
      TextEditingController(text: "20");

  void startGame() {
    int? maxRounds = int.tryParse(maxRoundsEditingController.text.trim());
    if (maxRounds == null || maxRounds < 1) {
      MyTool.snackbar(title: "올바르지 않은 라운드 수", body: "라운드 수는 최소 1 이상이어야합니다.");
      return;
    }

    InGameController gameController = InGameController(GameBinToDec(10));
    getGameSettings().maxRounds.value = maxRounds;

    Get.to(() => GetBuilder(
        builder: (controller) => InGamePage(),
        init: gameController));
  }

  GameSettings getGameSettings() {
    return GameSettings.instance;
  }
}
