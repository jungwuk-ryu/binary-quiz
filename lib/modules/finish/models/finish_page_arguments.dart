import '../../../game/game.dart';
import '../views/game_finish_page.dart';

class FinishPageArguments {
  final Game game;
  final List<GameRoundContainer> containers;

  const FinishPageArguments({required this.game, required this.containers});
}