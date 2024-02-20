// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:garda_green/settings/persistence/settings_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An implementation of [SettingsPersistence] that uses
/// `package:shared_preferences`.
class LocalStorageSettingsPersistence extends SettingsPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  @override
  Future<bool> getMusicMuted({required bool defaultValue}) async {
    final prefs = await instanceFuture;
    return prefs.getBool('musicMuted') ?? defaultValue;
  }

  @override
  Future<bool> getSfxMuted({required bool defaultValue}) async {
    final prefs = await instanceFuture;
    return prefs.getBool('sfxMuted') ?? defaultValue;
  }

  @override
  Future<void> saveMusicMuted({required bool active}) async {
    final prefs = await instanceFuture;
    await prefs.setBool('musicMuted', active);
  }

  @override
  Future<void> saveSfxMuted({required bool active}) async {
    final prefs = await instanceFuture;
    await prefs.setBool('sfxMuted', active);
  }
}
