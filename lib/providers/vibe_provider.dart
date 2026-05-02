import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/vibe.dart';

class VibeProvider extends ChangeNotifier {
  List<Vibe> _vibes = [];
  int _streak = 0;
  DateTime? _lastPosted;

  List<Vibe> get vibes => _vibes;
  int get streak => _streak;

  VibeProvider() {
    loadData(); // 🔥 load saved data on start
  }

  void addVibe(String text) {
    final now = DateTime.now();

    // 🔥 STREAK LOGIC
    if (_lastPosted != null) {
      final difference = now.difference(_lastPosted!).inDays;

      if (difference == 1) {
        _streak++;
      } else if (difference > 1) {
        _streak = 1;
      }
    } else {
      _streak = 1;
    }

    _lastPosted = now;

    _vibes.insert(0, Vibe(text: text, time: now));

    saveData(); // 🔥 save after every post
    notifyListeners();
  }

  // 🔥 SAVE DATA
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> vibesJson = _vibes
        .map(
          (v) => jsonEncode({'text': v.text, 'time': v.time.toIso8601String()}),
        )
        .toList();

    await prefs.setStringList('vibes', vibesJson);
    await prefs.setInt('streak', _streak);

    if (_lastPosted != null) {
      await prefs.setString('lastPosted', _lastPosted!.toIso8601String());
    }
  }

  // 🔥 LOAD DATA
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final vibesJson = prefs.getStringList('vibes') ?? [];

    _vibes = vibesJson.map((v) {
      final data = jsonDecode(v);
      return Vibe(text: data['text'], time: DateTime.parse(data['time']));
    }).toList();

    _streak = prefs.getInt('streak') ?? 0;

    final last = prefs.getString('lastPosted');
    if (last != null) {
      _lastPosted = DateTime.parse(last);
    }

    notifyListeners();
  }
}
