import 'package:binary_quiz/game/game.dart';
import 'package:flutter/cupertino.dart';

abstract class GameSetting<V> {
  void init();

  V getValue();

  Widget getWidget();

  void setValue(V value);

  void save(Game game) {
    throw UnimplementedError();
  }
}