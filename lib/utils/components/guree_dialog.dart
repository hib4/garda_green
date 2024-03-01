import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garda_green/l10n/l10n.dart';
import 'package:garda_green/settings/settings.dart';
import 'package:garda_green/utils/components/components.dart';
import 'package:nes_ui/nes_ui.dart';

class GureeDialog extends StatelessWidget {
  const GureeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = context.watch<SettingsController>();
    return Align(
      child: Material(
        color: Colors.transparent,
        child: IntrinsicWidth(
          stepHeight: 0.56,
          child: SizedBox.expand(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                NesContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 200),
                        child: Column(
                          children: [
                            Text(
                              l10n.pausedLabel,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ListTile(
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
                            ListTile(
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
                            const SizedBox(height: 16),
                            WobblyButton(
                              type: NesButtonType.error,
                              child: Text(l10n.backLabel),
                              onPressed: () {
                                Navigator.popUntil(
                                  context,
                                  (route) => route.isFirst,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -8,
                  top: -8,
                  child: NesButton(
                    type: NesButtonType.error,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: NesIcon(
                      size: const Size(16, 16),
                      iconData: NesIcons.close,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
