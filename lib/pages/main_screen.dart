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
    '/news'
  ];

  static final appBarTitles = {
    '/home': "My Social Media Platform",
    '/notifications': "Notifications",
    '/favorites': "Favorite Posts",
    '/settings': "Settings",
    '/actions': "Actions",
    '/news': 'News'
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
      case '/profile':
        return const ProfilePage();
      case '/news':
        return const NewsPage();
      default:
        return HomeScreen(
          posts: posts,
          onPostChanged: loadPosts,
        );
    }
  }

  PreferredSizeWidget? dynamicalAppBar(String location) {
    return AppBar(
      title: Text(appBarTitles[location] ?? "My Social Media Platform"),
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, setStateDialog) {
                    return AlertDialog(
                      backgroundColor: Colors.black.withOpacity(0.9),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Text("Choose the diapason of date and time", style: TextStyle(color: Colors.white)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate == null) return;

                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime == null) return;

                              setStateDialog(() {
                                startDateTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                            },
                            icon: const Icon(Icons.calendar_today),
                            label: Text(startDateTime == null
                                ? "Choose the start"
                                : "Start: ${DateFormat('dd.MM.yyyy HH:mm').format(startDateTime!)}"),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: startDateTime ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate == null) return;

                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime == null) return;

                              setStateDialog(() {
                                endDateTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                              });
                            },
                            icon: const Icon(Icons.access_time),
                            label: Text(endDateTime == null
                                ? "Choose the end"
                                : "End: ${DateFormat('dd.MM.yyyy HH:mm').format(endDateTime!)}"),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              posts = allPosts;
                              startDateTime = null;
                              endDateTime = null;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text("Reset", style: TextStyle(color: Colors.orangeAccent)),
                        ),
                        TextButton(
                          onPressed: () {
                            if (startDateTime != null && endDateTime != null) {
                              if (startDateTime!.isAfter(endDateTime!)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Initial date is after the final date")),
                                );
                                return;
                              }
                              Navigator.pop(context);
                              applyDateFilter(startDateTime!, endDateTime!);
                            }
                          },
                          child: const Text("Apply", style: TextStyle(color: Colors.lightBlueAccent)),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          icon: const Icon(Icons.sort),
        ),
        IconButton(
          onPressed: () => context.go('/settings'),
          icon: const Icon(Icons.settings),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final postsJson = prefs.getStringList('posts') ?? [];
              final posts = postsJson.map((e) => Post.fromJson(json.decode(e))).toList();

              if (!context.mounted) return;

              showSearch(
                context: context,
                delegate: PostSearchDelegate(posts),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final currentIndex = _getCurrentIndex(currentLocation);

    return Scaffold(
      appBar: dynamicalAppBar(currentLocation),
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile', backgroundColor: Colors.redAccent),
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
              title: Text('News', style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
              onTap: () => context.go('/news'),
            ),
            ListTile(
              title: Text('Profile', style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
              onTap: () => context.go('/profile'),
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