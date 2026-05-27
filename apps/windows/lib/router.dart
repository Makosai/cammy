import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/console_screen.dart';

final router = GoRouter(
  initialLocation: '/console', // Start in console for rapid UI testing
  routes: [
    GoRoute(
      path: '/scan',
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Scanning for Camera...'))),
    ),
    GoRoute(
      path: '/console',
      builder: (context, state) => const ConsoleScreen(),
    ),
    GoRoute(
      path: '/error',
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Connection Error'))),
    ),
  ],
);
