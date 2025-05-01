import 'package:babellion/models/dashboard_data.dart';
import 'package:floor/floor.dart';

class FeedbackHistory {
  String language;
  String feedback;
  String date;

  FeedbackHistory(
    this.language,
    this.feedback,
    this.date,
  );

  factory FeedbackHistory.fromMap(Map<String, dynamic> json) {
    return FeedbackHistory(
        json['language'], json['feedback'], json['date']);
  }

  Map<String, dynamic> toMap() {
    return {
      'language': language,
      'feedback': feedback,
      'date': date,
    };
  }
}
