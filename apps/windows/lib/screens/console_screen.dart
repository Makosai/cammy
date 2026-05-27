import 'package:cammy_ui/cammy_ui.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ConsoleScreen extends StatefulWidget {
  const ConsoleScreen({super.key});

  @override
  State<ConsoleScreen> createState() => _ConsoleScreenState();
}

class _ConsoleScreenState extends State<ConsoleScreen> {
  // --- State Variables ---
  String? selectedCamera = 'Camera #1';
  final List<String> cameras = ['Camera #1', 'Camera #2'];

  // Image Settings
  String imageVersion = 'v1.0.0';
  double sharpness = 50;
  double contrast = 50;
  double saturation = 50;
  double drValue = 30;
  bool lensShadingCorrection = true;

  // Focus
  String focusType = 'AF-C';

  // Zoom
  double zoomValue = 1.0;

  // Exposure
  String exposureMode = 'Auto';
  String isoValue = '400';
  String shutterSpeed = '1/60';

  // White Balance
  String wbMode = 'Auto';
  double wbTemp = 5000;
  String greenOffset = '0';
  double blueOffset = 0;
  double redOffset = 0;

  // Preview Config
  String resolution = '1080p';
  String frameRate = '60fps';
  String orientation = 'Horizontal';

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return SplitPaneTemplate(
      sidebarHeader: ConsoleHeader(
        cameras: cameras,
        selectedCamera: selectedCamera,
        onCameraChanged: (String? val) => setState(() => selectedCamera = val),
        onSave: () {},
        onLoad: () {},
        onShare: () {},
      ),
      sidebarContent: ControlAccordion(
        key: const PageStorageKey('sidebar-accordion'),
        items: [
          ControlAccordionItem(
            title: 'Image Settings',
            children: [
              ControlModule(
                label: 'Image Version',
                control: ShadSelect<String>(
                  initialValue: imageVersion,
                  onChanged: (String? v) => setState(() => imageVersion = v!),
                  selectedOptionBuilder: (context, v) => Text(v),
                  options: [
                    'v1.0.0',
                    'v1.1.0',
                  ].map((v) => ShadOption(value: v, child: Text(v))).toList(),
                ),
              ),
              ControlModule(
                label: 'Sharpness',
                control: CamSlider(
                  value: sharpness,
                  min: 0,
                  max: 100,
                  onChanged: (double v) => setState(() => sharpness = v),
                ),
                inputValue: sharpness.toInt().toString(),
                onInputChanged: (String v) =>
                    setState(() => sharpness = double.tryParse(v) ?? sharpness),
              ),
              ControlModule(
                label: 'Contrast',
                control: CamSlider(
                  value: contrast,
                  min: 0,
                  max: 100,
                  onChanged: (double v) => setState(() => contrast = v),
                ),
                inputValue: contrast.toInt().toString(),
                onInputChanged: (String v) =>
                    setState(() => contrast = double.tryParse(v) ?? contrast),
              ),
              ControlModule(
                label: 'Saturation',
                control: CamSlider(
                  value: saturation,
                  min: 0,
                  max: 100,
                  onChanged: (double v) => setState(() => saturation = v),
                ),
                inputValue: saturation.toInt().toString(),
                onInputChanged: (String v) => setState(
                  () => saturation = double.tryParse(v) ?? saturation,
                ),
              ),
              ControlModule(
                label: 'D-R',
                control: CamSlider(
                  value: drValue,
                  min: 0,
                  max: 100,
                  onChanged: (double v) => setState(() => drValue = v),
                ),
                inputValue: drValue.toInt().toString(),
                onInputChanged: (String v) =>
                    setState(() => drValue = double.tryParse(v) ?? drValue),
              ),
              ControlModule(
                label: 'Lens Shading Correction',
                control: ShadSwitch(
                  value: lensShadingCorrection,
                  onChanged: (bool v) =>
                      setState(() => lensShadingCorrection = v),
                ),
              ),
            ],
          ),
          ControlAccordionItem(
            title: 'Focus',
            children: [
              ControlModule(
                label: 'Type',
                control: ShadSelect<String>(
                  initialValue: focusType,
                  onChanged: (String? v) => setState(() => focusType = v!),
                  selectedOptionBuilder: (context, v) => Text(v),
                  options: [
                    'AF-C',
                    'AF-S',
                    'Face',
                  ].map((v) => ShadOption(value: v, child: Text(v))).toList(),
                ),
              ),
            ],
          ),
          ControlAccordionItem(
            title: 'Zoom',
            children: [
              ControlModule(
                label: 'Zoom Level',
                control: CamSlider(
                  value: zoomValue,
                  min: 1.0,
                  max: 10.0,
                  onChanged: (double v) => setState(() => zoomValue = v),
                ),
                inputValue: zoomValue.toStringAsFixed(1),
                onInputChanged: (String v) =>
                    setState(() => zoomValue = double.tryParse(v) ?? zoomValue),
              ),
            ],
          ),
          ControlAccordionItem(
            title: 'Exposure',
            children: [
              CamToggleGroup(
                value: exposureMode,
                options: const ['Auto', 'Manual'],
                onChanged: (String v) => setState(() => exposureMode = v),
              ),
              const SizedBox(height: 8),
              ControlModule(
                label: 'ISO',
                control: ShadSelect<String>(
                  initialValue: isoValue,
                  onChanged: (String? v) => setState(() => isoValue = v!),
                  selectedOptionBuilder: (context, v) => Text(v),
                  options: [
                    '200',
                    '250',
                    '320',
                    '400',
                    '500',
                  ].map((v) => ShadOption(value: v, child: Text(v))).toList(),
                ),
                inputValue: isoValue,
                onInputChanged: (String v) => setState(() => isoValue = v),
              ),
              ControlModule(
                label: 'Shutter',
                control: ShadSelect<String>(
                  initialValue: shutterSpeed,
                  onChanged: (String? v) => setState(() => shutterSpeed = v!),
                  selectedOptionBuilder: (context, v) => Text(v),
                  options: [
                    '1/100',
                    '1/80',
                    '1/60',
                    '1/50',
                    '1/30',
                  ].map((v) => ShadOption(value: v, child: Text(v))).toList(),
                ),
                inputValue: shutterSpeed,
                onInputChanged: (String v) => setState(() => shutterSpeed = v),
              ),
            ],
          ),
          ControlAccordionItem(
            title: 'White Balance',
            children: [
              CamToggleGroup(
                value: wbMode,
                options: const ['Auto', 'Manual'],
                onChanged: (String v) => setState(() => wbMode = v),
              ),
              const SizedBox(height: 8),
              ControlModule(
                label: 'WB Temperature',
                control: CamSlider(
                  value: wbTemp,
                  min: 2000,
                  max: 10000,
                  onChanged: (double v) => setState(() => wbTemp = v),
                ),
                inputValue: wbTemp.toInt().toString(),
                onInputChanged: (String v) =>
                    setState(() => wbTemp = double.tryParse(v) ?? wbTemp),
              ),
              ControlModule(
                label: 'Green Offset',
                control: const SizedBox.shrink(),
                inputValue: greenOffset,
                onInputChanged: (String v) => setState(() => greenOffset = v),
              ),
              ControlModule(
                label: 'Blue Offset',
                control: CamSlider(
                  value: blueOffset,
                  min: -100,
                  max: 100,
                  onChanged: (double v) => setState(() => blueOffset = v),
                ),
                inputValue: blueOffset.toInt().toString(),
                onInputChanged: (String v) => setState(
                  () => blueOffset = double.tryParse(v) ?? blueOffset,
                ),
              ),
              ControlModule(
                label: 'Red Offset',
                control: CamSlider(
                  value: redOffset,
                  min: -100,
                  max: 100,
                  onChanged: (double v) => setState(() => redOffset = v),
                ),
                inputValue: redOffset.toInt().toString(),
                onInputChanged: (String v) =>
                    setState(() => redOffset = double.tryParse(v) ?? redOffset),
              ),
            ],
          ),
        ],
      ),
      mainContent: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Preview Group Section
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.border,
                    width: 0.5,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Camera Preview',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'under development',
                        style: theme.textTheme.small.copyWith(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Bottom Config Group Section
            Container(
              height: 240,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Row with 4 equal-sized columns
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Column 1: Presets, Resolution & Orientation
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Presets Row
                            ControlModule(
                              label: 'Presets',
                              control: ShadSelect<String>(
                                placeholder: const Text('Select Preset'),
                                onChanged: (String? v) {},
                                selectedOptionBuilder: (context, v) => Text(v),
                                options: ['Cinema', 'Natural', 'Vibrant']
                                    .map(
                                      (v) =>
                                          ShadOption(value: v, child: Text(v)),
                                    )
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Resolution and Orientation Row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: ControlModule(
                                    label: 'Resolution & Frame Rate',
                                    control: ShadSelect<String>(
                                      initialValue: '$resolution @ $frameRate',
                                      onChanged: (String? v) {
                                        if (v == null) return;
                                        final parts = v.split(' @ ');
                                        setState(() {
                                          resolution = parts[0];
                                          frameRate = parts[1];
                                        });
                                      },
                                      selectedOptionBuilder: (context, v) =>
                                          Text(v),
                                      options:
                                          [
                                                '1080p @ 60fps',
                                                '1080p @ 30fps',
                                                '720p @ 60fps',
                                              ]
                                              .map(
                                                (v) => ShadOption(
                                                  value: v,
                                                  child: Text(v),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 1,
                                  child: ControlModule(
                                    label: 'Orientation',
                                    control: SizedBox(
                                      width: double.infinity,
                                      child: ShadTabs<String>(
                                        value: orientation,
                                        onChanged: (String? v) =>
                                            setState(() => orientation = v!),
                                        tabs: const [
                                          ShadTab(
                                            value: 'Horizontal',
                                            content: SizedBox.shrink(),
                                            child: Text('H'),
                                          ),
                                          ShadTab(
                                            value: 'Vertical',
                                            content: SizedBox.shrink(),
                                            child: Text('V'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Column 2: Filler
                      Expanded(
                        child: ControlModule(
                          label: '',
                          control: Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.muted.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Column 3: Filler
                      Expanded(
                        child: ControlModule(
                          label: '',
                          control: Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.muted.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Column 4: Filler
                      Expanded(
                        child: ControlModule(
                          label: '',
                          control: Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.muted.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
