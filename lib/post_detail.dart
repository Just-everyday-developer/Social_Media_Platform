
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/post.dart';
import 'edit_post.dart';
import 'package:social_media_platform/services/firebase_post_service.dart';


class Comment {
  final String id;
  final String content;
  final String authorName;
  final String? authorAvatar;
  final String authorId;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.content,
    required this.authorName,
    this.authorAvatar,
    required this.authorId,
    required this.createdAt,
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
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'authorId': authorId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class PostDetailPage extends StatefulWidget {
  final String postId;

  const PostDetailPage({Key? key, required this.postId}) : super(key: key);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final FirebasePostService _postService = FirebasePostService();
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  User? currentUser = FirebaseAuth.instance.currentUser;
  bool _isSubmittingComment = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  
  Stream<Post?> _getSinglePostStream() {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .snapshots()
        .map((docSnapshot) {
      if (docSnapshot.exists) {
        return Post.fromFirestore(docSnapshot);
      }
      return null;
    });
  }

  
  Stream<List<Comment>> _getCommentsStream() {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList();
    });
  }

  
  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty || currentUser == null) return;

    setState(() {
      _isSubmittingComment = true;
    });

    try {
      final comment = Comment(
        id: '',
        content: _commentController.text.trim(),
        authorName: currentUser!.displayName ?? 'Anonymous',
        authorAvatar: currentUser!.photoURL,
        authorId: currentUser!.uid,
        createdAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .add(comment.toFirestore());

      _commentController.clear();

      
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add comment: $e')),
      );
    } finally {
      setState(() {
        _isSubmittingComment = false;
      });
    }
  }

  
  Future<void> _deleteComment(String commentId, String commentAuthorId) async {
    if (currentUser == null || currentUser!.uid != commentAuthorId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only delete your own comments')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .doc(commentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete comment: $e')),
      );
    }
  }

  Future<void> _likePost(Post post) async {
    try {
      await _postService.likePost(post.id!, post.likes);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to like post: $e')),
      );
    }
  }

  Future<void> _deletePost(String postId) async {
    try {
      await _postService.deletePost(postId);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post: $e')),
      );
    }
  }

  Future<void> _editPost(Post post) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPostPage(post: post),
      ),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    final isOwner = currentUser?.uid == comment.authorId;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: comment.authorAvatar != null
                    ? NetworkImage(comment.authorAvatar!)
                    : const AssetImage('assets/default_avatar.png') as ImageProvider,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.authorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, HH:mm').format(comment.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isOwner)
                IconButton(
                  icon: const Icon(Icons.delete, size: 18),
                  color: Colors.red[400],
                  onPressed: () => _showDeleteCommentDialog(comment),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.content,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showDeleteCommentDialog(Comment comment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteComment(comment.id, comment.authorId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    if (currentUser == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border(top: BorderSide(color: Colors.grey[300]!)),
        ),
        child: const Text(
          'Please log in to leave a comment',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: currentUser!.photoURL != null
                ? NetworkImage(currentUser!.photoURL!)
                : const AssetImage('assets/default_avatar.png') as ImageProvider,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _addComment(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _isSubmittingComment ? null : _addComment,
            icon: _isSubmittingComment
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Detail'),
        actions: [
          StreamBuilder<Post?>(
            stream: _getSinglePostStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData) {
                final post = snapshot.data!;
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editPost(post),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deletePost(post.id!),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  
                  StreamBuilder<Post?>(
                    stream: _getSinglePostStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text('Post not found.'));
                      } else {
                        final post = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                post.subtitle,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (post.authorName != null && post.authorName!.isNotEmpty)
                                Text(
                                  'By ${post.authorName}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                'Created on ${post.createdAt != null ? DateFormat('MMM dd, yyyy - HH:mm').format(post.createdAt!) : "Unknown date"}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Image.network(
                                    post.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 100),
                                  ),
                                ),
                              Text(
                                post.content!,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.favorite, color: Colors.red[300]),
                                    onPressed: () => _likePost(post),
                                  ),
                                  Text('${post.likes} likes'),
                                  const SizedBox(width: 16),
                                  Icon(Icons.comment, color: Colors.blue[300]),
                                  const SizedBox(width: 4),
                                  StreamBuilder<List<Comment>>(
                                    stream: _getCommentsStream(),
                                    builder: (context, snapshot) {
                                      final commentCount = snapshot.hasData ? snapshot.data!.length : 0;
                                      return Text('$commentCount comments');
                                    },
                                  ),
                                ],
                              ),
                              const Divider(height: 32),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comments',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        StreamBuilder<List<Comment>>(
                          stream: _getCommentsStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error loading comments: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: Text(
                                    'No comments yet. Be the first to comment!',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              final comments = snapshot.data!;
                              return Column(
                                children: comments.map((comment) => _buildCommentItem(comment)).toList(),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 80), 
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          _buildCommentInput(),
        ],
      ),
    );
  }
}