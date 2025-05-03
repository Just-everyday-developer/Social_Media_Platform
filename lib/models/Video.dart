class Video {
  final int id;
  final String title;
  final String? description;
  final String videoUrl;
  final String? thumbnailUrl;
  final int duration;
  final DateTime uploadedAt;
  final List<String>? tags;
  final List<String> comments;
  final String author;
  int likes;
  int views;

  Video({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.duration,
    required this.uploadedAt,
    required this.comments,
    required this.author,
    this.description,
    this.thumbnailUrl,
    this.tags,
    this.views = 0,
    this.likes = 0,
  });

}