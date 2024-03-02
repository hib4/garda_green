import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garda_green/app_lifecycle/app_lifecycle.dart';
import 'package:garda_green/audio/audio.dart';
import 'package:garda_green/authentication/authentication.dart';
import 'package:garda_green/game/menu/menu.dart';
import 'package:garda_green/l10n/l10n.dart';
import 'package:garda_green/leaderboard/leaderboard.dart';
import 'package:garda_green/settings/settings.dart';
import 'package:garda_green/theme/app_colors.dart';
import 'package:garda_green/trivia/trivia.dart';
import 'package:garda_green/utils/utils.dart';
import 'package:nes_ui/nes_ui.dart';

class App extends StatelessWidget {
  const App({
    required this.audioController,
    required this.settingsController,
    required this.authenticationRepository,
    required this.leaderboardRepository,
    required this.triviaRepository,
    super.key,
  });

  final AudioController audioController;
  final SettingsController settingsController;
  final AuthenticationRepository authenticationRepository;
  final LeaderboardRepository leaderboardRepository;
  final TriviaRepository triviaRepository;

  @override
  Widget build(BuildContext context) {
    final isShowIntroduction = !context.isSmall && !kIsWeb;
    return AppLifecycleObserver(
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AudioController>(
            create: (context) {
              final lifecycleNotifier =
                  context.read<ValueNotifier<AppLifecycleState>>();
              return audioController
                ..attachLifecycleNotifier(lifecycleNotifier);
            },
            lazy: false,
          ),
          RepositoryProvider<SettingsController>.value(
            value: settingsController,
          ),
          RepositoryProvider<AuthenticationRepository>.value(
            value: authenticationRepository..signInAnonymously(),
          ),
          RepositoryProvider<LeaderboardRepository>.value(
            value: leaderboardRepository,
          ),
          RepositoryProvider<TriviaRepository>.value(
            value: triviaRepository,
          ),
        ],
        child: MaterialApp(
          theme: flutterNesTheme(
            primaryColor: AppColors.primary,
          ),
          title: 'Garda Green',
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: MenuPage(
            isShowIntroduction: !isShowIntroduction,
          ),
        ),
      ),
    );
  }
}
