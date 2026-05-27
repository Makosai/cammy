import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PresetActions extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onLoad;
  final VoidCallback onShare;

  const PresetActions({
    super.key,
    required this.onSave,
    required this.onLoad,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ShadButton.outline(
            size: ShadButtonSize.sm,
            onPressed: onSave,
            child: const Text('Save'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ShadButton.outline(
            size: ShadButtonSize.sm,
            onPressed: onLoad,
            child: const Text('Load'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ShadButton.outline(
            size: ShadButtonSize.sm,
            onPressed: onShare,
            child: const Text('Share'),
          ),
        ),
      ],
    );
  }
}
