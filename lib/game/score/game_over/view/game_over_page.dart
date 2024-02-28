import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garda_green/audio/audio.dart';
import 'package:garda_green/game/menu/menu.dart';
import 'package:garda_green/game/score/input_initials/view/input_initials_page.dart';
import 'package:garda_green/game/view/view.dart';
import 'package:garda_green/gen/assets.gen.dart';
import 'package:garda_green/l10n/l10n.dart';
import 'package:garda_green/trivia/trivia.dart';
import 'package:garda_green/utils/utils.dart';
import 'package:nes_ui/nes_ui.dart';

class GameOverPage extends StatefulWidget {
  const GameOverPage({required this.score, super.key});

  final int score;

  static const id = 'game_over';

  static Page<void> page({required int score}) {
    return MaterialPage<void>(
      child: GameOverPage(
        score: score,
      ),
    );
  }

  @override
  State<GameOverPage> createState() => _GameOverPageState();
}

class _GameOverPageState extends State<GameOverPage> {
  final _isClosed = ValueNotifier<bool>(false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTrivia();
    _showDialog();
  }

  @override
  void dispose() {
    _isClosed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: PopScope(
        onPopInvoked: (_) {
          context.read<AudioController>().musicPlayer.setVolume(0.5);
          context.read<AudioController>().changeMusic(Song.background);
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              filterQuality: FilterQuality.high,
              image: context.isSmall
                  ? Assets.images.gameOverMobile.provider()
                  : Assets.images.gameOverDesktop.provider(),
              fit: BoxFit.cover,
            ),
          ),
          child: ValueListenableBuilder<bool>(
            valueListenable: _isClosed,
            builder: (_, value, __) {
              return Visibility(
                visible: value,
                child: Center(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: NesContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 48),
                        height: MediaQuery.of(context).size.height * .42,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            NesRunningText(
                              text: l10n.gameOverLabel,
                              speed: .05,
                              textStyle: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.gameScoreLabel(widget.score),
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: 150,
                              child: WobblyButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    InputInitialsPage.route(
                                      score: widget.score,
                                    ),
                                  );
                                },
                                child: Text(
                                  l10n.submitScoreLabel,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 150,
                              child: WobblyButton(
                                type: NesButtonType.warning,
                                onPressed: () => onRestart(context),
                                child: Text(l10n.retryLabel),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 150,
                              child: WobblyButton(
                                type: NesButtonType.error,
                                onPressed: () => onExit(context),
                                child: Text(l10n.exitLabel),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _loadTrivia() async {
    final triviaRepository = context.read<TriviaRepository>();
    final languageCode = Localizations.localeOf(context).languageCode;
    await triviaRepository.load(context, languageCode);
  }

  Future<void> _showDialog() async {
    final l10n = context.l10n;
    await Future.delayed(
      const Duration(milliseconds: 500),
      () => GareenDialog.show<void>(
        context: context,
        builder: (_) => Column(
          children: [
            Text(
              l10n.triviaLabel,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 24),
            Text(
              context.read<TriviaRepository>().getTrivia(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ).whenComplete(() => _isClosed.value = true),
    );
  }

  void onRestart(BuildContext context) {
    Navigator.pushReplacement(
      context,
      GameView.route(),
    );
  }

  void onExit(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MenuPage.route(),
      (route) => false,
    );
  }
}
