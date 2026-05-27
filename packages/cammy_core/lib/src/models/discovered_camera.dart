/// Metadata profile representing a dynamically discovered hardware target.
class DiscoveredCamera {
  final String friendlyName;
  final String hardwareId;
  final String deviceInstanceId;

  DiscoveredCamera({
    required this.friendlyName,
    required this.hardwareId,
    required this.deviceInstanceId,
  });
}
