import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/scan',
  routes: [
    GoRoute(
      path: '/scan',
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Scanning for Camera...'))),
    ),
    GoRoute(
      path: '/console',
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Camera Console'))),
    ),
    GoRoute(
      path: '/error',
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Connection Error'))),
    ),
  ],
);
