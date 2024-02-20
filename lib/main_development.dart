import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:garda_green/app/app.dart';
import 'package:garda_green/audio/audio.dart';
import 'package:garda_green/bootstrap.dart';
import 'package:garda_green/firebase_options_development.dart';
import 'package:garda_green/settings/persistence/persistence.dart';
import 'package:garda_green/settings/settings.dart';
import 'package:garda_green/trivia/repository/repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final settings = SettingsController(
    persistence: LocalStorageSettingsPersistence(),
  );

  final audio = AudioController()..attachSettings(settings);
  await audio.initialize();

  final triviaRepository = TriviaRepository();

  unawaited(
    bootstrap(
      () => App(
        audioController: audio,
        settingsController: settings,
        triviaRepository: triviaRepository,
      ),
    ),
  );
}
