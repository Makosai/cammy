import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../theme/cammy_colors.dart';

class ControlAccordionItem {
  final String title;
  final List<Widget> children;

  ControlAccordionItem({required this.title, required this.children});
}

class ControlAccordion extends StatelessWidget {
  final List<ControlAccordionItem> items;

  const ControlAccordion({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            color: CammyColors.groupBg,
            borderRadius: BorderRadius.circular(4),
          ),
          child: ShadAccordion<String>.multiple(
            children: [
              ShadAccordionItem<String>(
                value: item.title,
                title: Text(item.title),
                separator: const Divider(
                  height: 1,
                  thickness: 1,
                  color: CammyColors.bgDark,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: item.children.map((child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: child,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
