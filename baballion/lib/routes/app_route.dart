import 'package:babellion/3D_AI_Avatar_frontend/src/games/debate_game/main.dart';
import 'package:babellion/3D_AI_Avatar_frontend/src/games/sentence_scramble.dart';
import 'package:babellion/screens/avatar_screen.dart';
import 'package:babellion/screens/dashboard_screen.dart';
import 'package:babellion/screens/home_screen.dart';
import 'package:babellion/screens/login_screen.dart';
import 'package:babellion/screens/profile_screen.dart';
import 'package:babellion/screens/scoreboard_screen.dart';
import 'package:babellion/screens/shell_screen.dart';
import 'package:babellion/screens/sign_up_screen.dart';
import 'package:babellion/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:babellion/3D_AI_Avatar_frontend/src/games/debate_game.dart';
import 'package:babellion/3D_AI_Avatar_frontend/src/games/vocabulary_game.dart';

class AppRouter {
  static const splash = (name: 'splash', path: '/');
  static const login = (name: 'login', path: '/login');
  static const signup = (name: 'signup', path: '/signup');

  static const home = (name: 'home', path: '/home');
  static const dashboard = (name: 'dashboard', path: '/dashboard');
  static const avatars = (name: 'avatars', path: '/avatars');
  static const scoreboard = (name: 'scoreboard', path: '/scoreboard');
  static const profile = (name: 'profile', path: '/profile');
  static const debate_game = (name: 'debate_game', path: '/debate_game');
  static const sentence_scramble =
      (name: 'sentence_scramble', path: '/sentence_scramble');
  static const vocabulary_game =
      (name: 'vocabulary_game', path: '/vocabulary_game');

  static List<int> ticks = [1, 2, 3]; // Your tick values
  static List<String> features = [
    'Vocabulary',
    'Grammar',
    'Pronunciation',
    'Fluency'
  ];
  static List<List<num>> data = [
    [1, 3, 2, 1],
    [2, 3, 3, 1], // Example data for scores
  ];
  static List<String> graphNames = [
    'Latest Score',
    'Previous Score',
  ];
  static final router = GoRouter(initialLocation: splash.path, routes: [
    GoRoute(
      name: splash.name,
      path: splash.path,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: login.name,
      path: login.path,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      name: signup.name,
      path: signup.path,
      builder: (context, state) => SignUpScreen(),
    ),
    ShellRoute(
      routes: [
        GoRoute(
          name: home.name,
          path: home.path,
          builder: (context, state) => HomeScreen(),
        ),
        // GoRoute(
        //   name: dashboard.name,
        //   path: dashboard.path,
        //   builder: (context, state) => DashboardScreen(),
        // ),
        GoRoute(
          name: dashboard.name,
          path: dashboard.path,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final fullName = extra['fullName'] as String? ?? 'Unknown User';
            final email = extra['email'] as String? ?? 'Unknown Email';

            // return DashboardScreen(fullName: fullName, email: email);
            return DashboardScreen();
          },
        ),
        GoRoute(
          name: avatars.name,
          path: avatars.path,
          builder: (context, state) => AvatarsScreen(),
        ),
        GoRoute(
          name: scoreboard.name,
          path: scoreboard.path,
          builder: (context, state) => ScoreboardScreen(),
        ),

        GoRoute(
          name: profile.name,
          path: profile.path,
          builder: (context, state) => ProfileScreen(),
        ),
        GoRoute(
          name: debate_game.name,
          path: debate_game.path,
          builder: (context, state) => const DebateGame(),
        ),
        GoRoute(
          name: sentence_scramble.name,
          path: sentence_scramble.path,
          builder: (context, state) => const MyApp(),
        ),
        GoRoute(
          name: vocabulary_game.name,
          path: vocabulary_game.path,
          builder: (context, state) => const VGame(),
        ),
      ],
      builder: (context, state, child) => ShellScreen(child: child),
    ),
  ]);
}
