import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_media_platform/models/Post.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_platform/settings/font_slider.dart';
import 'post_page.dart';
import 'package:social_media_platform/models/PostMaker.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final List<Post>? posts;
  final VoidCallback? onPostChanged;
  const HomeScreen({super.key, this.posts, this.onPostChanged});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Post> posts;

  @override
  void initState() {
    super.initState();
    posts = widget.posts!;
  }

  void _deletePost(int index) async {
    setState(() {
      posts.removeAt(index);
    });

    final prefs = await SharedPreferences.getInstance();
    final postsJson = posts.map((post) => json.encode(post.toJson())).toList();
    await prefs.setStringList('posts', postsJson);
    widget.onPostChanged!();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 30),
          Expanded(
            child: posts.isEmpty
                ? Center(
              child: Text(
                "No posts yet. Create one!",
                style: GoogleFonts.roboto(fontSize: 18),
              ),
            )
                : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: posts.length,
                // Updated HomeScreen ListView implementation with post card and navigation
                itemBuilder: (context, index) => Dismissible(
                  key: Key(posts[index].title + index.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _deletePost(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Post deleted'),
                        duration: Duration(milliseconds: 1000),
                      ),
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      context.push('/post/$index', extra: posts[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          height: 180,
                          child: Row(
                            children: [
                              // Left side - Image
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: SizedBox(
                                  width: 120,
                                  height: 180,
                                  child: posts[index].imageUrl != null && posts[index].imageUrl!.isNotEmpty
                                      ? Image.network(
                                    posts[index].imageUrl!,
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
                              ),
                              // Right side - Content
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        posts[index].title,
                                        style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        posts[index].subtitle,
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (posts[index].createdAt != null)
                                            Text(
                                              DateFormat('dd MMM yyyy').format(posts[index].createdAt!),
                                              style: GoogleFonts.roboto(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          Row(
                                            children: [
                                              Icon(Icons.favorite, size: 16, color: Colors.red),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${posts[index].likes ?? 0}",
                                                style: GoogleFonts.roboto(fontSize: 12),
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(Icons.comment, size: 16, color: Colors.blue),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${posts[index].commentCount ?? 0}",
                                                style: GoogleFonts.roboto(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
              ),
            ),
                  )
                )
            )
          )
        ]
      ),

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) => const PostMaker(),
                );

                if (result == true && widget.onPostChanged != null) {
                  // Reload posts from SharedPreferences
                  final prefs = await SharedPreferences.getInstance();
                  final postsJson = prefs.getStringList('posts') ?? [];
                  final updatedPosts = postsJson
                      .map((e) => Post.fromJson(json.decode(e)))
                      .toList();
                  widget.onPostChanged!();
                  setState(() {
                    posts = updatedPosts;
                  });

                  // Call the callback to update parent state
                  widget.onPostChanged!();
                }
              }
          ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}