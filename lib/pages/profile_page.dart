import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_platform/pages/home_screen.dart';
import 'package:social_media_platform/pages/main_screen.dart';
import 'package:social_media_platform/models/Post.dart';
import 'dart:convert';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context)
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/avatar.jpg'),
            ),
            const SizedBox(height: 16),
            Text(
              currentUser?.email ?? "Anonymous",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              '@tal_dev',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('Posts', '24'),
                _buildStatItem('Followers', '134'),
                _buildStatItem('Followees', '87'),
              ],
            ),
            const SizedBox(height: 30),
            const Divider(),
            AnimatedListTile(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () => context.go('/settings'),
              color: Colors.deepPurple,
            ),
            AnimatedListTile(
              icon: Icons.favorite,
              title: 'Favorite',
              onTap: () => context.go('/favorites'),
              color: Colors.pink,
            ),
            AnimatedListTile(
              icon: Icons.logout,
              title: 'Exit',
              onTap: () => context.go("/login"),
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class AnimatedListTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  const AnimatedListTile({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.color,
    super.key,
  });

  @override
  _AnimatedListTileState createState() => _AnimatedListTileState();
}

class _AnimatedListTileState extends State<AnimatedListTile> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isTapped = true),
      onTapUp: (_) {
        setState(() => _isTapped = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isTapped = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _isTapped ? widget.color.withOpacity(0.2) : Colors.transparent,
        child: ListTile(
          leading: Icon(widget.icon, color: widget.color),
          title: Text(widget.title),
        ),
      ),
    );
  }
}