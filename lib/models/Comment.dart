
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String content;
  final String authorName;
  final String? authorAvatar;
  final String authorId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Comment({
    required this.id,
    required this.content,
    required this.authorName,
    this.authorAvatar,
    required this.authorId,
    required this.createdAt,
    this.updatedAt,
  });

  
  factory Comment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      content: data['content'] ?? '',
      authorName: data['authorName'] ?? 'Anonymous',
      authorAvatar: data['authorAvatar'],
      authorId: data['authorId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  
  factory Comment.fromMap(Map<String, dynamic> data, String id) {
    return Comment(
      id: id,
      content: data['content'] ?? '',
      authorName: data['authorName'] ?? 'Anonymous',
      authorAvatar: data['authorAvatar'],
      authorId: data['authorId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  
  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'authorId': authorId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'authorId': authorId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  
  Comment copyWith({
    String? id,
    String? content,
    String? authorName,
    String? authorAvatar,
    String? authorId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Comment(
      id: id ?? this.id,
      content: content ?? this.content,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, content: $content, authorName: $authorName, authorId: $authorId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Comment &&
        other.id == id &&
        other.content == content &&
        other.authorName == authorName &&
        other.authorAvatar == authorAvatar &&
        other.authorId == authorId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    content.hashCode ^
    authorName.hashCode ^
    (authorAvatar?.hashCode ?? 0) ^
    authorId.hashCode ^
    createdAt.hashCode ^
    (updatedAt?.hashCode ?? 0);
  }
}