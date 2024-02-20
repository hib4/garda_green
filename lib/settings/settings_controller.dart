// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:garda_green/settings/persistence/settings_persistence.dart';

/// An class that holds settings like [musicMuted],
/// and saves them to an injected persistence store.
class SettingsController {
  /// Creates a new instance of [SettingsController] backed by [persistence].
  SettingsController({required SettingsPersistence persistence})
      : _persistence = persistence;
  final SettingsPersistence _persistence;

  ValueNotifier<bool> musicMuted = ValueNotifier(false);

  ValueNotifier<bool> sfxMuted = ValueNotifier(false);

  /// Asynchronously loads values from the injected persistence store.
  Future<void> loadStateFromPersistence() async {
    await Future.wait([
      // On the web, sound can only start after user interaction, so
      // we start muted there.
      // On any other platform, we start unmuted.
      _persistence
          .getMusicMuted(defaultValue: kIsWeb)
          .then((value) => musicMuted.value = value),
      _persistence
          .getSfxMuted(defaultValue: kIsWeb)
          .then((value) => sfxMuted.value = value),
    ]);
  }

  void toggleMusicMuted() {
    musicMuted.value = !musicMuted.value;
    _persistence.saveMusicMuted(active: musicMuted.value);
  }

  void toggleSfxMuted() {
    sfxMuted.value = !sfxMuted.value;
    _persistence.saveSfxMuted(active: sfxMuted.value);
  }
}
