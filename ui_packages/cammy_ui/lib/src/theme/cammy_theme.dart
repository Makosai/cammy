import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'cammy_colors.dart';

class CammyTheme {
  static ShadThemeData dark() {
    return ShadThemeData(
      brightness: Brightness.dark,
      disableSecondaryBorder: true,
      colorScheme: const ShadSlateColorScheme.dark(
        primary: CammyColors.primary,
        background: CammyColors.bgDark,
        foreground: CammyColors.textDark,
        muted: CammyColors.groupBg,
        mutedForeground: CammyColors.textMuted,
        popover: CammyColors.dropdownBg,
        secondary: CammyColors.groupBg,
        secondaryForeground: CammyColors.textDark,
        border: CammyColors.borderNormal,
      ),
      primaryButtonTheme: const ShadButtonTheme(
        backgroundColor: CammyColors.primary,
        hoverBackgroundColor: CammyColors.primaryHoverDark,
        foregroundColor: Colors.white,
        height: 32,
      ),
      secondaryButtonTheme: const ShadButtonTheme(
        backgroundColor: CammyColors.groupBg,
        foregroundColor: CammyColors.textDark,
        height: 32,
      ),
      radius: const BorderRadius.all(Radius.circular(6)),
      accordionTheme: const ShadAccordionTheme(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      selectTheme: ShadSelectTheme(
        decoration: ShadDecoration(
          color: CammyColors.dropdownBg,
          border: ShadBorder.all(
            color: CammyColors.borderNormal,
            width: 0.5,
            radius: BorderRadius.circular(6),
          ),
        ),
      ),
      textTheme: ShadTextTheme(
        small: const TextStyle(fontSize: 11, color: CammyColors.textMuted),
      ),
    );
  }
}
