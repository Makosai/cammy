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
            width: 320,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: sidebarHeader,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: sidebarContent,
                  ),
                ),
              ],
            ),
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
