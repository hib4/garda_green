import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garda_green/game/leaderboard/leaderboard.dart';
import 'package:garda_green/leaderboard/leaderboard.dart';
import 'package:garda_green/utils/utils.dart';
import 'package:nes_ui/nes_ui.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  static Page<void> page() {
    return const MaterialPage(
      child: LeaderboardPage(),
    );
  }

  static PageRoute<void> route() {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => const LeaderboardPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaderboardBloc(
        leaderboardRepository: context.read<LeaderboardRepository>(),
      )..add(const LeaderboardTop10Requested()),
      child: const LeaderboardView(),
    );
  }
}

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              context.isSmall ? 32 : MediaQuery.of(context).size.width / 4,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const NesRunningText(
                text: 'Leaderboard',
                speed: .05,
                textStyle: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 24),
              NesContainer(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  children: [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
