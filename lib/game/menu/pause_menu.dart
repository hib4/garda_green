import 'package:flutter/material.dart';
import 'package:garda_green/theme/app_colors.dart';
import 'package:garda_green/utils/components/components.dart';
import 'package:nes_ui/nes_ui.dart';

class PauseMenu extends StatelessWidget {
  const PauseMenu({
    super.key,
    this.onResumePressed,
    this.onRestartPressed,
    this.onExitPressed,
  });

  final VoidCallback? onResumePressed;
  final VoidCallback? onRestartPressed;
  final VoidCallback? onExitPressed;

  static const id = 'pause_menu';

  static PageRoute<void> route() {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const PauseMenu(),
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
              'Paused',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 150,
              child: WobblyButton(
                onPressed: onResumePressed,
                child: const Text('Resume'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 150,
              child: WobblyButton(
                type: NesButtonType.warning,
                onPressed: onRestartPressed,
                child: const Text('Restart'),
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
