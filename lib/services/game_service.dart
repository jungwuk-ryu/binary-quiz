import 'package:get/get.dart';

import '../game/game.dart';
import '../game/games/game_bin_to_dec.dart';
import '../game/games/game_dec_to_bin.dart';

class GameService extends GetxService {
  final List<Game> games = [];

  @override
  void onInit() {
    super.onInit();
    _intiGames();
  }

  void _intiGames() {
    games.add(GameBinToDec());
    games.add(GameDecToBin());

    for (Game game in games) {
      game.init();
    }
  }
}
