import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CamToggleGroup extends StatelessWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const CamToggleGroup({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ShadTabs<String>(
      value: value,
      onChanged: onChanged,
      tabs: options.map((opt) {
        return ShadTab(value: opt, child: Text(opt));
      }).toList(),
    );
  }
}
