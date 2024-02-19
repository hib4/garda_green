import 'package:flutter/material.dart';
import 'package:garda_green/theme/theme.dart';
import 'package:garda_green/utils/components/components.dart';
import 'package:nes_ui/nes_ui.dart';

class GameOverMenu extends StatelessWidget {
  const GameOverMenu({
    super.key,
    this.onRetryPressed,
    this.onExitPressed,
  });

  final VoidCallback? onRetryPressed;
  final VoidCallback? onExitPressed;

  static const id = 'game_over';

  static PageRoute<void> route() {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const GameOverMenu(),
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
            const NesRunningText(
              text: 'Game Over',
              speed: .05,
              textStyle: TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 150,
              child: WobblyButton(
                type: NesButtonType.warning,
                onPressed: onRetryPressed,
                child: const Text('Retry'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 150,
              child: WobblyButton(
                type: NesButtonType.error,
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
