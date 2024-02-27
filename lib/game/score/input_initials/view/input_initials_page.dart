import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garda_green/audio/audio.dart';
import 'package:garda_green/game/score/bloc/score_bloc.dart';
import 'package:garda_green/game/score/input_initials/input_initials.dart';
import 'package:garda_green/l10n/l10n.dart';
import 'package:garda_green/leaderboard/leaderboard.dart';

class InputInitialsPage extends StatefulWidget {
  const InputInitialsPage({required this.score, super.key});

  final int score;

  static Page<void> page({required int score}) {
    return MaterialPage<void>(
      child: InputInitialsPage(
        score: score,
      ),
    );
  }

  static PageRoute<void> route({required int score}) {
    return MaterialPageRoute(
      builder: (_) =>
          InputInitialsPage(
            score: score,
          ),
    );
  }

  @override
  State<InputInitialsPage> createState() => _InputInitialsPageState();
}

class _InputInitialsPageState extends State<InputInitialsPage> {
  late final ScoreBloc _scoreBloc;

  @override
  void initState() {
    _scoreBloc = ScoreBloc(
      score: widget.score,
      leaderboardRepository: context.read<LeaderboardRepository>(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (_) => _scoreBloc,
      child: Scaffold(
        body: PopScope(
          onPopInvoked: (_) {
            context.read<AudioController>().musicPlayer.setVolume(0.5);
            context.read<AudioController>().changeMusic(Song.background);
          },
          child: BlocBuilder<ScoreBloc, ScoreState>(
            builder: (context, state) {
              return Visibility(
                visible: state.initialsStatus != InitialsFormStatus.success,
                child: Center(
                  child: Column(
                    children: [
                      const Spacer(flex: 3),
                      Text(
                        l10n.enterInitialsLabel,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.enterInitialsMessage,
                        style: const TextStyle(
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      const InitialsFormView(),
                      const Spacer(flex: 3),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
