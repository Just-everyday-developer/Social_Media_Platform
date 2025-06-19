import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_platform/models/Post.dart';
import 'package:social_media_platform/services/firebase_post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostMaker extends StatefulWidget {
  final Post? initialPost;
  final String? postId; 

  const PostMaker({super.key, this.initialPost, this.postId});

  @override
  _PostMakerState createState() => _PostMakerState();
}

class _PostMakerState extends State<PostMaker> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final FirebasePostService _postService = FirebasePostService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    if (widget.initialPost != null) {
      _titleController.text = widget.initialPost!.title;
      _subtitleController.text = widget.initialPost!.subtitle;
      _contentController.text = widget.initialPost!.content;
      _imageUrlController.text = widget.initialPost!.imageUrl ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _subtitleController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }


  Future<void> _savePost(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final User? currentUser = FirebaseAuth.instance.currentUser;
        final String authorName = currentUser?.displayName ?? 'Anonymous';
        final String authorAvatar = currentUser?.photoURL ?? '';

        final Post newPost = Post(
          id: widget.initialPost?.id,
          title: _titleController.text.trim(),
          subtitle: _subtitleController.text.trim(),
          content: _contentController.text.trim(),
          createdAt: widget.initialPost?.createdAt ?? DateTime.now(),
          likes: widget.initialPost?.likes ?? 0,
          comments: widget.initialPost?.comments ?? [],
          commentCount: widget.initialPost?.commentCount ?? 0,
          imageUrl: _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim(),
          authorName: authorName,
          authorAvatar: authorAvatar,
        );

        if (widget.initialPost == null) {
          
          
          await _postService.addPost(newPost); 
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post created successfully!')),
          );
        } else {
          
          if (widget.postId != null) {
            
            await _postService.updatePost(widget.postId!, newPost); 
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post updated successfully!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error: Cannot update post without ID.')),
            );
          }
        }
        context.pop(true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save post: $e')),
        );
        print('Save Post Error: $e'); 
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    widget.initialPost != null ? "Edit Post" : "Create a new post", 
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Title",
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _subtitleController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Subtitle",
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a subtitle';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Content",
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some content';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Image URL (optional)",
                    labelStyle: GoogleFonts.roboto(fontSize: 15),
                    hintText: "Leave empty for default image",
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.roboto(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => _savePost(context),
                      child: _isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : Text(
                        widget.initialPost != null ? "Update Post" : "Save Post", 
                        style: GoogleFonts.roboto(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}