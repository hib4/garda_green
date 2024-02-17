import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garda_green/audio/audio.dart';
import 'package:garda_green/game/game.dart';
import 'package:garda_green/game/level/level.dart';
import 'package:garda_green/game/menu/menu.dart';
import 'package:garda_green/settings/settings.dart';
import 'package:garda_green/utils/utils.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  static const id = 'game_view';

  static PageRoute<void> route() {
    return buildPageTransition(
      child: const GameView(),
      color: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) {
        context.read<AudioController>().changeMusic(Song.background);
      },
      child: GameWidget<TheRunnerGame>(
        game: TheRunnerGame(
          audioController: context.read<AudioController>(),
          settingsController: context.read<SettingsController>(),
          mediaQuery: MediaQuery.of(context),
        ),
        overlayBuilderMap: {
          PauseMenu.id: (context, game) {
            return PauseMenu(
              onResumePressed: () => onResume(context, game),
              onRestartPressed: () => onRestart(context, game),
              onExitPressed: () => onExit(context, game),
            );
          },
          RetryMenu.id: (context, game) {
            return RetryMenu(
              onRetryPressed: () => onRestart(context, game),
              onExitPressed: () => onExit(context, game),
            );
          },
          LevelComplete.id: (context, game) {
            return LevelComplete(
              nStars: 3,
              onNextPressed: () {},
              onRetryPressed: () => onRestart(context, game),
              onExitPressed: () => onExit(context, game),
            );
          },
        },
      ),
    );
  }

  void onResume(BuildContext context, TheRunnerGame game) {
    game.overlays.remove(PauseMenu.id);
    game.resumeEngine();
  }

  void onRestart(BuildContext context, TheRunnerGame game) {
    Navigator.pushAndRemoveUntil(
      context,
      GameView.route(),
      (route) => false,
    );
    game.resumeEngine();
  }

  void onExit(BuildContext context, TheRunnerGame game) {
    context.read<AudioController>().changeMusic(Song.background);
    Navigator.pushAndRemoveUntil(
      context,
      MainMenu.route(),
      (route) => false,
    );
    game.resumeEngine();
  }
}
