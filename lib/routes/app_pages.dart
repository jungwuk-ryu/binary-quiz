import 'package:binary_quiz/modules/lobby/bindings/game_lobby_bindings.dart';
import 'package:binary_quiz/modules/home/bindings/home_bindings.dart';
import 'package:binary_quiz/modules/lobby/views/game_lobby_page.dart';
import 'package:binary_quiz/modules/home/views/main_page.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MAIN;

  static final routes = [
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainPage(),
      binding: HomeBindings(),
    ),
    GetPage(
        name: _Paths.LOBBY,
        page: () => const GameLobbyPage(),
        binding: GameLobbyBindings(),
    ),
  ];
}
