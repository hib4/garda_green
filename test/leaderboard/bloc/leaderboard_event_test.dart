// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:garda_green/game/leaderboard/leaderboard.dart';

void main() {
  group('LeaderboardTop10Requested', () {
    test(
      'supports value equality',
      () => expect(
        LeaderboardTop10Requested(),
        LeaderboardTop10Requested(),
      ),
    );
  });
}
