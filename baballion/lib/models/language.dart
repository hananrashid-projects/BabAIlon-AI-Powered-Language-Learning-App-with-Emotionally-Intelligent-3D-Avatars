import 'dart:convert';
import 'package:babellion/models/feedback_history.dart';
import 'package:babellion/models/score.dart';

class Language {
  String language;
  List<Score> scores;
  List<FeedbackHistory>? feedbackHistory; // List of feedback strings

  Language(
    this.language,
    this.scores,
    this.feedbackHistory,
  );

  factory Language.fromMap(Map<String, dynamic> json) {
    return Language(
      json['language'],
      List<Score>.from(json['scores'].map((x) => Score.fromMap(x))),
      json['feedbackHistory'] != null
          ? List<FeedbackHistory>.from(
              json['feedbackHistory'].map((x) => FeedbackHistory.fromMap(x)))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'language': language,
      'scores': scores.map((x) => x.toMap()).toList(),
      'feedbackHistory': feedbackHistory?.map((x) => x.toMap()).toList(),
    };
  }
}
