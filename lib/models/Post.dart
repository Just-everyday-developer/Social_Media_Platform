class Post {
  String title;
  String subtitle;
  String? imageUrl;
  String? authorName;
  String? authorAvatar;
  DateTime? createdAt;
  List<String>? tags;
  String? content;
  int? likes;
  int? commentCount;

  Post({
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.authorName,
    this.authorAvatar,
    this.createdAt,
    this.tags,
    this.content,
    this.likes,
    this.commentCount = 0,
  });


  Map<String, dynamic> toJson() => {
    'title': title,
    'subtitle': subtitle,
    'imageUrl': imageUrl,
    'authorName': authorName,
    'authorAvatar': authorAvatar,
    'createdAt': createdAt?.toIso8601String(),
    'tags': tags,
    'content': content,
    'likes': likes,
    'commentCount': commentCount,
  };

  factory Post.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;
    try {
      createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    } catch (e) {
      print("Error parsing date: $e");
      createdAt = null;
    }

    return Post(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      imageUrl: json['imageUrl'],
      authorName: json['authorName'],
      authorAvatar: json['authorAvatar'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      content: json['content'],
      likes: json['likes'],
      commentCount: json['commentCount'] ?? 0,
    );
  }
}
