
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_platform/models/Post.dart';

class FirebasePostService {
  final CollectionReference _postsCollection = FirebaseFirestore.instance.collection('posts');

  
  Stream<List<Post>> getPosts() {
    return _postsCollection.orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    });
  }

  
  Future<List<Post>> getPostsOnce() async {
    final querySnapshot = await _postsCollection.orderBy('createdAt', descending: true).get();
    return querySnapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
  }

  
  Future<void> addPost(Post post) {
    return _postsCollection.add(post.toFirestore());
  }

  
  Future<void> updatePost(String postId, Post post) {
    return _postsCollection.doc(postId).update(post.toFirestore());
  }

  
  Future<void> deletePost(String postId) async {
    final batch = FirebaseFirestore.instance.batch();

    
    final commentsSnapshot = await _postsCollection
        .doc(postId)
        .collection('comments')
        .get();

    for (final doc in commentsSnapshot.docs) {
      batch.delete(doc.reference);
    }

    
    batch.delete(_postsCollection.doc(postId));

    await batch.commit();
  }

  
  Future<Post?> getPostById(String postId) async {
    final docSnapshot = await _postsCollection.doc(postId).get();
    if (docSnapshot.exists) {
      return Post.fromFirestore(docSnapshot);
    }
    return null;
  }

  
  Stream<Post?> getPostByIdStream(String postId) {
    return _postsCollection.doc(postId).snapshots().map((docSnapshot) {
      if (docSnapshot.exists) {
        return Post.fromFirestore(docSnapshot);
      }
      return null;
    });
  }

  
  Future<void> likePost(String postId, int currentLikes) async {
    await _postsCollection.doc(postId).update({'likes': currentLikes + 1});
  }

  
  Future<void> unlikePost(String postId, int currentLikes) async {
    if (currentLikes > 0) {
      await _postsCollection.doc(postId).update({'likes': currentLikes - 1});
    }
  }

  

  
  Future<void> addComment(String postId, Map<String, dynamic> commentData) async {
    await _postsCollection
        .doc(postId)
        .collection('comments')
        .add(commentData);
  }

  
  Stream<List<DocumentSnapshot>> getCommentsStream(String postId) {
    return _postsCollection
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  
  Future<List<DocumentSnapshot>> getComments(String postId) async {
    final snapshot = await _postsCollection
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .get();
    return snapshot.docs;
  }

  
  Future<void> deleteComment(String postId, String commentId) async {
    await _postsCollection
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  
  Future<void> updateComment(String postId, String commentId, Map<String, dynamic> commentData) async {
    await _postsCollection
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update(commentData);
  }

  
  Future<int> getCommentCount(String postId) async {
    final snapshot = await _postsCollection
        .doc(postId)
        .collection('comments')
        .get();
    return snapshot.docs.length;
  }

  
  Future<List<Post>> searchByTitlePrefix(String prefix) async {
    if (prefix.isEmpty) return [];
    final end = prefix.substring(0, prefix.length - 1) +
        String.fromCharCode(prefix.codeUnitAt(prefix.length - 1) + 1);
    final snap = await _postsCollection
        .where('title', isGreaterThanOrEqualTo: prefix)
        .where('title', isLessThan: end)
        .orderBy('title')
        .get();
    return snap.docs.map((d) => Post.fromFirestore(d)).toList();
  }

  
  Future<List<Post>> searchByContent(String query) async {
    if (query.isEmpty) return [];

    
    
    final titleResults = await _postsCollection
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    final posts = titleResults.docs.map((d) => Post.fromFirestore(d)).toList();
    return posts;
  }

  
  Future<List<Post>> getPostsByAuthor(String authorId) async {
    final snapshot = await _postsCollection
        .where('authorId', isEqualTo: authorId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((d) => Post.fromFirestore(d)).toList();
  }

  
  Stream<List<Post>> getPostsByAuthorStream(String authorId) {
    return _postsCollection
        .where('authorId', isEqualTo: authorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    });
  }
}