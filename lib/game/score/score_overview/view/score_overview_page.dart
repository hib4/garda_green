import 'package:flutter/material.dart';
import 'package:garda_green/game/leaderboard/leaderboard.dart';
import 'package:garda_green/game/menu/menu.dart';
import 'package:garda_green/l10n/l10n.dart';
import 'package:garda_green/utils/components/components.dart';
import 'package:nes_ui/nes_ui.dart';

class ScoreOverviewPage extends StatefulWidget {
  const ScoreOverviewPage({
    required this.initial,
    required this.score,
    super.key,
  });

  final String initial;
  final int score;

  static PageRoute<void> route({
    required String initial,
    required int score,
  }) {
    return MaterialPageRoute(
      builder: (_) => ScoreOverviewPage(
        initial: initial,
        score: score,
      ),
    );
  }

  @override
  State<ScoreOverviewPage> createState() => _ScoreOverviewPageState();
}

class _ScoreOverviewPageState extends State<ScoreOverviewPage> {
  bool _isShown = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isShown) {
      _showPopup();
      _isShown = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  Future<void> _showPopup() async {
    final l10n = context.l10n;
    await Future.delayed(
      const Duration(milliseconds: 250),
      () {
        GareenDialog.show<void>(
          context: context,
          isShowCloseButton: false,
          builder: (_) => PopScope(
            canPop: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.youScoredMessage,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                NesContainer(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    widget.initial,
                    style: const TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.gameScoreLabel(widget.score),
                  style: const TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                WobblyButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      LeaderboardPage.route(
                        playBackgroundMusic: true,
                      ),
                    );
                  },
                  child: Text(l10n.leaderboardLabel),
                ),
                const SizedBox(height: 16),
                WobblyButton(
                  type: NesButtonType.error,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MenuPage.route(),
                    );
                  },
                  child: Text(l10n.exitLabel),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
