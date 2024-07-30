import 'package:get/get.dart';

import '../../../services/game_sound_service.dart';
import '../controllers/game_lobby_controller.dart';

class GameLobbyBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(GameLobbyController());
    Get.lazyPut<GameSoundService>(() => GameSoundService());
  }
}
