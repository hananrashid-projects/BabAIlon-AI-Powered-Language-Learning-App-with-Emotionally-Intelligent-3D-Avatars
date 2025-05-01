import 'package:floor/floor.dart';

@Entity(tableName: 'allConversations')
class AllConversations {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String userID;
  final String conversation;

  AllConversations({
    this.id,
    required this.userID,
    required this.conversation,
  });

  factory AllConversations.fromJson(Map<String, dynamic> json) {
    return AllConversations(
      id: json['id'],
      userID: json['userID'],
      conversation: json['conversation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'conversation': conversation,
    };
  }

  @override
  String toString() {
    return 'AllConversations(id: $id, userID: $userID, conversation: "$conversation")';
  }
}
