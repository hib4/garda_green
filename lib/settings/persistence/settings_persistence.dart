// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// An interface of persistence stores for settings.
///
/// Implementations can range from simple in-memory storage through
/// local preferences to cloud-based solutions.
abstract class SettingsPersistence {
  Future<bool> getMusicMuted({required bool defaultValue});

  Future<bool> getSfxMuted({required bool defaultValue});

  Future<bool> getInitialIntroduction();

  Future<void> saveMusicMuted({required bool active});

  Future<void> saveSfxMuted({required bool active});

  Future<void> saveInitialIntroduction();
}
