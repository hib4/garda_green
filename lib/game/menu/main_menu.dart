import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:garda_green/game/settings/game_settings.dart';
import 'package:garda_green/game/view/game_view.dart';
import 'package:garda_green/gen/assets.gen.dart';
import 'package:garda_green/l10n/l10n.dart';
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
    final l10n = context.l10n;
    final isSmall = context.isSmall;
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
                    text: l10n.gameTitle,
                    textStyle: TextStyle(
                      fontSize: context.isSmall ? 32 : 38,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.white,
                    ),
                  ),
                  NesRunningText(
                    text: l10n.gameTitle,
                    textStyle: TextStyle(
                      color: AppColors.green,
                      fontSize: context.isSmall ? 32 : 38,
                    ),
                  ),
                ],
              ),
              Spacer(flex: context.isSmall ? 5 : 8),
              if (isSmall && kIsWeb)
                const _MobileWebNotAvailablePage()
              else
                const _MenuButtons(),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButtons extends StatelessWidget {
  const _MenuButtons();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        WobblyButton(
          type: NesButtonType.success,
          onPressed: () {
            Navigator.push(context, GameView.route());
          },
          child: Text(l10n.playLabel),
        ),
        const SizedBox(height: 16),
        WobblyButton(
          onPressed: () {
            Navigator.push(context, GameSettings.route());
          },
          child: Text(l10n.settingsLabel),
        ),
      ],
    );
  }
}

class _MobileWebNotAvailablePage extends StatelessWidget {
  const _MobileWebNotAvailablePage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: NesContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              l10n.downloadMessage,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            WobblyButton(
              type: NesButtonType.success,
              onPressed: () {},
              child: Text(l10n.downloadLabel),
            ),
          ],
        ),
      ),
    );
  }
}
