import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garda_green/trivia/models/models.dart';

class TriviaRepository {
  final Random _random = Random();

  late Trivia _trivia;
  bool _isLoaded = false;

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

  String getTrivia() {
    final index = _random.nextInt(10);
    return _isLoaded ? _trivia.trivia[index] : 'Error: Trivia not loaded.';
  }
}
