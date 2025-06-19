
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:social_media_platform/post_detail.dart';
import 'package:social_media_platform/create_post.dart';
import 'package:social_media_platform/models/post.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  
  

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts')
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No posts found. Start by creating one!'));
          } else {
            final posts = snapshot.data!.docs.map((doc) {
              return Post.fromFirestore(doc); 
            }).toList();

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                String displayText = post.content!.length > 100
                    ? '${post.content!.substring(0, 100)}...'
                    : post.content!;
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailPage(postId: post.id!),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            displayText,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                post.createdAt != null
                                    ? 'Created on ${DateFormat('MMM dd, yyyy').format(post.createdAt!)}'
                                    : 'Created recently',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.favorite, color: Colors.red[300], size: 16),
                                  const SizedBox(width: 4),
                                  Text('${post.likes}'),
                                  const SizedBox(width: 16),
                                  Icon(Icons.comment, color: Colors.blue[300], size: 16),
                                  const SizedBox(width: 4),
                                  Text('${post.comments is List ? (post.comments as List).length : post.comments}'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}