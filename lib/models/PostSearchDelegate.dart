import 'package:flutter/material.dart';
import 'package:social_media_platform/pages/main_screen.dart';
import 'Post.dart';
import 'package:social_media_platform/pages/post_page.dart';

class PostSearchDelegate extends SearchDelegate {
  final List<Post> posts;

  PostSearchDelegate(this.posts);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = posts.where((post) {
      final q = query.toLowerCase();
      return post.title.toLowerCase().contains(q) ||
          post.subtitle.toLowerCase().contains(q);
    }).toList();

    return results.isEmpty
        ? Center(child: Text('No posts found'))
        : ListView.builder(
      itemCount: results.length,
      itemBuilder: (c, i) {
        final post = results[i];
        return ListTile(
          title: Text(post.title),
          subtitle: Text(post.subtitle),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostPage(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context); 
  }
}
