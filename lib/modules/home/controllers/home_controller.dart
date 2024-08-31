import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

import '../../../game/game.dart';
import '../../../services/game_service.dart';

class HomeController extends GetxController {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final Rxn<Game> selectedGame = Rxn<Game>();

  bool isSelected(Game game) {
    return selectedGame.value == game;
  }

  void setSelectedGame(Game game) {
    selectedGame.value = game;
    _analytics.logSelectContent(contentType: 'home_game_selection', itemId: game.getKey());
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

  List<Game> getAvailableGames() {
    return Get.find<GameService>().games;
  }

  Game? getSelectedGame() {
    return selectedGame.value;
  }
}
