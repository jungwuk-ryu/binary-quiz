import 'package:get/get.dart';

import '../../../services/game_service.dart';
import '../controllers/home_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(GameService());
  }
}
