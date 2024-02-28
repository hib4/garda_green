// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:garda_green/settings/settings_controller.dart';
import 'package:logger/logger.dart';

typedef CreateAudioPlayer = AudioPlayer Function({required String playerId});

enum Song {
  background,
  gameplay,
}

enum Sfx {
  collect,
  hit,
  hurt,
  jump,
}

const songs = {
  Song.background: 'music/background.mp3',
  Song.gameplay: 'music/gameplay.mp3',
};

const sfx = <Sfx, String>{
  Sfx.collect: 'sfx/collect.wav',
  Sfx.hit: 'sfx/hit.wav',
  Sfx.hurt: 'sfx/hurt.wav',
  Sfx.jump: 'sfx/jump.wav',
};

/// Allows playing music and sound. A facade to `package:audioplayers`.
class AudioController {
  /// Creates an instance that plays music and sound.
  ///
  /// Use [polyphony] to configure the number of sound effects (SFX) that can
  /// play at the same time. A [polyphony] of `1` will always only play one
  /// sound (a new sound will stop the previous one). See discussion
  /// of [_sfxPlayers] to learn why this is the case.
  ///
  /// Background music does not count into the [polyphony] limit. Music will
  /// never be overridden by sound effects because that would be silly.
  AudioController({
    int polyphony = 2,
    CreateAudioPlayer createPlayer = AudioPlayer.new,
  })  : assert(polyphony >= 1, 'polyphony must be bigger or equals than 1'),
        musicPlayer = createPlayer(playerId: 'musicPlayer'),
        _sfxPlayers = Iterable.generate(
          polyphony,
          (i) => createPlayer(playerId: 'sfxPlayer#$i'),
        ).toList(growable: false);
  static final _log = Logger(printer: PrettyPrinter());

  final AudioPlayer musicPlayer;

  Song _song = Song.background;

  /// This is a list of [AudioPlayer] instances which are rotated to play
  /// sound effects.
  final List<AudioPlayer> _sfxPlayers;

  int _currentSfxPlayer = 0;

  SettingsController? _settings;

  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  /// Enables the [AudioController] to listen to [AppLifecycleState] events,
  /// and therefore do things like stopping playback when the game
  /// goes into the background.
  void attachLifecycleNotifier(
    ValueNotifier<AppLifecycleState> lifecycleNotifier,
  ) {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);

    lifecycleNotifier.addListener(_handleAppLifecycle);
    _lifecycleNotifier = lifecycleNotifier;
  }

  /// Enables the [AudioController] to track changes to settings.
  /// Namely, when any of [SettingsController.musicMuted] and
  /// [SettingsController.sfxMuted] change,
  /// the audio controller will act accordingly.
  void attachSettings(SettingsController settingsController) {
    if (_settings == settingsController) {
      // Already attached to this instance. Nothing to do.
      return;
    }

    // Remove handlers from the old settings controller if present
    final oldSettings = _settings;
    if (oldSettings != null) {
      oldSettings.musicMuted.removeListener(_musicMutedHandler);
      oldSettings.sfxMuted.removeListener(_sfxMutedHandler);
    }

    _settings = settingsController;

    // Add handlers to the new settings controller
    settingsController.musicMuted.addListener(_musicMutedHandler);
    settingsController.sfxMuted.addListener(_sfxMutedHandler);

    if (!kIsWeb && !settingsController.musicMuted.value) {
      startMusic();
    }
  }

  bool get isMusicEnabled => _settings?.musicMuted.value == false;

  bool get isSfxEnabled => _settings?.sfxMuted.value == false;

  void dispose() {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);
    _stopAllSound();
    musicPlayer.dispose();
    for (final player in _sfxPlayers) {
      player.dispose();
    }
  }

  /// Preloads all sound effects.
  Future<void> initialize() async {
    _log.i('Preloading sound effects');
    // This assumes there is only a limited number of sound effects in the game.
    // If there are hundreds of long sound effect files, it's better
    // to be more selective when preloading.

    await AudioCache.instance.loadAll(songs.values.toList());
    await AudioCache.instance.loadAll(sfx.values.toList());
  }

  /// Plays a single sound effect.
  ///
  /// The controller will ignore this call when the attached settings'
  /// [SettingsController.sfxMuted] is `true`
  Future<void> playSfx(Sfx current) async {
    final muted = _settings?.sfxMuted.value ?? true;
    if (muted) {
      _log.i('Ignoring playing sound ($sfx) because sfx is muted.');
      return;
    }

    _log.i('Playing sound: $sfx');

    await _sfxPlayers[_currentSfxPlayer].play(AssetSource(sfx[current]!));
    _currentSfxPlayer = (_currentSfxPlayer + 1) % _sfxPlayers.length;
  }

  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _stopAllSound();
      case AppLifecycleState.resumed:
        if (!_settings!.musicMuted.value) {
          _resumeMusic();
        }
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        // No need to react to this state change.
        break;
    }
  }

  void _musicMutedHandler() {
    if (_settings!.musicMuted.value) {
      // All music just got muted.
      _log.i('All music just got muted.');
      _stopMusic();
    } else {
      // All music just got un-muted.
      _log.i('All music just got un-muted.');
      _resumeMusic();
    }
  }

  void _sfxMutedHandler() {
    if (_settings!.sfxMuted.value) {
      // All sfx just got muted.
      _stopSfx();
    }
  }

  Future<void> _playSong(Song current) async {
    final playingSong = songs[current];
    _log.i('Playing $playingSong now.');
    await musicPlayer.play(
      AssetSource('$playingSong'),
      volume: 0.5,
    );
    await musicPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> _resumeMusic() async {
    _log.i('Resuming music');
    switch (musicPlayer.state) {
      case PlayerState.paused:
        try {
          _log.i('Calling _musicPlayer.resume()');
          await musicPlayer.resume();
        } catch (e) {
          // Sometimes, resuming fails with an "Unexpected" error.
          _log.e(e);
          await _playSong(_song);
        }
      case PlayerState.stopped:
        _log.i('resumeMusic() called when music is stopped. '
            "This probably means we haven't yet started the music. "
            'For example, the game was started with sound off.');
        await _playSong(_song);
      case PlayerState.playing:
        _log.w(
          'resumeMusic() called when music is playing. '
          'Nothing to do.',
        );
      case PlayerState.completed:
        _log.w(
          'resumeMusic() called when music is completed. '
          "Music should never be 'completed' as it's either not playing "
          'or looping forever.',
        );
        await _playSong(_song);
      case PlayerState.disposed:
    }
  }

  void startMusic() {
    if (musicPlayer.state != PlayerState.playing) {
      _log.i('Starting music');
      _playSong(_song);
    }
  }

  Future<void> changeMusic(Song current) async {
    _log.i('Changing music');
    if (musicPlayer.state == PlayerState.playing ||
        musicPlayer.state == PlayerState.paused) {
      await musicPlayer.stop();
    }
    _song = current;
    if (!_settings!.musicMuted.value) {
      startMusic();
    }
  }

  Future<void> _stopMusic() async {
    _log.i('Stopping music');
    if (musicPlayer.state == PlayerState.playing) {
      await musicPlayer.pause();
    }
  }

  Future<void> _stopSfx() async {
    _log.i('Stopping all sound effects');
    for (final player in _sfxPlayers) {
      if (player.state == PlayerState.playing) {
        await player.stop();
      }
    }
  }

  Future<void> _stopAllSound() async {
    _log.i('Stopping all sound');
    if (musicPlayer.state == PlayerState.playing) {
      await musicPlayer.pause();
    }
    for (final player in _sfxPlayers) {
      await player.stop();
    }
  }
}
