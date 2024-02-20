import 'package:equatable/equatable.dart';

class Trivia extends Equatable {
  const Trivia({required this.trivia});

  factory Trivia.fromJson(Map<String, dynamic> json) {
    final triviaFromJson = json['trivia'];
    if (triviaFromJson is! List<dynamic>) {
      throw Exception('Trivia is not a list');
    }
    return Trivia(
      trivia: List<String>.from(triviaFromJson),
    );
  }

  final List<String> trivia;

  @override
  List<Object?> get props => [trivia];
}
