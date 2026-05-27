import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CammyTheme {
  static ShadThemeData dark() {
    return const ShadThemeData(
      brightness: Brightness.dark,
      colorScheme: ShadSlateColorScheme.dark(),
    );
  }
}
