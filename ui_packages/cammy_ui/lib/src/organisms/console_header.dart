import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../molecules/preset_actions.dart';

class ConsoleHeader extends StatelessWidget {
  final List<String> cameras;
  final String? selectedCamera;
  final bool isScanning;
  final ValueChanged<String?> onCameraChanged;
  final VoidCallback onRefresh;
  final VoidCallback onSave;
  final VoidCallback onLoad;
  final VoidCallback onShare;

  const ConsoleHeader({
    super.key,
    required this.cameras,
    this.selectedCamera,
    this.isScanning = false,
    required this.onCameraChanged,
    required this.onRefresh,
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
        Row(
          children: [
            Expanded(
              child: ShadSelect<String>(
                placeholder: Text(isScanning ? 'Scanning...' : 'Select Camera'),
                initialValue: selectedCamera,
                onChanged: onCameraChanged,
                onPressed:
                    onRefresh, // Trigger refresh when clicking/opening select
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
                options: [
                  if (cameras.isEmpty && !isScanning)
                    const ShadOption(value: '', child: Text('No Camera Found')),
                  ...cameras.map((cam) {
                    return ShadOption(value: cam, child: Text(cam));
                  }),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ShadIconButton.ghost(
              icon: isScanning
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white70,
                      ),
                    )
                  : const Icon(LucideIcons.refreshCw, size: 16),
              onPressed: isScanning ? null : onRefresh,
            ),
          ],
        ),
        const SizedBox(height: 12),
        PresetActions(onSave: onSave, onLoad: onLoad, onShare: onShare),
      ],
    );
  }
}
