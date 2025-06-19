
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id;
  final String title;
  final String subtitle;
  final String content;
  DateTime? createdAt;
  int likes;
  List<String> comments; 
  int? commentCount;
  String? imageUrl;
  String? authorName;
  String? authorAvatar;

  Post({
    this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    this.createdAt,
    this.likes = 0,
    this.comments = const [],
    this.commentCount,
    this.imageUrl,
    this.authorName,
    this.authorAvatar,
  });


  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'likes': likes,
      'comments': comments,
      'commentCount': commentCount ?? comments.length,
      'imageUrl': imageUrl,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
    };
  }

  
  
  
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'createdAt': createdAt?.toIso8601String(), 
      'likes': likes,
      'comments': comments,
      'commentCount': commentCount ?? comments.length,
      'imageUrl': imageUrl,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
    };
  }


  
  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      content: data['content'] ?? '',
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : null, 
      likes: data['likes'] ?? 0,
      comments: (data['comments'] is List)
          ? List<String>.from(data['comments'])
          : [], 
      commentCount: data['commentCount'] ?? 0,
      imageUrl: data['imageUrl'],
      authorName: data['authorName'],
      authorAvatar: data['authorAvatar'],
    );
  }


}