import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garda_green/audio/audio.dart';
import 'package:garda_green/game/leaderboard/leaderboard.dart';
import 'package:garda_green/game/settings/game_settings.dart';
import 'package:garda_green/game/view/game_view.dart';
import 'package:garda_green/gen/assets.gen.dart';
import 'package:garda_green/l10n/l10n.dart';
import 'package:garda_green/theme/app_colors.dart';
import 'package:garda_green/utils/utils.dart';
import 'package:nes_ui/nes_ui.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  static const id = 'menu';

  static Page<void> page() {
    return const MaterialPage<void>(
      child: MenuPage(),
    );
  }

  static PageRoute<void> route() {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const MenuPage(),
    );
  }

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    context.read<AudioController>().musicPlayer.setVolume(0.5);
    context.read<AudioController>().changeMusic(Song.background);
    super.initState();
  }

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
              Spacer(flex: context.isSmall ? 6 : 8),
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
        SizedBox(
          width: 150,
          child: WobblyButton(
            type: NesButtonType.success,
            onPressed: () {
              Navigator.push(context, GameView.route());
            },
            child: Text(l10n.playLabel),
          ),
        ),
        const SizedBox(height: 16),
        WobblyButton(
          onPressed: () {
            Navigator.push(context, LeaderboardPage.route());
          },
          child: Text(l10n.leaderboardLabel),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 150,
          child: WobblyButton(
            type: NesButtonType.warning,
            onPressed: () {
              Navigator.push(context, GameSettings.route());
            },
            child: Text(l10n.settingsLabel),
          ),
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
