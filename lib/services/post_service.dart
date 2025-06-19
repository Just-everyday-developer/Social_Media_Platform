import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_platform/models/post.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'posts';

  
  Future<String> createPost(String title, String content) async {
    final docRef = await _firestore.collection(_collection).add({
      'title': title,
      'content': content,
      'createdAt': Timestamp.now(),
      'likes': 0,
      'comments': 0,
    });

    return docRef.id;
  }

  
  Stream<List<Post>> getPostsStream() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Post(
          id: doc.id,
          title: data['title'] ?? '',
          subtitle: data['subtitle'] ?? '',
          content: data['content'] ?? '',
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          likes: data['likes'] ?? 0,
          comments: data['comments'] ?? 0,
        );
      }).toList();
    });
  }

  
  Future<Post?> getPostById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();

    if (!doc.exists) {
      return null;
    }

    final data = doc.data()!;
    return Post(
      id: doc.id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
    );
  }

  
  Future<void> updatePost(String id, String title, String content) async {
    await _firestore.collection(_collection).doc(id).update({
      'title': title,
      'content': content,
    });
  }

  
  Future<void> deletePost(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  
  Future<void> likePost(String id) async {
    await _firestore.collection(_collection).doc(id).update({
      'likes': FieldValue.increment(1),
    });
  }

  
  Future<void> addComment(String id) async {
    await _firestore.collection(_collection).doc(id).update({
      'comments': FieldValue.increment(1),
    });
  }
}