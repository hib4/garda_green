import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:garda_green/app/app.dart';
import 'package:garda_green/audio/audio.dart';
import 'package:garda_green/authentication/authentication.dart';
import 'package:garda_green/bootstrap.dart';
import 'package:garda_green/firebase_options_development.dart';
import 'package:garda_green/leaderboard/leaderboard.dart';
import 'package:garda_green/settings/persistence/persistence.dart';
import 'package:garda_green/settings/settings.dart';
import 'package:garda_green/trivia/trivia.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.fullScreen();

  await Flame.device.setPortrait();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final settings = SettingsController(
    persistence: LocalStorageSettingsPersistence(),
  );

  final audio = AudioController()..attachSettings(settings);
  await audio.initialize();

  final leaderboardRepository = LeaderboardRepository(
    FirebaseFirestore.instance,
  );

  final triviaRepository = TriviaRepository();

  unawaited(
    bootstrap(
      (firebaseAuth) async {
        final authenticationRepository = AuthenticationRepository(
          firebaseAuth: firebaseAuth,
        );

        return App(
          audioController: audio,
          settingsController: settings,
          authenticationRepository: authenticationRepository,
          leaderboardRepository: leaderboardRepository,
          triviaRepository: triviaRepository,
        );
      },
    ),
  );
}
