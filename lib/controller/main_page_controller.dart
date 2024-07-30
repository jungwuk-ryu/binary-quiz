import 'package:get/get.dart';

import '../game/game.dart';

class MainPageController extends GetxController {
  final Rxn<Game> selectedGame = Rxn<Game>();

  bool isSelected(Game game) {
    return selectedGame.value == game;
  }

  void setSelectedGame(Game game) {
    selectedGame.value = game;
  }

  void unselectGame() {
    selectedGame.value = null;
  }

  void unselectGameByGame(Game game) {
    if (!isSelected(game)) return;
    unselectGame();
  }

  bool hasSelectedGame() {
    return selectedGame.value != null;
  }

}