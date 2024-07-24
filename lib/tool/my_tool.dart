import 'package:get/get.dart';

class MyTool {
  static SnackbarController? _snackbarController;

  static Future<void> snackbar({String? title, String? body}) async {
    await closeSnackbar(animation: false);
    _snackbarController = Get.snackbar(title ?? "", body ?? "");
  }

  static Future<void> closeSnackbar({bool animation = true}) async {
    try {
      await _snackbarController?.close(withAnimations: animation);
    } catch (_) {}
  }
}
