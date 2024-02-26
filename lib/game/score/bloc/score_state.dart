part of 'score_bloc.dart';

enum InitialsFormStatus {
  initial,
  loading,
  success,
  invalid,
  failure,
  blacklisted,
}

class ScoreState extends Equatable {
  const ScoreState({
    this.initials = const ['', '', '', ''],
    this.initialsStatus = InitialsFormStatus.initial,
  });

  final List<String> initials;
  final InitialsFormStatus initialsStatus;

  ScoreState copyWith({
    List<String>? initials,
    InitialsFormStatus? initialsStatus,
  }) {
    return ScoreState(
      initials: initials ?? this.initials,
      initialsStatus: initialsStatus ?? this.initialsStatus,
    );
  }

  @override
  List<Object> get props => [initials, initialsStatus];
}
