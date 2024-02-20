import 'package:flutter/material.dart';
import 'package:garda_green/game/settings/game_settings.dart';
import 'package:garda_green/game/view/game_view.dart';
import 'package:garda_green/gen/assets.gen.dart';
import 'package:garda_green/theme/app_colors.dart';
import 'package:garda_green/utils/components/components.dart';
import 'package:garda_green/utils/utils.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            filterQuality: FilterQuality.high,
            image: context.isSmall
                ? Assets.images.backgroundMenuMobile.provider()
                : Assets.images.backgroundMenuDesktop.provider(),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              const Spacer(flex: 2),
              Stack(
                children: [
                  NesRunningText(
                    text: 'Garda Green',
                    textStyle: TextStyle(
                      fontSize: 32,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.white,
                    ),
                  ),
                  const NesRunningText(
                    text: 'Garda Green',
                    textStyle: TextStyle(
                      color: AppColors.green,
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
              Spacer(flex: context.isSmall ? 5 : 8),
              WobblyButton(
                type: NesButtonType.success,
                onPressed: () {
                  Navigator.push(context, GameView.route());
                },
                child: const Text('Play'),
              ),
              const SizedBox(height: 16),
              WobblyButton(
                onPressed: () {
                  Navigator.push(context, GameSettings.route());
                },
                child: const Text('Settings'),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
