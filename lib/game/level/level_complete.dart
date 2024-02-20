import 'package:flutter/material.dart';
import 'package:garda_green/theme/theme.dart';

class LevelComplete extends StatelessWidget {
  const LevelComplete({
    required this.nStars,
    this.onNextPressed,
    this.onRetryPressed,
    this.onExitPressed,
    super.key,
  });

  static const id = 'level_complete';

  final int nStars;

  final VoidCallback? onNextPressed;
  final VoidCallback? onRetryPressed;
  final VoidCallback? onExitPressed;

  static PageRoute<void> route({required int nStars}) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => LevelComplete(nStars: nStars),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.overlayBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Level Completed',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  nStars >= 1 ? Icons.star : Icons.star_border,
                  color: nStars >= 1 ? Colors.amber : Colors.black,
                  size: 50,
                ),
                Icon(
                  nStars >= 2 ? Icons.star : Icons.star_border,
                  color: nStars >= 2 ? Colors.amber : Colors.black,
                  size: 50,
                ),
                Icon(
                  nStars >= 3 ? Icons.star : Icons.star_border,
                  color: nStars >= 3 ? Colors.amber : Colors.black,
                  size: 50,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 150,
              child: OutlinedButton(
                onPressed: nStars != 0 ? onNextPressed : null,
                child: const Text('Next'),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 150,
              child: OutlinedButton(
                onPressed: onRetryPressed,
                child: const Text('Retry'),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 150,
              child: OutlinedButton(
                onPressed: onExitPressed,
                child: const Text('Exit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
