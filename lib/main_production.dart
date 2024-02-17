import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:garda_green/app/app.dart';
import 'package:garda_green/bootstrap.dart';
import 'package:garda_green/firebase_options_production.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  unawaited(
    bootstrap(
      () => const App(),
    ),
  );
}
