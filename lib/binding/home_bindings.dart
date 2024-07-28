import 'package:binary_quiz/controller/home_controller.dart';
import 'package:binary_quiz/service/game_sound_service.dart';
import 'package:get/get.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(GameSoundService());
  }
}
