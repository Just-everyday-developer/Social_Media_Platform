import 'package:flutter/material.dart';
import 'package:social_media_platform/pages/actions_page.dart';
import 'package:social_media_platform/pages/favorites_page.dart';
import 'package:social_media_platform/pages/home_screen.dart';
import 'package:social_media_platform/pages/news_page.dart';
import 'package:social_media_platform/pages/notifications_page.dart';
import 'package:social_media_platform/pages/profile_page.dart';
import 'package:social_media_platform/pages/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:social_media_platform/settings/font_slider.dart';
import 'package:social_media_platform/models/PostSearchDelegate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_platform/models/Post.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:social_media_platform/pages/short_videos_page.dart';
import 'MapPage.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Post> allPosts = [];
  List<Post> posts = [];
  DateTime? startDateTime;
  DateTime? endDateTime;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = prefs.getStringList('posts') ?? [];
    final loadedPosts = postsJson.map((e) => Post.fromJson(json.decode(e))).toList();

    setState(() {
      allPosts = loadedPosts;
      posts = loadedPosts;
    });
  }

  void applyDateFilter(DateTime start, DateTime end) {
    final filtered = allPosts.where((post) {
      final date = post.createdAt;
      return date != null &&
          (date.isAfter(start) || date.isAtSameMomentAs(start)) &&
          (date.isBefore(end) || date.isAtSameMomentAs(end));
    }).toList();

    setState(() {
      posts = filtered;
    });
  }

  static const tabs = [
    '/home',
    '/notifications',
    '/favorites',
    '/settings',
    '/actions',
    '/profile',
    '/news',
    '/map'
  ];

  static final appBarTitles = {
    '/home': "My Social Media Platform",
    '/notifications': "Notifications",
    '/favorites': "Favorite Posts",
    '/settings': "Settings",
    '/actions': "Actions",
    '/news': 'News',
    '/Map': 'Map'
  };

  int _getCurrentIndex(String location) {
    if (location.startsWith('/notifications')) return 1;
    if (location.startsWith('/favorites')) return 2;
    if (location.startsWith('/settings')) return 3;
    if (location.startsWith('/actions')) return 4;
    if (location.startsWith('/profile')) return 5;
    if (location.startsWith('/news')) return 6;
    return 0;
  }

  Widget _getScreen(String location) {
    switch (location) {
      case '/notifications':
        return const NotificationsPage();
      case '/favorites':
        return const FavoritePage();
      case '/settings':
        return const SettingsPage();
      case '/actions':
        return const ActionsPage();
      case '/news':
        return const NewsPage();
      case '/map':
        return const MapPage();
      case '/videos':
        return ShortVideosPage();
      default:
        return HomeScreen(
          posts: posts,
          onPostChanged: loadPosts,
        );
    }
  }
  PreferredSizeWidget? dynamicalAppBar(BuildContext context, String location) {
    return AppBar(
      title: Text(appBarTitles[location] ?? "My Social Media Platform"),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            if (location == "/map") {
              final TextEditingController searchController = TextEditingController();

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Search Location'),
                  content: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(hintText: 'Enter address to search'),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        Provider.of<MapState>(context, listen: false).searchByAddress(value);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        final value = searchController.text;
                        if (value.isNotEmpty) {
                          Provider.of<MapState>(context, listen: false).searchByAddress(value);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Search'),
                    ),
                  ],
                ),
              );
            } else {
              final prefs = await SharedPreferences.getInstance();
              final postsJson = prefs.getStringList('posts') ?? [];
              final posts = postsJson.map((e) => Post.fromJson(json.decode(e))).toList();

              if (!context.mounted) return;

              showSearch(
                context: context,
                delegate: PostSearchDelegate(posts),
              );
            }
          },
        ),
        IconButton(
          onPressed: () => context.go('/settings'),
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final currentIndex = _getCurrentIndex(currentLocation);

    return Scaffold(
      appBar: dynamicalAppBar(context, currentLocation),
      body: _getScreen(currentLocation),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: currentIndex,
        onTap: (index) => context.go(tabs[index]),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home", backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications", backgroundColor: Colors.indigo),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites", backgroundColor: Colors.pinkAccent),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings", backgroundColor: Colors.teal),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: "Actions", backgroundColor: Colors.amber),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'News', backgroundColor: Colors.brown)
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundImage: AssetImage('assets/blank-profile-photo.png'),
                      ),
                      Positioned(
                        left: 30,
                        top: 30,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add_a_photo_outlined, size: 20, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Username",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Provider.of<FontSlider>(context).sliderFontValue * 1.4,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "+7-(777)-777-77-77",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: Provider.of<FontSlider>(context).sliderFontValue * 1.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Home', style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
              onTap: () => context.go('/home'),
            ),
            ListTile(
              title: Text('Notifications', style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
              onTap: () => context.go('/notifications'),
            ),
            ListTile(
              title: Text("Favorites Posts", style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
              onTap: () => context.go('/favorites'),
            ),
            ListTile(
              title: Text('Settings', style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
              onTap: () => context.go('/settings'),
            ),
            ListTile(
              title: Text('Messages', style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
              onTap: () => context.go('/'),
            ),
            ListTile(
              title: Text('Videos', style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
              onTap: () => context.go('/videos'),
            ),
            ListTile(
              title: Text('News', style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
              onTap: () => context.go('/news'),
            ),
            ListTile(
              title: Text('Map', style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
              onTap: () => context.go('/map')
            ),
            ListTile(
              title: Text('Login / Sign up', style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
              onTap: () => context.go('/login'),
            ),
          ],
        ),
      ),
    );
  }
}