import 'package:flutter/material.dart';
import 'package:garda_green/game/settings/game_settings.dart';
import 'package:garda_green/game/view/game_view.dart';
import 'package:nes_ui/nes_ui.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  static const id = 'main_menu';

  static PageRoute<void> route() {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const MainMenu(),
    );
  }

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final ValueNotifier<int> _isHovered = ValueNotifier(0);

  @override
  void dispose() {
    _isHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            const Text(
              'Global Gamers',
              style: TextStyle(
                fontSize: 32,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 3),
            NesPressable(
              onPress: () {
                Navigator.push(context, GameView.route());
              },
              onPressStart: () {
                _isHovered.value = 1;
              },
              onPressEnd: () {
                _isHovered.value = 0;
              },
              child: ValueListenableBuilder(
                valueListenable: _isHovered,
                builder: (context, value, child) {
                  return Text(
                    'Play',
                    style: TextStyle(
                      color: value == 1 ? Colors.green : Colors.black,
                      fontSize: 24,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            NesPressable(
              onPress: () => Navigator.push(context, GameSettings.route()),
              onPressStart: () {
                _isHovered.value = 2;
              },
              onPressEnd: () {
                _isHovered.value = 0;
              },
              child: ValueListenableBuilder(
                valueListenable: _isHovered,
                builder: (context, value, child) {
                  return Text(
                    'Settings',
                    style: TextStyle(
                      color: value == 2 ? Colors.green : Colors.black,
                      fontSize: 24,
                    ),
                  );
                },
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
