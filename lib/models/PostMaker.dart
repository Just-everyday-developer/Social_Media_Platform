import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'Post.dart';

class PostMaker extends StatefulWidget {
  const PostMaker({super.key});

  @override
  _PostMakerState createState() => _PostMakerState();
}

class _PostMakerState extends State<PostMaker> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _savePost(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final postsJson = prefs.getStringList('posts') ?? [];

      final newPost = Post(
        title: _titleController.text,
        subtitle: _contentController.text,
        imageUrl: _imageUrlController.text,
        createdAt: DateTime.now(),
      );

      postsJson.add(json.encode(newPost.toJson()));
      await prefs.setStringList('posts', postsJson);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully!')),
        );
        // Return true to indicate successful post creation
        Navigator.of(context).pop(true);
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
                    "Create a new post",
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
                      onPressed: () => _savePost(context),
                      child: Text(
                        "Save Post",
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