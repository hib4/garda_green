import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garda_green/app_lifecycle/app_lifecycle.dart';
import 'package:garda_green/audio/audio.dart';
import 'package:garda_green/game/menu/menu.dart';
import 'package:garda_green/l10n/l10n.dart';
import 'package:garda_green/settings/settings.dart';
import 'package:garda_green/trivia/repository/trivia_repository.dart';
import 'package:nes_ui/nes_ui.dart';

class App extends StatefulWidget {
  const App({
    required this.audioController,
    required this.settingsController,
    required this.triviaRepository,
    super.key,
  });

  final AudioController audioController;
  final SettingsController settingsController;
  final TriviaRepository triviaRepository;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AudioController>.value(
            value: widget.audioController,
          ),
          RepositoryProvider<SettingsController>.value(
            value: widget.settingsController,
          ),
          RepositoryProvider<TriviaRepository>.value(
            value: widget.triviaRepository,
          ),
        ],
        child: MaterialApp(
          theme: flutterNesTheme(),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const MainMenu(),
        ),
      ),
    );
  }
}
