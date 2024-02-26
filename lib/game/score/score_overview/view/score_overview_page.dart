import 'package:flutter/material.dart';
import 'package:garda_green/game/leaderboard/leaderboard.dart';
import 'package:garda_green/game/menu/menu.dart';
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
  @override
  void initState() {
    _showPopup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  Future<void> _showPopup() async {
    await Future.delayed(
      const Duration(milliseconds: 250),
      () {
        GareenDialog.show<void>(
          context: context,
          isShowCloseButton: false,
          builder: (_) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Wohoo!\nYou scored',
                style: TextStyle(fontSize: 24),
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
                '${widget.score} Pts',
                style: const TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              WobblyButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    LeaderboardPage.route(),
                  );
                },
                child: const Text('Leaderboard'),
              ),
              const SizedBox(height: 16),
              WobblyButton(
                type: NesButtonType.error,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MenuPage.route(),
                    (route) => false,
                  );
                },
                child: const Text('Exit'),
              ),
            ],
          ),
        );
      },
    );
  }
}
