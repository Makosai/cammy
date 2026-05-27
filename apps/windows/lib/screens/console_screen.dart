import 'dart:async';

import 'package:camera/camera.dart';
import 'package:cammy_core/cammy_core.dart';
import 'package:cammy_ui/cammy_ui.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ConsoleScreen extends StatefulWidget {
  const ConsoleScreen({super.key});

  @override
  State<ConsoleScreen> createState() => _ConsoleScreenState();
}

class _ConsoleScreenState extends State<ConsoleScreen> {
  // --- Hardware & Previews ---
  final _scanner = UsbScanner();
  Timer? _refreshTimer;
  CameraController? _cameraController;

  // --- State Variables ---
  bool _isScanning = false;
  bool _isCameraLoading = false;
  String? _pipelineError; // Tracks underlying native initialization errors
  DiscoveredCamera? selectedCamera;
  List<DiscoveredCamera> _discoveredCameras = [];

  @override
  void initState() {
    super.initState();
    _scanForCameras();
    _startTimer();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  void _startTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _scanForCameras(),
    );
  }

  Future<void> _scanForCameras() async {
    if (_isScanning) return;

    setState(() => _isScanning = true);

    try {
      final discovered = await Future.delayed(
        const Duration(milliseconds: 500),
        () => _scanner.discoverActiveCameras(),
      );

      if (!mounted) return;

      setState(() {
        _discoveredCameras = discovered;
        if (_discoveredCameras.isNotEmpty) {
          final retainsSelection = _discoveredCameras.any(
            (c) => c.deviceInstanceId == selectedCamera?.deviceInstanceId,
          );

          if (selectedCamera == null || !retainsSelection) {
            _onCameraSelected(_discoveredCameras.first);
          }
        } else {
          selectedCamera = null;
          _isCameraLoading = false;
          _cameraController?.dispose();
          _cameraController = null;
          _pipelineError = null;
        }
        _isScanning = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isScanning = false);
    }
  }

  /// Completely initializes the local hardware stream for the chosen camera node
  Future<void> _onCameraSelected(DiscoveredCamera camera) async {
    setState(() {
      selectedCamera = camera;
      _isCameraLoading = true;
      _pipelineError = null; // Flush legacy failures
    });

    if (_cameraController != null) {
      await _cameraController!.dispose();
      _cameraController = null;
    }

    try {
      final hardwareCameras = await availableCameras();

      // Print system strings straight to your terminal to audit WMF visibility
      debugPrint(
        "Cammy Media Foundation Found: ${hardwareCameras.map((c) => c.name).toList()}",
      );

      if (hardwareCameras.isEmpty) {
        throw Exception(
          "Windows Media Foundation reports 0 media capture sources available.",
        );
      }

      // Loose matching sequence to reconcile FFI and WMF driver variations
      final targetSystemCamera = hardwareCameras.firstWhere(
        (c) =>
            c.name.toLowerCase().contains(camera.friendlyName.toLowerCase()) ||
            camera.friendlyName.toLowerCase().contains(c.name.toLowerCase()),
        orElse: () => hardwareCameras.first,
      );

      final controller = CameraController(
        targetSystemCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) return;
      setState(() {
        _cameraController = controller;
        _isCameraLoading = false;
      });
    } catch (e) {
      debugPrint("CRITICAL CAMERA STAND UP FAILURE: $e");
      if (!mounted) return;
      setState(() {
        _isCameraLoading = false;
        _pipelineError = e
            .toString(); // Expose the exact exception block string to the UI
      });
    }
  }

  void _manualRefresh() {
    _scanForCameras();
    _startTimer();
  }

  // General Settings
  String preset = 'Natural';
  String resolution = '1080p';
  String frameRate = '60fps';
  String orientation = 'Horizontal';

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

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return SplitPaneTemplate(
      sidebarHeader: ConsoleHeader(
        cameras: _discoveredCameras.map((c) => c.friendlyName).toList(),
        selectedCamera: selectedCamera?.friendlyName,
        isScanning: _isScanning,
        onCameraChanged: (String? val) {
          if (val == null || val.isEmpty) return;
          final match = _discoveredCameras.firstWhere(
            (c) => c.friendlyName == val,
          );
          _onCameraSelected(match);
        },
        onRefresh: _manualRefresh,
        onSave: () {},
        onLoad: () {},
        onShare: () {},
      ),
      sidebarContent: ControlAccordion(
        key: const PageStorageKey('sidebar-accordion'),
        items: [
          ControlAccordionItem(
            title: 'General',
            children: [
              ControlModule(
                label: 'Presets',
                control: ShadSelect<String>(
                  initialValue: preset,
                  onChanged: (String? v) => setState(() => preset = v!),
                  selectedOptionBuilder: (context, v) => Text(v),
                  options: [
                    'Cinema',
                    'Natural',
                    'Vibrant',
                  ].map((v) => ShadOption(value: v, child: Text(v))).toList(),
                ),
              ),
              ControlModule(
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
                  selectedOptionBuilder: (context, v) => Text(v),
                  options: [
                    '1080p @ 60fps',
                    '1080p @ 30fps',
                    '720p @ 60fps',
                  ].map((v) => ShadOption(value: v, child: Text(v))).toList(),
                ),
              ),
              ControlModule(
                label: 'Orientation',
                control: SizedBox(
                  width: double.infinity,
                  child: ShadTabs<String>(
                    value: orientation,
                    onChanged: (String? v) => setState(() => orientation = v!),
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
            ],
          ),
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
        padding: const EdgeInsets.only(left: 12.0),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.zero,
            border: Border.all(color: theme.colorScheme.border, width: 0.5),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // STATE 1: Camera Hardware Is Initializing / Buffering Video Channels
              if (_isCameraLoading) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Loading Camera',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedCamera?.friendlyName ??
                            'Initializing hardware node...',
                        style: theme.textTheme.small.copyWith(
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox.square(
                        dimension: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // STATE 2: Native Pipeline Active - Stream the GPU Texture Frame directly
              if (_pipelineError != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.alertTriangle,
                          color: Colors.orangeAccent,
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Pipeline Initialization Failed',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _pipelineError!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.small.copyWith(
                            color: Colors.redAccent,
                            fontFamily: 'JetBrainsMono',
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (_cameraController != null &&
                  _cameraController!.value.isInitialized) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: AspectRatio(
                        aspectRatio: _cameraController!.value.aspectRatio,
                        child: CameraPreview(_cameraController!),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black87, Colors.transparent],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Camera Preview',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              selectedCamera?.friendlyName ?? 'Active Stream',
                              style: theme.textTheme.small.copyWith(
                                color: Colors.white54,
                                fontSize: 11,
                                fontFamily: 'JetBrainsMono',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              // STATE 3: Default Empty/Fallback Screen (No device bounded yet)
              return Center(
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
                      'No active camera stream initialized.',
                      style: theme.textTheme.small.copyWith(
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
