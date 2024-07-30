import 'package:binary_quiz/binding/game_lobby_bindings.dart';
import 'package:binary_quiz/binding/main_page_bindings.dart';
import 'package:binary_quiz/page/game_lobby_page.dart';
import 'package:binary_quiz/page/main_page.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MAIN;

  static final routes = [
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainPage(),
      binding: MainPageBindings(),
    ),
    GetPage(
        name: _Paths.LOBBY,
        page: () => const GameLobbyPage(),
        binding: GameLobbyBindings(),
    ),
  ];
}
