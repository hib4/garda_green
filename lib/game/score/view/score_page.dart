import 'package:flutter/widgets.dart';
import 'package:garda_green/game/score/score.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({
    required this.score,
    super.key,
  });

  final int score;

  static const id = 'score';

  static PageRoute<void> route({required int points}) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => ScorePage(score: points),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameOverPage(score: score);
  }
}
