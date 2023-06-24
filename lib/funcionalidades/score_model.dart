import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreModel extends ChangeNotifier {
  int _score = 0;

  ScoreModel() {
    loadScore();
  }

  int get score => _score;

  void increment() {
    _score++;
    saveScore();
    notifyListeners();
  }

  void reset() {
    _score = 0;
    saveScore();
    notifyListeners();
  }

  void saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('score', _score);
  }

  void loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    _score = prefs.getInt('score') ?? 0;
    notifyListeners();
  }
}