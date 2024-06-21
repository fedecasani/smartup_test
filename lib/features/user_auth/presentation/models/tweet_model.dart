import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  final String id;
  final String content;
  final String userId;
  final String userEmail;
  final String userProfileImageUrl;
  final Timestamp timestamp;

  Tweet({
    required this.id,
    required this.content,
    required this.userId,
    required this.userEmail,
    required this.userProfileImageUrl,
    required this.timestamp,
  });

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? '',
      userProfileImageUrl: map['userProfileImageUrl'] ?? 'https://via.placeholder.com/150',
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'userId': userId,
      'userEmail': userEmail,
      'userProfileImageUrl': userProfileImageUrl,
      'timestamp': timestamp,
    };
  }
}
