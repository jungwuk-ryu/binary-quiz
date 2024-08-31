import 'package:get/get.dart';

import '../modules/finish/views/game_finish_page.dart';
import '../modules/home/bindings/home_bindings.dart';
import '../modules/home/views/home.dart';
import '../modules/ingame/bindings/in_game_bindings.dart';
import '../modules/ingame/views/in_game_page.dart';
import '../modules/lobby/bindings/game_lobby_bindings.dart';
import '../modules/lobby/views/game_lobby_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.main;

  static final routes = [
    GetPage(
      name: _Paths.main,
      page: () => const Home(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: _Paths.lobby,
      page: () => const GameLobbyPage(),
      binding: GameLobbyBindings(),
    ),
    GetPage(
      name: _Paths.inGame,
      page: () => InGamePage(),
      binding: InGameBindings(),
    ),
    GetPage(
      name: _Paths.finish,
      page: () => FinishPage(),
      binding: GameLobbyBindings(),
    ),
  ];
}
