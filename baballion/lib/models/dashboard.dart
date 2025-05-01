import 'package:floor/floor.dart';
import 'language.dart';

class Dashboard {
  String id;
  String userEmail;
  List<Language> languages;

  Dashboard(
    this.id,
    this.userEmail,
    this.languages,
  );

  factory Dashboard.fromMap(Map<String, dynamic> json) {
    return Dashboard(
      json['id'],
      json['user_email'],
      List<Language>.from(json['languages'].map((x) => Language.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_email': userEmail,
      'languages': languages.map((x) => x.toMap()).toList(),
    };
  }
}
