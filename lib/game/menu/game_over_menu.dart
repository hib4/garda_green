import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garda_green/l10n/l10n.dart';
import 'package:garda_green/theme/theme.dart';
import 'package:garda_green/trivia/trivia.dart';
import 'package:garda_green/utils/components/components.dart';
import 'package:garda_green/utils/components/gareen_dialog.dart';
import 'package:nes_ui/nes_ui.dart';

class GameOverMenu extends StatefulWidget {
  const GameOverMenu({
    super.key,
    this.onRetryPressed,
    this.onExitPressed,
  });

  final VoidCallback? onRetryPressed;
  final VoidCallback? onExitPressed;

  static const id = 'game_over';

  static PageRoute<void> route() {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const GameOverMenu(),
    );
  }

  @override
  State<GameOverMenu> createState() => _GameOverMenuState();
}

class _GameOverMenuState extends State<GameOverMenu> {
  final _isClosed = ValueNotifier<bool>(false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTrivia();
    _showDialog();
  }

  @override
  void dispose() {
    _isClosed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.overlayBackground,
      body: ValueListenableBuilder<bool>(
        valueListenable: _isClosed,
        builder: (_, value, __) {
          return Visibility(
            visible: value,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NesRunningText(
                    text: l10n.gameOverLabel,
                    speed: .05,
                    textStyle: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 150,
                    child: WobblyButton(
                      type: NesButtonType.warning,
                      onPressed: widget.onRetryPressed,
                      child: Text(l10n.retryLabel),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 150,
                    child: WobblyButton(
                      type: NesButtonType.error,
                      onPressed: widget.onExitPressed,
                      child: Text(l10n.exitLabel),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadTrivia() async {
    final triviaRepository = context.read<TriviaRepository>();
    final languageCode = Localizations.localeOf(context).languageCode;
    await triviaRepository.load(context, languageCode);
  }

  Future<void> _showDialog() async {
    final l10n = context.l10n;
    await Future.delayed(
      const Duration(milliseconds: 500),
      () => GareenDialog.show<void>(
        context: context,
        builder: (_) => Column(
          children: [
            Text(
              l10n.triviaLabel,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 24),
            Text(
              context.read<TriviaRepository>().getTrivia(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ).whenComplete(() => _isClosed.value = true),
    );
  }
}
