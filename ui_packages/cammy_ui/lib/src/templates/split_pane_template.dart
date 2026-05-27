import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SplitPaneTemplate extends StatelessWidget {
  final Widget sidebarHeader;
  final Widget sidebarContent;
  final Widget mainContent;

  const SplitPaneTemplate({
    super.key,
    required this.sidebarHeader,
    required this.sidebarContent,
    required this.mainContent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Fixed Left Sidebar
          SizedBox(
            width: 300, // Slightly thinner
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                  child: sidebarHeader,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: sidebarContent,
                  ),
                ),
              ],
            ),
          ),
          // Thinner vertical gap
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: theme.colorScheme.border,
          ),
          // Static Main Content
          Expanded(
            child: Container(
              color: theme.colorScheme.background,
              child: mainContent,
            ),
          ),
        ],
      ),
    );
  }
}
