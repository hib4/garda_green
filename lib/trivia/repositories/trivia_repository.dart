import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garda_green/trivia/models/models.dart';

/// `TriviaRepository` is a class that handles the loading
/// and retrieval of trivia data.
class TriviaRepository {
  /// `_random` is a `Random` instance used to generate random indices
  /// for trivia retrieval.
  final Random _random = Random();

  /// `_trivia` is a `Trivia` instance that holds the loaded trivia data.
  late Trivia _trivia;

  /// `_isLoaded` is a boolean that indicates whether the trivia data
  /// has been loaded.
  bool _isLoaded = false;

  /// `_fetchData` is a private method that loads trivia data from a JSON file.
  /// The JSON file is determined by the `languageCode` parameter.
  /// It returns a `Trivia` instance created from the loaded JSON data.
  Future<Trivia> _fetchData(String languageCode) async {
    try {
      final jsonString = await rootBundle
          .loadString('assets/trivia/trivia_$languageCode.json');
      final parsedJson = json.decode(jsonString) as Map<String, dynamic>;
      return Trivia.fromJson(parsedJson);
    } catch (e) {
      throw Exception('Failed to load trivia data');
    }
  }

  /// `load` is a method that loads trivia data if it hasn't been loaded yet.
  /// It takes a `BuildContext` and a `languageCode` as parameters.
  /// It returns a boolean indicating the success of the operation.
  Future<bool> load(BuildContext context, String languageCode) async {
    if (_isLoaded) return true;
    try {
      _trivia = await _fetchData(languageCode);
      _isLoaded = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// `getTrivia` is a method that retrieves a random trivia from the loaded data.
  /// It returns a string containing the trivia or an error message if the data hasn't been loaded.
  String getTrivia() {
    final index = _random.nextInt(10);
    return _isLoaded ? _trivia.trivia[index] : 'Error: Trivia not loaded.';
  }
}
