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
import 'package:social_media_platform/route_transitions.dart';
import 'package:social_media_platform/post_detail.dart'; 

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
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/notifications',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const SizedBox.shrink(),
          ),
        ),
        GoRoute(
          path: '/favorites',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const SizedBox.shrink(),
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const SizedBox.shrink(),
          ),
        ),
        GoRoute(
          path: '/actions',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const SizedBox.shrink(),
          ),
        ),
        GoRoute(
          path: '/map',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const SizedBox.shrink(),
          ),
        ),
        GoRoute(
          path: '/videos',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const SizedBox.shrink(),
          ),
        ),
        GoRoute(
          path: '/news',
          pageBuilder: (context, state) => NoTransitionPage(
            child: const SizedBox.shrink(),
          ),
        ),
        GoRoute(
            path: '/profile',
            pageBuilder: (context, index) => NoTransitionPage(
              child: const SizedBox.shrink(),
            )
        )],
    ),
    
    GoRoute(
      path: '/post/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] ?? '0';

        return CustomTransitionPage(
          child: PostDetailPage(postId: id), 
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.3),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
        );
      },
    ),
    
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
  ],
);