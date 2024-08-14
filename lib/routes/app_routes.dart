part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const MAIN = _Paths.MAIN;
  static const LOBBY = _Paths.LOBBY;
}

abstract class _Paths {
  _Paths._();

  static const MAIN = '/main';
  static const LOBBY = '$MAIN/lobby';
}
