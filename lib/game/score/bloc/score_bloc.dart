import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:garda_green/leaderboard/leaderboard.dart';

part 'score_event.dart';
part 'score_state.dart';

class ScoreBloc extends Bloc<ScoreEvent, ScoreState> {
  ScoreBloc({
    required this.score,
    required LeaderboardRepository leaderboardRepository,
  })  : _leaderboardRepository = leaderboardRepository,
        super(const ScoreState()) {
    on<ScoreInitialsUpdated>(_onScoreInitialsUpdated);
    on<ScoreInitialsSubmitted>(_onScoreInitialsSubmitted);
  }

  final int score;
  final LeaderboardRepository _leaderboardRepository;

  final initialsRegex = RegExp('[A-Z]{3}');

  void _onScoreInitialsUpdated(
    ScoreInitialsUpdated event,
    Emitter<ScoreState> emit,
  ) {
    final initials = [...state.initials];
    initials[event.index] = event.character;
    final initialsStatus =
        (state.initialsStatus == InitialsFormStatus.blacklisted)
            ? InitialsFormStatus.initial
            : state.initialsStatus;
    emit(state.copyWith(initials: initials, initialsStatus: initialsStatus));
  }

  Future<void> _onScoreInitialsSubmitted(
    ScoreInitialsSubmitted event,
    Emitter<ScoreState> emit,
  ) async {
    if (!_hasValidPattern()) {
      emit(state.copyWith(initialsStatus: InitialsFormStatus.invalid));
    } else if (_isInitialsBlacklisted()) {
      emit(state.copyWith(initialsStatus: InitialsFormStatus.blacklisted));
    } else {
      emit(state.copyWith(initialsStatus: InitialsFormStatus.loading));
      try {
        await _leaderboardRepository.addLeaderboardEntry(
          LeaderboardEntryData(
            playerInitials: state.initials.join(),
            score: score,
          ),
        );

        emit(state.copyWith(initialsStatus: InitialsFormStatus.success));
      } catch (e, s) {
        addError(e, s);
        emit(state.copyWith(initialsStatus: InitialsFormStatus.failure));
      }
    }
  }

  bool _hasValidPattern() {
    final value = state.initials;
    return value.isNotEmpty && initialsRegex.hasMatch(value.join());
  }

  bool _isInitialsBlacklisted() {
    return _blacklist.contains(state.initials.join());
  }
}

const _blacklist = [
  'FUK',
  'FUC',
  'FCK',
  'COK',
  'DIK',
  'KKK',
  'SHT',
  'CNT',
  'ASS',
  'CUM',
  'FAG',
  'GAY',
  'GOD',
  'JEW',
  'SEX',
  'TIT',
  'WTF',
  'XXX',
  'RIP',
  'ASU',
  'MMK',
  'KTL',
  'LER',
  'AJG',
  'DIE',
  'KIL',
  'MUR',
  'HOT',
  'DAM',
  'NUT',
  'NIP',
  'NIG',
  'NUD',
];
