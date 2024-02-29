import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garda_green/audio/audio.dart';
import 'package:garda_green/game/game.dart';
import 'package:garda_green/game/menu/menu.dart';
import 'package:garda_green/game/pause/pause.dart';
import 'package:garda_green/game/score/score.dart';
import 'package:garda_green/settings/settings.dart';
import 'package:garda_green/theme/theme.dart';
import 'package:garda_green/utils/utils.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  static const id = 'game_view';

  static Page<void> page() {
    return const MaterialPage<void>(
      child: GameView(),
    );
  }

  static PageRoute<void> route() {
    return buildPageTransition(
      child: const GameView(),
      color: AppColors.transition,
    );
  }

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late final GardaGreenGame _game;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final audioController = context.read<AudioController>();
      final settingsController = context.read<SettingsController>();
      _game = GardaGreenGame(
        audioController: audioController,
        settingsController: settingsController,
        aspectRatio: MediaQuery.of(context).size.aspectRatio,
        top: MediaQuery.of(context).viewPadding.top,
        isMobile: context.isSmall,
        playMusic: true,
      );
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        if (!value) {
          _game.pauseEngine();
          _game.overlays.add(PausePage.id);
        }
      },
      child: GameWidget<GardaGreenGame>.controlled(
        gameFactory: () => _game,
        overlayBuilderMap: {
          PausePage.id: (context, game) {
            return PausePage(
              onResumePressed: () => _onResume(game),
              onRestartPressed: () => _onRestart(context),
              onExitPressed: () => _onExit(context),
            );
          },
          ScorePage.id: (context, game) {
            return ScorePage(
              score: game.score,
            );
          },
        },
      ),
    );
  }

  void _onResume(GardaGreenGame game) {
    game.overlays.remove(PausePage.id);
    game.resumeEngine();
  }

  void _onRestart(BuildContext context) {
    Navigator.pushReplacement(
      context,
      GameView.route(),
    );
  }

  void _onExit(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MenuPage.route(),
      (route) => false,
    );
  }
}
