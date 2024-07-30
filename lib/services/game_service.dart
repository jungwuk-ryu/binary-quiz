import 'package:binary_quiz/game/games/game_bin_to_dec.dart';
import 'package:get/get.dart';

import '../game/game.dart';

class GameService extends GetxService {
  final List<Game> games = [];

  @override
  void onInit() {
    super.onInit();
    _intiGames();
  }

  void _intiGames() {
    games.add(GameBinToDec(20));
  }
}