import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cammy_ui/cammy_ui.dart';
import 'router.dart';

void main() {
  runApp(const CammyApp());
}

class CammyApp extends StatelessWidget {
  const CammyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.router(
      title: 'Cammy',
      debugShowCheckedModeBanner: false,
      theme: CammyTheme.dark(),
      routerConfig: router,
    );
  }
}
