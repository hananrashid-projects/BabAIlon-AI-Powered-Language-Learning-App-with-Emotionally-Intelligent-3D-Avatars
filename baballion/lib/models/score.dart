import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Score {
  String date;
  int vocabularyScore;
  int fluencyScore;
  int grammarScore;
  int pronunciationScore;

  Score(
    this.date,
    this.vocabularyScore,
    this.fluencyScore,
    this.grammarScore,
    this.pronunciationScore,
  );

  factory Score.fromMap(Map<String, dynamic> json) {
    return Score(
      json['date'],
      json['vocabulary_score'],
      json['fluency_score'],
      json['grammar_score'],
      json['pronunciation_score'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'vocabulary_score': vocabularyScore,
      'fluency_score': fluencyScore,
      'grammar_score': grammarScore,
      'pronunciation_score': pronunciationScore,
    };
  }

  factory Score.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Score(
      data['date'] ?? "", // Default empty string if null
      data['vocabularyScore'] ?? 0, // Default to 0 if null
      data['fluencyScore'] ?? 0,
      data['grammarScore'] ?? 0,
      data['pronunciationScore'] ?? 0,
    );
  }
  @override
  String toString() {
    return 'Score(date: $date, vocabulary: $vocabularyScore, fluency: $fluencyScore, grammar: $grammarScore, pronunciation: $pronunciationScore)';
  }
}
