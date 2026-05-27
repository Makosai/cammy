import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
    return ShadAccordion<ControlAccordionItem>.multiple(
      children: items.map((item) {
        return ShadAccordionItem<ControlAccordionItem>(
          value: item,
          title: Text(item.title),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: item.children.map((child) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: child,
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
