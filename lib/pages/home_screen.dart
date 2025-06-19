
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_media_platform/models/Post.dart';
import 'package:social_media_platform/services/firebase_post_service.dart'; 
import 'package:social_media_platform/settings/font_slider.dart';
import 'package:social_media_platform/models/PostMaker.dart'; 
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/PostMaker.dart'; 

class HomeScreen extends StatefulWidget {
  final List<Post>? posts;
  final VoidCallback? onPostChanged;
  const HomeScreen({super.key, this.posts, this.onPostChanged});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebasePostService _postService = FirebasePostService();

  @override
  Widget build(BuildContext context) {
    final fontSlider = Provider.of<FontSlider>(context);
    final currentFontSize = fontSlider.sliderFontValue;

    return Scaffold(
      body: StreamBuilder<List<Post>>(
        stream: _postService.getPosts(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            
            print('StreamBuilder Error: ${snapshot.error}');
            return Center(child: Text('Error loading posts: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts found. Create one!'));
          } else {
            final posts = snapshot.data!;
            return AnimationLimiter(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  
                  String displayText = post.content!.length > 100
                      ? '${post.content!.substring(0, 100)}...'
                      : post.content!;
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {
                            context.push('/post/${post.id}'); 
                          },
                          child: Dismissible(
                            background: Container(color: Colors.red),
                            key: ValueKey(posts[index]),
                            onDismissed: (DismissDirection direction) async {
                              final postId = posts[index].id;

                              await FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(postId)
                                  .delete();
                            },
                            child: Card(
                            margin: const EdgeInsets.all(8.0),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: post.authorAvatar != null && post.authorAvatar!.isNotEmpty
                                            ? NetworkImage(post.authorAvatar!)
                                            : const AssetImage('assets/default_avatar.png') as ImageProvider, 
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        post.authorName ?? 'Anonymous',
                                        style: GoogleFonts.roboto(
                                          fontSize: currentFontSize + 2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    post.title,
                                    style: GoogleFonts.roboto(
                                      fontSize: currentFontSize + 6,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    post.subtitle,
                                    style: GoogleFonts.roboto(
                                      fontSize: currentFontSize,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    displayText,
                                    style: GoogleFonts.roboto(
                                      fontSize: currentFontSize - 2,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        post.createdAt != null
                                            ? DateFormat('MMM dd, yyyy - HH:mm').format(post.createdAt!)
                                            : 'Unknown date',
                                        style: GoogleFonts.roboto(
                                          fontSize: currentFontSize - 4,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.favorite, color: Colors.red[300], size: currentFontSize),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${post.likes}',
                                            style: GoogleFonts.roboto(fontSize: currentFontSize - 2),
                                          ),
                                          const SizedBox(width: 16),
                                          Icon(Icons.comment, color: Colors.blue[300], size: currentFontSize),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${post.comments.length}',
                                            style: GoogleFonts.roboto(fontSize: currentFontSize - 2),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 20),
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await showDialog<bool>(
              context: context,
              builder: (context) => const PostMaker(),
            );
            
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}