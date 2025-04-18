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
    final results = posts.where((post) =>
    post.title.toLowerCase().contains(query.toLowerCase())
        || post.subtitle.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final post = results[index];
        return ListTile(
          title: Text(post.title),
          subtitle: Text(post.subtitle),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => PostPage(post: post),
            ));
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context); // или можно сделать live-подсказки отдельно
  }
}
