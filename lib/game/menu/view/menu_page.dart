import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garda_green/audio/audio.dart';
import 'package:garda_green/constants/constants.dart';
import 'package:garda_green/game/leaderboard/leaderboard.dart';
import 'package:garda_green/game/view/game_view.dart';
import 'package:garda_green/gen/assets.gen.dart';
import 'package:garda_green/l10n/l10n.dart';
import 'package:garda_green/settings/settings.dart';
import 'package:garda_green/utils/components/introduction_dialog.dart';
import 'package:garda_green/utils/utils.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, this.isShowIntroduction = false});

  final bool isShowIntroduction;

  static const id = 'menu';

  static Page<void> page() {
    return const MaterialPage<void>(
      child: MenuPage(),
    );
  }

  static PageRoute<void> route({bool isShowIntroduction = false}) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => MenuPage(
        isShowIntroduction: isShowIntroduction,
      ),
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

    if (widget.isShowIntroduction) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final settings = context.read<SettingsController>();
        if (settings.initialIntroduction.value) {
          await showDialog(
            context: context,
            builder: (context) => const IntroductionDialog(),
          );
          settings.saveInitialIntroduction();
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              const Spacer(),
              Assets.images.gameLogo.image(
                width: context.isSmall ? 282 : 380,
              ),
              const Spacer(flex: 10),
              if (isSmall && kIsWeb)
                const _MobileWebNotAvailablePage()
              else
                const _MenuButtons(),
              const Spacer(),
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
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 150),
          child: WobblyButton(
            type: NesButtonType.success,
            onPressed: () {
              Navigator.push(context, GameView.route());
            },
            child: Text(
              l10n.playLabel,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 150),
          child: WobblyButton(
            onPressed: () {
              Navigator.push(context, LeaderboardPage.route());
            },
            child: Text(
              l10n.leaderboardLabel,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 150),
          child: WobblyButton(
            type: NesButtonType.warning,
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => const SettingsDialog(),
              );
            },
            child: Text(
              l10n.settingsLabel,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 24),
        NesIconButton(
          icon: NesIcons.questionMarkBlock,
          onPress: () async {
            await showDialog(
              context: context,
              builder: (context) => const IntroductionDialog(),
            );
          },
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
              onPressed: () {
                launchUrl(Uri.parse(Urls.playStoreLink));
              },
              child: Text(l10n.downloadLabel),
            ),
          ],
        ),
      ),
    );
  }
}
