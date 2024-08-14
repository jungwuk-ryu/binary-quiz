import 'package:get/get.dart';

import '../modules/home/bindings/home_bindings.dart';
import '../modules/home/views/home.dart';
import '../modules/lobby/bindings/game_lobby_bindings.dart';
import '../modules/lobby/views/game_lobby_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MAIN;

  static final routes = [
    GetPage(
      name: _Paths.MAIN,
      page: () => const Home(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: _Paths.LOBBY,
      page: () => const GameLobbyPage(),
      binding: GameLobbyBindings(),
    ),
  ];
}
