import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_platform/pages/enter_page.dart';
import 'package:social_media_platform/pages/favorites_page.dart';
import 'package:social_media_platform/pages/home_screen.dart';
import 'package:social_media_platform/pages/actions_page.dart';
import 'package:social_media_platform/pages/main_screen.dart';
import 'package:social_media_platform/pages/not_found_page.dart';
import 'package:social_media_platform/pages/notifications_page.dart';
import 'package:social_media_platform/pages/post_page.dart';
import 'package:social_media_platform/pages/settings_page.dart';
import 'package:social_media_platform/models/Post.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScreen();
      },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const SizedBox.shrink()),
        GoRoute(path: '/notifications', builder: (context, state) => const SizedBox.shrink()),
        GoRoute(path: '/favorites', builder: (context, state) => const SizedBox.shrink()),
        GoRoute(path: '/settings', builder: (context, state) => const SizedBox.shrink()),
        GoRoute(path: '/actions', builder: (context, state) => const SizedBox.shrink()),
        GoRoute(path: '/map', builder: (context, state) => const SizedBox.shrink()),
        GoRoute(path: '/news', builder: (context, state) => const SizedBox.shrink()),
        GoRoute(path: '/videos', builder: (context, state) => const SizedBox.shrink()),
        GoRoute(path: '/post/:id', builder: (context, state) => const SizedBox.shrink()),
      ],
    ),
    GoRoute(
      path: '/post/:id',
      builder: (context, state) {
        final post = state.extra as Post?;
        final id = state.pathParameters['id'] ?? '0';

        return PostPage(post: post!);
      },
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
  ],
);