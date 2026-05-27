import 'package:flutter/material.dart';

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
    return Scaffold(
      body: Row(
        children: [
          // Left Sidebar
          SizedBox(
            width: 320,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: sidebarHeader,
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: sidebarContent,
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          // Right Main Content
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
