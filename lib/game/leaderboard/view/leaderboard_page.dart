import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garda_green/audio/audio.dart';
import 'package:garda_green/game/leaderboard/leaderboard.dart';
import 'package:garda_green/l10n/l10n.dart';
import 'package:garda_green/leaderboard/leaderboard.dart';
import 'package:garda_green/utils/utils.dart';
import 'package:nes_ui/nes_ui.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key, this.playBackgroundMusic = false});

  final bool playBackgroundMusic;

  static Page<void> page() {
    return const MaterialPage(
      child: LeaderboardPage(),
    );
  }

  static PageRoute<void> route({bool playBackgroundMusic = false}) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => LeaderboardPage(
        playBackgroundMusic: playBackgroundMusic,
      ),
    );
  }

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  void initState() {
    context.read<AudioController>().musicPlayer.setVolume(0.5);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaderboardBloc(
        leaderboardRepository: context.read<LeaderboardRepository>(),
      )..add(const LeaderboardTop10Requested()),
      child: LeaderboardView(
        playBackgroundMusic: widget.playBackgroundMusic,
      ),
    );
  }
}

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({
    this.playBackgroundMusic = false,
    super.key,
  });

  final bool playBackgroundMusic;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: PopScope(
        onPopInvoked: (_) {
          if (playBackgroundMusic) {
            context.read<AudioController>().musicPlayer.setVolume(0.5);
            context.read<AudioController>().changeMusic(Song.background);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
                context.isSmall ? 32 : MediaQuery.of(context).size.width / 4,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NesRunningText(
                  text: l10n.leaderboardLabel,
                  speed: .05,
                  textStyle: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 24),
                NesContainer(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  child: const Column(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
