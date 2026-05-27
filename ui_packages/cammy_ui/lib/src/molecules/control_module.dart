import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ControlModule extends StatelessWidget {
  final String label;
  final Widget control;
  final Widget? extra;
  final String? inputValue;
  final ValueChanged<String>? onInputChanged;

  const ControlModule({
    super.key,
    required this.label,
    required this.control,
    this.extra,
    this.inputValue,
    this.onInputChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: theme.textTheme.small),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: control),
            if (onInputChanged != null) ...[
              const SizedBox(width: 8),
              SizedBox(
                width: 60,
                child: ShadInput(
                  initialValue: inputValue,
                  onChanged: onInputChanged,
                  keyboardType: TextInputType.number,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
              ),
            ],
            if (extra != null) ...[const SizedBox(width: 8), extra!],
          ],
        ),
      ],
    );
  }
}
