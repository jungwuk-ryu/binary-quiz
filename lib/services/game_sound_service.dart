import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

enum GameSound { correct, incorrect }

class GameSoundService extends GetxService {
  final Map<GameSound, AudioPlayer> _players = {
    GameSound.correct: AudioPlayer(),
    GameSound.incorrect: AudioPlayer(),
  };

  final Map<GameSound, String> _assetPath = const {
    GameSound.correct: 'sounds/correct.mp3',
    GameSound.incorrect: 'sounds/incorrect.mp3',
  };

  @override
  void onInit() {
    super.onInit();
    _preload();
  }

  Future<void> _preload() async {
    for (final entry in _players.entries) {
      try {
        var player = entry.value;
        await player.setReleaseMode(ReleaseMode.stop);
        await player.setPlayerMode(PlayerMode.lowLatency);
        await player.setSourceAsset(_assetPath[entry.key]!);
      } catch (e) {
        debugPrint('preload fail: $e');
      }
    }
  }

  Future<void> playGameSound(GameSound sound) async {
    final player = _players[sound];
    if (player == null) return;

    try {
      await player.stop();
      await player.play(AssetSource(_assetPath[sound]!));
    } catch (e) {
      debugPrint('play error: $e');
    }
  }

  @override
  void onClose() {
    for (final p in _players.values) {
      p.dispose();
    }
    super.onClose();
  }
}
