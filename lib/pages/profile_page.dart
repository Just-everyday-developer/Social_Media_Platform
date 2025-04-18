import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => context.go("/home"),
      ),
    ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/avatar.jpg')
            ),
            const SizedBox(height: 16),
            const Text(
              'Талгат',
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
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.deepPurple),
              title: const Text('Settings'),
              onTap: () {
                context.go('/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.pink),
              title: const Text('Favorite'),
              onTap: () {
                context.go('/favorites');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Exit'),
              onTap: () {
                context.go("/login");
              },
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
