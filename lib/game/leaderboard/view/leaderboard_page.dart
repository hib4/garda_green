import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garda_green/audio/audio.dart';
import 'package:garda_green/game/leaderboard/leaderboard.dart';
import 'package:garda_green/gen/assets.gen.dart';
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
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              filterQuality: FilterQuality.high,
              image: context.isSmall
                  ? Assets.images.leaderboardMobile.provider()
                  : Assets.images.leaderboardDesktop.provider(),
              fit: context.isSmall ? BoxFit.cover : BoxFit.fitHeight,
              repeat:
                  context.isSmall ? ImageRepeat.noRepeat : ImageRepeat.repeat,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(flex: 7),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: NesContainer(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 2,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            l10n.leaderboardLabel,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          BlocBuilder<LeaderboardBloc, LeaderboardState>(
                            builder: (context, state) => switch (state) {
                              LeaderboardInitial() => const SizedBox.shrink(),
                              LeaderboardLoading() =>
                                const _LeaderboardLoadingWidget(),
                              LeaderboardError() =>
                                const LeaderboardErrorWidget(),
                              LeaderboardLoaded(entries: final entries) =>
                                _LeaderboardContent(entries: entries),
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                WobblyButton(
                  type: NesButtonType.error,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.backLabel),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LeaderboardLoadingWidget extends StatelessWidget {
  const _LeaderboardLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: NesHourglassLoadingIndicator(),
      ),
    );
  }
}

class LeaderboardErrorWidget extends StatelessWidget {
  const LeaderboardErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Expanded(
      child: Center(
        child: Text(l10n.errorInputScoreMessage),
      ),
    );
  }
}

class _LeaderboardContent extends StatelessWidget {
  const _LeaderboardContent({
    required this.entries,
  });

  final List<LeaderboardEntryData> entries;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Expanded(
      child: entries.isEmpty
          ? Center(
              child: Text(
                l10n.leaderboardEmptyMessage,
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          '#${index + 1}',
                          style: TextStyle(
                            color: switch (index) {
                              0 => const Color(0xFFD4AF37),
                              1 => const Color(0xFF9BADB7),
                              2 => const Color(0xFFCD7F32),
                              _ => const Color(0xFF1E1E1E),
                            },
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        entries[index].playerInitials,
                        style: TextStyle(
                          color: switch (index) {
                            0 => const Color(0xFFD4AF37),
                            1 => const Color(0xFF9BADB7),
                            2 => const Color(0xFFCD7F32),
                            _ => const Color(0xFF1E1E1E),
                          },
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          entries[index].score.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const Text(
                        ' Pts',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
