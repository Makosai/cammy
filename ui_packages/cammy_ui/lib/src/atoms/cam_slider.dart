import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CamSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final String? label;

  const CamSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(label!, style: theme.textTheme.small),
          ),
        ShadSlider(
          initialValue: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
