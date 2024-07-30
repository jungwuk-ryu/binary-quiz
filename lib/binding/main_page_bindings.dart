import 'package:binary_quiz/controller/main_page_controller.dart';
import 'package:get/get.dart';

class MainPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MainPageController());
  }
}