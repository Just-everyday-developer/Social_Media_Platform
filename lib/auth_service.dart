import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Email: Entry
  Future<User?> signIn(String email, String password) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCred.user;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  // Email: Register
  Future<User?> register(String email, String password) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCred.user;
    } catch (e) {
      print("Register error: $e");
      return null;
    }
  }

  // Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print("Google Sign-In error: $e");
      return null;
    }
  }

  // GitHub Sign-In
  Future<UserCredential?> signInWithGitHub() async {
    try {
      const clientId = 'Ov23liFmPODNabDHnFIw';
      const clientSecret = '950ea61e9abf3e6df327e97e8104cbef5b0c857e';
      const redirectUrl = 'https://social-media-platform-34794.firebaseapp.com/__/auth/handler';

      final url = 'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUrl&scope=read:user%20user:email';

      final result = await FlutterWebAuth2.authenticate(
          url: url, callbackUrlScheme: "https");
      final code = Uri
          .parse(result)
          .queryParameters['code'];

      final response = await http.post(
        Uri.parse("https://github.com/login/oauth/access_token"),
        headers: {"Accept": "application/json"},
        body: {
          "client_id": clientId,
          "client_secret": clientSecret,
          "code": code!,
        },
      );

      final accessToken = json.decode(response.body)["access_token"];
      final githubAuthCredential = GithubAuthProvider.credential(accessToken);
      return await _auth.signInWithCredential(githubAuthCredential);
    } catch (e) {
      print("GitHub Sign-In error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  User? get currentUser => _auth.currentUser;
}
