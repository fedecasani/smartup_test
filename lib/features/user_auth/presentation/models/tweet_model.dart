import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  final String id;
  final String content;
  final String userId;
  final String userEmail; // Nuevo campo para almacenar el correo electrónico del usuario
  final Timestamp timestamp;

  Tweet({
    required this.id,
    required this.content,
    required this.userId,
    required this.userEmail,
    required this.timestamp,
  });

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'userId': userId,
      'userEmail': userEmail,
      'timestamp': timestamp,
    };
  }
}
