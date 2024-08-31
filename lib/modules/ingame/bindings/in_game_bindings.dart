import 'package:get/get.dart';

import '../../../game/game.dart';
import '../../lobby/controllers/game_lobby_controller.dart';
import '../controllers/in_game_controller.dart';

class InGameBindings extends Bindings {
  @override
  void dependencies() {
    Game game = Get.find<GameLobbyController>().getGame();
    Get.put(InGameController(game));
  }

}