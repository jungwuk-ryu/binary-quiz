import 'package:binary_quiz/service/game_sound_service.dart';
import 'package:get/get.dart';

import '../controller/game_lobby_controller.dart';

class GameLobbyBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(GameLobbyController());
    Get.lazyPut<GameSoundService>(() => GameSoundService());
  }
}
