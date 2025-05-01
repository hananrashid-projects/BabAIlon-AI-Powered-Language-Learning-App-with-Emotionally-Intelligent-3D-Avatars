// class DashboardData {
//   String id;
//   String user_email;
//   double vocabulary_score;
//   double fluency_score;
//   double grammar_score;
//   double pronunciation_score;

//   DashboardData(
//     this.id,
//     this.user_email,
//     this.vocabulary_score,
//     this.fluency_score,
//     this.grammar_score,
//     this.pronunciation_score,
//   );
//   factory DashboardData.fromMap(Map<String, dynamic> json) {
//     return DashboardData(
//       json['id'],
//       json['user_email'],
//       json['vocabulary_score'],
//       json['fluency_score'],
//       json['grammar_score'],
//       json['pronunciation_score'],
//     );
//   }
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'user_email': user_email,
//       'vocabulary_score': vocabulary_score,
//       'fluency_score': fluency_score,
//       'grammar_score': grammar_score,
//       'pronunciation_score': pronunciation_score,
//     };
//   }
// }
class DashboardData {
  String id;
  String user_email;
  String language;
  List<Score> scores;

  DashboardData(
    this.id,
    this.user_email,
    this.language,
    this.scores,
  );

  factory DashboardData.fromMap(Map<String, dynamic> json) {
    var list = json['scores'] as List;
    List<Score> scoresList = list.map((i) => Score.fromMap(i)).toList();

    return DashboardData(
      json['id'],
      json['user_email'],
      json['language'],
      scoresList,
    );
  }

  Map<String, dynamic> toMap() {
    List<Map> scoresList = scores.map((i) => i.toMap()).toList();

    return {
      'id': id,
      'user_email': user_email,
      'language': language,
      'scores': scoresList,
    };
  }

  DashboardData copyWith({
    String? id,
    String? user_email,
    String? language,
    List<Score>? scores,
  }) {
    return DashboardData(
      id ?? this.id,
      user_email ?? this.user_email,
      language ?? this.language,
      scores ?? this.scores,
    );
  }
}

class Score {
  String date;
  double vocabulary_score;
  double fluency_score;
  double grammar_score;
  double pronunciation_score;

  Score(
    this.date,
    this.vocabulary_score,
    this.fluency_score,
    this.grammar_score,
    this.pronunciation_score,
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
      'vocabulary_score': vocabulary_score,
      'fluency_score': fluency_score,
      'grammar_score': grammar_score,
      'pronunciation_score': pronunciation_score,
    };
  }
}
