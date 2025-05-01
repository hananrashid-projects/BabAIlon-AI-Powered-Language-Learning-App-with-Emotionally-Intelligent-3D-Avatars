import 'dart:convert';
import 'package:babellion/models/Player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

class ScoreboardProvider extends StateNotifier<List<Player>> {
  ScoreboardProvider() : super([]) {
    loadPlayers();
  }

  List<Player> get topThree => state.take(3).toList();
  List<Player> get restList => state.skip(3).toList();

  Future<void> loadPlayers() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/data/players_score.json');
      List<dynamic> jsonData = json.decode(jsonString);
      List<Player> players = jsonData.map((e) => Player.fromJson(e)).toList();
      players.sort((a, b) => b.score.compareTo(a.score));

      state = players; // Update state
    } catch (e) {
      print('Error loading players: $e');
    }
  }
}

final scoreboardProvider =
    StateNotifierProvider<ScoreboardProvider, List<Player>>(
  (ref) => ScoreboardProvider(),
);
