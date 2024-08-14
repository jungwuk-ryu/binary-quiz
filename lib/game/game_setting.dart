import 'package:binary_quiz/game/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class GameSetting<V> {
  final Game game;

  GameSetting(this.game);

  Game getCurrentGame() {
    return game;
  }

  @mustCallSuper
  void init() {
    load();
  }

  V getValue();

  Widget getWidget();

  @mustCallSuper
  void setValue(V value) {
    save();
  }

  String getKey();

  String getStorageKey() {
    return "${getCurrentGame().getKey()}::${getKey()}";
  }

  Future<void> load();

  Future<void> save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(getStorageKey(), "${getValue()}");
  }
}