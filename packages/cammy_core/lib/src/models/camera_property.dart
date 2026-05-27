enum CameraProperty {
  zoom,
  whiteBalance,
  exposure,
  focus,
  brightness,
  contrast,
  saturation,
  sharpness,
}

class CameraPropertyRange {
  final int min;
  final int max;
  final int step;
  final int defaultValue;
  final int currentValue;

  const CameraPropertyRange({
    required this.min,
    required this.max,
    required this.step,
    required this.defaultValue,
    required this.currentValue,
  });
}
