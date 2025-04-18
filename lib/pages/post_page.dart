import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_platform/models/Post.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool isFavorite = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    likeCount = widget.post.likes ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : null),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isFavorite ? 'Added to favorites' : 'Removed from favorites'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality would go here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share feature not implemented yet'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            Container(
              height: 250,
              width: double.infinity,
              child: widget.post.imageUrl != null && widget.post.imageUrl!.isNotEmpty
                  ? Image.network(
                widget.post.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/bg1.jpeg',
                    fit: BoxFit.cover,
                  );
                },
              )
                  : Image.asset(
                'assets/bg1.jpeg',
                fit: BoxFit.cover,
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.post.title,
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Author and date
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: widget.post.authorAvatar != null
                            ? NetworkImage(widget.post.authorAvatar!)
                            : const AssetImage('assets/blank-profile-photo.png') as ImageProvider,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.post.authorName ?? 'Anonymous',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      if (widget.post.createdAt != null)
                        Text(
                          DateFormat('dd MMM yyyy, HH:mm').format(widget.post.createdAt!),
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Tags
                  if (widget.post.tags != null && widget.post.tags!.isNotEmpty)
                    Container(
                      height: 30,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.post.tags!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Chip(
                              label: Text(
                                widget.post.tags![index],
                                style: GoogleFonts.roboto(fontSize: 12),
                              ),
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Content
                  Text(
                    widget.post.subtitle,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  if (widget.post.content != null && widget.post.content!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      widget.post.content!,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Likes and comments
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            likeCount++;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.thumb_up, color: Colors.blue),
                            const SizedBox(width: 4),
                            Text(
                              '$likeCount',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Row(
                        children: [
                          Icon(Icons.comment, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.post.commentCount ?? 0}',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Comment feature not implemented yet'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}