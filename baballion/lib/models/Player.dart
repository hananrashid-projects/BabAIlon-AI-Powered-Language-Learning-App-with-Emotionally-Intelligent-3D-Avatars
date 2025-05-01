class Player {
  final String userId;
  final String fullName;
  final int score;

  Player({required this.userId, required this.fullName, required this.score});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      userId: json['userId'],
      fullName: json['fullName'],
      score: json['score'],
    );
  }
}
