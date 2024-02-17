import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garda_green/settings/settings_controller.dart';
import 'package:nes_ui/nes_ui.dart';

class GameSettings extends StatelessWidget {
  const GameSettings({super.key});

  static const id = 'game_settings';

  static PageRoute<void> route() {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const GameSettings(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Music',
                    style: TextStyle(fontSize: 18),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: settingsController.musicMuted,
                    builder: (_, value, __) {
                      return NesCheckBox(
                        value: !value,
                        onChange: (_) {
                          settingsController.toggleMusicMuted();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sfx',
                    style: TextStyle(fontSize: 18),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: settingsController.sfxMuted,
                    builder: (_, value, __) {
                      return NesCheckBox(
                        value: !value,
                        onChange: (_) {
                          settingsController.toggleSfxMuted();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            NesIconButton(
              icon: NesIcons.thinArrowLeft,
              size: const Size.fromHeight(24),
              onPress: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
