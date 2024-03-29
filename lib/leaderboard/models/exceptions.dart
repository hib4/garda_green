abstract class LeaderboardException implements Exception {
  /// {@macro leaderboard_exception}
  const LeaderboardException(this.error, this.stackTrace);

  /// The error that was caught.
  final Object error;

  /// The Stacktrace associated with the [error].
  final StackTrace stackTrace;
}

/// {@template leaderboard_deserialization_exception}
/// Exception thrown when leaderboard data cannot be deserialized in the
/// expected way.
/// {@endtemplate}
class LeaderboardDeserializationException extends LeaderboardException {
  /// {@macro leaderboard_deserialization_exception}
  const LeaderboardDeserializationException(super.error, super.stackTrace);
}

/// {@template fetch_top_10_leaderboard_exception}
/// Exception thrown when failure occurs while fetching top 10 leaderboard.
/// {@endtemplate}
class FetchTop10LeaderboardException extends LeaderboardException {
  /// {@macro fetch_top_10_leaderboard_exception}
  const FetchTop10LeaderboardException(super.error, super.stackTrace);
}

/// {@template fetch_leaderboard_exception}
/// Exception thrown when failure occurs while fetching the leaderboard.
/// {@endtemplate}
class FetchLeaderboardException extends LeaderboardException {
  /// {@macro fetch_top_10_leaderboard_exception}
  const FetchLeaderboardException(super.error, super.stackTrace);
}

/// {@template add_leaderboard_entry_exception}
/// Exception thrown when failure occurs while adding entry to leaderboard.
/// {@endtemplate}
class AddLeaderboardEntryException extends LeaderboardException {
  /// {@macro add_leaderboard_entry_exception}
  const AddLeaderboardEntryException(super.error, super.stackTrace);
}
