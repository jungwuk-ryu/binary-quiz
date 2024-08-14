import 'package:binary_quiz/services/game_service.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(GameService());
  }
}
