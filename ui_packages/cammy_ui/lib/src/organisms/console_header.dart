import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../molecules/preset_actions.dart';

class ConsoleHeader extends StatelessWidget {
  final List<String> cameras;
  final String? selectedCamera;
  final ValueChanged<String?> onCameraChanged;
  final VoidCallback onSave;
  final VoidCallback onLoad;
  final VoidCallback onShare;

  const ConsoleHeader({
    super.key,
    required this.cameras,
    this.selectedCamera,
    required this.onCameraChanged,
    required this.onSave,
    required this.onLoad,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShadSelect<String>(
          placeholder: const Text('Select Camera'),
          initialValue: selectedCamera,
          onChanged: onCameraChanged,
          selectedOptionBuilder: (context, value) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.camera, size: 16),
                const SizedBox(width: 8),
                Text(value),
              ],
            );
          },
          options: cameras.map((cam) {
            return ShadOption(value: cam, child: Text(cam));
          }).toList(),
        ),
        const SizedBox(height: 12),
        PresetActions(onSave: onSave, onLoad: onLoad, onShare: onShare),
      ],
    );
  }
}
