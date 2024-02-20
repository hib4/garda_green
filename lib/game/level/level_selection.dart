import 'package:flutter/material.dart';
import 'package:garda_green/game/game.dart';
import 'package:nes_ui/nes_ui.dart';

class LevelSelection extends StatelessWidget {
  const LevelSelection({
    super.key,
    this.onLevelSelected,
    this.onBackPressed,
  });

  static const id = 'level_selection';

  final ValueChanged<int>? onLevelSelected;
  final VoidCallback? onBackPressed;

  static PageRoute<void> route() {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const LevelSelection(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Level Selection',
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: TheRunnerGame.isMobile ? 2 : 3,
                  mainAxisExtent: 50,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  return OutlinedButton(
                    onPressed: () => onLevelSelected?.call(index + 1),
                    child: Text('Level ${index + 1}'),
                  );
                },
                itemCount: 6,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 100),
              ),
            ),
            const SizedBox(height: 6),
            NesIconButton(
              icon: NesIcons.thinArrowLeft,
              size: const Size.fromHeight(24),
              onPress: onBackPressed,
            ),
          ],
        ),
      ),
    );
  }
}
