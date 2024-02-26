import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garda_green/game/score/bloc/score_bloc.dart';
import 'package:garda_green/game/score/input_initials/input_initials.dart';
import 'package:garda_green/leaderboard/leaderboard.dart';
import 'package:nes_ui/nes_ui.dart';

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
    return BlocProvider(
      create: (_) => _scoreBloc,
      child: Scaffold(
        body: BlocBuilder<ScoreBloc, ScoreState>(
          builder: (context, state) {
            return Visibility(
              visible: state.initialsStatus != InitialsFormStatus.success,
              child: const Center(
                child: Column(
                  children: [
                    Spacer(flex: 3),
                    Text(
                      'Enter your initials for\nthe leaderboard',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '(Never put your real initials here)',
                      style: TextStyle(
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    InitialsFormView(),
                    Spacer(flex: 3),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
