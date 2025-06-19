import 'package:flutter/material.dart';
import 'package:social_media_platform/models/Post.dart';
import 'package:social_media_platform/pages/actions_page.dart';
import 'package:social_media_platform/pages/favorites_page.dart'; 
import 'package:social_media_platform/pages/home_screen.dart';
import 'package:social_media_platform/pages/news.dart';
import 'package:social_media_platform/pages/notifications_page.dart';
import 'package:social_media_platform/pages/profile_page.dart';
import 'package:social_media_platform/pages/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:social_media_platform/settings/font_slider.dart';
import 'package:social_media_platform/models/PostSearchDelegate.dart'; 
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_platform/pages/short_videos_page.dart';
import 'package:social_media_platform/pages/MapPage.dart'; 
import 'package:intl/intl.dart'; 
import 'package:firebase_auth/firebase_auth.dart';

import '../generated/l10n.dart';
import '../services/firebase_post_service.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  String _previousLocation = '';
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  static const tabs = [
    '/home',
    '/notifications',
    '/settings',
    '/actions',
    '/news'
  ];

  static final appBarTitles = {
    '/home': "My Social Media Platform",
    '/notifications': "Notifications",
    '/settings': "Settings",
    '/actions': "Actions",
    '/map': 'Map'
  };

  int _getCurrentIndex(String location) {
    if (location.startsWith('/notifications')) return 1;
    if (location.startsWith('/settings')) return 2;
    if (location.startsWith('/actions')) return 3;
    if (location.startsWith('/profile')) return 4; 
    return 0;
  }

  Widget _getScreen(String location) {
    switch (location) {
      case '/notifications':
        return NotificationsPage();
      case '/settings':
        return const SettingsPage();
      case '/actions':
        return const ActionsPage();
      case '/map':
      
        return const MapPage();
      case '/news':
        return const NewsPage();
      case '/videos':
        return ShortVideosPage();
      case '/profile':
        return ProfilePage(); 
      default:
      
        return const HomeScreen();
    }
  }

  void _onHorizontalSwipe(DragEndDetails details) {
    final dx = details.velocity.pixelsPerSecond.dx;
    final tabs = ['/home', '/notifications', '/settings', '/actions'];
    final currentLocation = GoRouterState.of(context).uri.path;
    final currentIndex = _getCurrentIndex(currentLocation);

    if (dx < -300 && currentIndex < tabs.length - 1) {
      context.go(tabs[currentIndex + 1]);
    } else if (dx > 300 && currentIndex > 0) {
      context.go(tabs[currentIndex - 1]);
    }
  }

  String? _localizedTitle(BuildContext context, String key) {
    final s = S.of(context);
    final map = {
      '/home': s.home,
      '/settings': s.settings,
      '/notifications': s.notifications,
      '/actions': s.actions,
      '/map': s.map
    };
    return map[key];
  }

  PreferredSizeWidget? dynamicalAppBar(BuildContext context, String location) {
    return AppBar(
      title: Text(
          _localizedTitle(context, location) ?? S.of(context).title
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            if (location == "/map") {
              final TextEditingController searchController = TextEditingController();

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(S.of(context).search_location),
                  content: TextField(
                    controller: searchController,
                    decoration: InputDecoration(hintText: S.of(context).address_hint_text),
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
                      child: Text(S.of(context).cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        final value = searchController.text;
                        if (value.isNotEmpty) {
                          Provider.of<MapState>(context, listen: false).searchByAddress(value);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(S.of(context).search),
                    ),
                  ],
                ),
              );
            } else {
              final service = FirebasePostService();
              final allPosts = await service.getPostsOnce();
              if (!context.mounted) return;
              await showSearch(
                context: context,
                delegate: PostSearchDelegate(allPosts),
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

  Widget _buildAnimatedScreen(String location) {
    final screen = _getScreen(location);

    if (location == '/notifications') {
      return SlideTransition(
        position: _slideAnimation,
        child: screen,
      );
    } else if (location == '/settings') {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(_slideController),
        child: screen,
      );
    } else if (location == '/actions') {
      return ScaleTransition(
        scale: _fadeController,
        child: screen,
      );
    } else {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: screen,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final currentIndex = _getCurrentIndex(currentLocation);


    if (currentLocation != _previousLocation) {
      _slideController.forward(from: 0.0);
      _fadeController.forward(from: 0.0);
      _previousLocation = currentLocation;
    }

    return Scaffold(
      appBar: currentLocation == "/notifications" || currentLocation == "/actions" ? null : dynamicalAppBar(context, currentLocation),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: _onHorizontalSwipe,
        child: _buildAnimatedScreen(currentLocation),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: currentIndex,
        onTap: (index) => context.go(tabs[index]),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: S.of(context).home, backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: S.of(context).notifications, backgroundColor: Colors.indigo),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: S.of(context).settings, backgroundColor: Colors.teal),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: S.of(context).actions, backgroundColor: Colors.amber),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: S.of(context).map, backgroundColor: Colors.green)
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfilePage()) 
                          );
                        },
                        child: const CircleAvatar(
                          radius: 32,
                          backgroundImage: AssetImage('assets/blank-profile-photo.png'),
                        ),
                      ),

                      Positioned(
                        left: 30,
                        top: 30,
                        child: IconButton(
                          onPressed: () {
                            
                          },
                          icon: const Icon(Icons.add_a_photo_outlined, size: 20, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  const SizedBox
                    (width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [ AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText("Hello!", speed: Duration(milliseconds: 100), textStyle: TextStyle(color: Colors.white, fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
                          TyperAnimatedText("Сәлем!", speed: Duration(milliseconds: 100), textStyle: TextStyle(color: Colors.white, fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
                          TyperAnimatedText("Привет!", speed: Duration(milliseconds: 100), textStyle: TextStyle(color: Colors.white, fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
                    ]
                        ),
                          Text(currentUser?.displayName ?? S.of(context).user, style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue * 0.8, color: Colors.white, overflow: TextOverflow.clip)),
                        ])),
                  ]),
              ),
            ListTile(
              title: Text(S.of(context).home, style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
              onTap: () {
                Navigator.pop(context);
                context.go('/home');
              },
            ),
            ListTile(
              title: Text(S.of(context).notifications, style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
              onTap: () {
                Navigator.pop(context);
                context.go('/notifications');
              },
            ),
            ListTile(
              title: Text(S.of(context).settings, style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
              onTap: () {
                Navigator.pop(context);
                context.go('/settings');
              },
            ),
            ListTile(
              title: Text(S.of(context).messages, style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
              onTap: () {
                Navigator.pop(context);
                context.go('/');
              },
            ),
            ListTile(
              title: Text(S.of(context).map, style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
              onTap: () {
                Navigator.pop(context);
                context.go('/map');
              },
            ),
            ListTile(
              title: Text(S.of(context).login, style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
              onTap: () {
                Navigator.pop(context);
                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}