import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garda_green/l10n/l10n.dart';
import 'package:garda_green/settings/settings.dart';
import 'package:garda_green/theme/app_colors.dart';
import 'package:garda_green/utils/components/components.dart';
import 'package:nes_ui/nes_ui.dart';

class PausePage extends StatelessWidget {
  const PausePage({
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
      pageBuilder: (_, __, ___) => const PausePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = context.watch<SettingsController>();
    return Scaffold(
      backgroundColor: AppColors.overlayBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.pausedLabel,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 150,
              child: WobblyButton(
                onPressed: onResumePressed,
                child: Text(l10n.resumeLabel),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 150,
              child: WobblyButton(
                type: NesButtonType.warning,
                onPressed: onRestartPressed,
                child: Text(l10n.restartLabel),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 150,
              child: WobblyButton(
                type: NesButtonType.error,
                onPressed: onExitPressed,
                child: Text(l10n.exitLabel),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 150,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.musicLabel),
                trailing: ValueListenableBuilder<bool>(
                  valueListenable: settings.musicMuted,
                  builder: (context, value, child) {
                    return NesCheckBox(
                      value: !value,
                      onChange: (value) {
                        settings.toggleMusicMuted();
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.sfxLabel),
                trailing: ValueListenableBuilder<bool>(
                  valueListenable: settings.sfxMuted,
                  builder: (_, value, __) {
                    return NesCheckBox(
                      value: !value,
                      onChange: (value) {
                        settings.toggleSfxMuted();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
