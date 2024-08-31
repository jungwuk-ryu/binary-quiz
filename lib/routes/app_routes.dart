part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const main = _Paths.main;
  static const lobby = _Paths.lobby;
  static const inGame = _Paths.inGame;
  static const finish = _Paths.finish;
}

abstract class _Paths {
  _Paths._();

  static const main = '/main';
  static const lobby = '$main/lobby';
  static const inGame = '$lobby/ingame';
  static const finish = '$inGame/finish';
}
