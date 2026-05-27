import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import '../models/discovered_camera.dart';

class UsbScanner {
  static const int cammyVendorId = 0x3454;

  /// Actively queries the Windows hardware hub layout, searching for and
  /// isolating specific configurations
  List<DiscoveredCamera> discoverActiveCameras() {
    final devicesFound = <DiscoveredCamera>[];
    final arena = Arena();

    try {
      // GUID_DEVINTERFACE_USB_DEVICE {A5DCBF10-6530-11D2-901F-00C04FB17C9E}
      final guid = arena<GUID>();
      guid.ref.Data1 = 0xA5DCBF10;
      guid.ref.Data2 = 0x6530;
      guid.ref.Data3 = 0x11D2;
      guid.ref.Data4[0] = 0x90;
      guid.ref.Data4[1] = 0x1F;
      guid.ref.Data4[2] = 0x00;
      guid.ref.Data4[3] = 0xC0;
      guid.ref.Data4[4] = 0x4F;
      guid.ref.Data4[5] = 0xB1;
      guid.ref.Data4[6] = 0x7C;
      guid.ref.Data4[7] = 0x9E;

      final hDevInfoResult = SetupDiGetClassDevs(
        guid,
        null,
        null,
        SETUP_DI_GET_CLASS_DEVS_FLAGS(DIGCF_PRESENT | DIGCF_DEVICEINTERFACE),
      );

      if (hDevInfoResult.error.isError) {
        return devicesFound;
      }

      final hDevInfo = hDevInfoResult.value;

      try {
        final devInfoData = arena<SP_DEVINFO_DATA>();
        devInfoData.ref.cbSize = sizeOf<SP_DEVINFO_DATA>();

        int i = 0;
        while (SetupDiEnumDeviceInfo(hDevInfo, i, devInfoData).value) {
          final hardwareIdBuffer = arena<Uint16>(MAX_PATH);
          final friendlyNameBuffer = arena<Uint16>(MAX_PATH);
          final instanceIdBuffer = arena<Uint16>(MAX_PATH);
          final propertySize = arena<Uint32>();

          // Search and pull the Hardware ID string
          final hwResult = SetupDiGetDeviceRegistryProperty(
            hDevInfo,
            devInfoData,
            const SETUP_DI_REGISTRY_PROPERTY(SPDRP_HARDWAREID),
            null,
            hardwareIdBuffer.cast(),
            MAX_PATH * 2,
            propertySize,
          );

          if (hwResult.value) {
            final hardwareId = hardwareIdBuffer.cast<Utf16>().toDartString();

            // Perform dynamic vendor matching verification
            if (hardwareId.contains(
              'VID_${cammyVendorId.toRadixString(16).toUpperCase()}',
            )) {
              // Extract the OS friendly name
              String friendlyName = "Camera Device";
              final nameResult = SetupDiGetDeviceRegistryProperty(
                hDevInfo,
                devInfoData,
                const SETUP_DI_REGISTRY_PROPERTY(SPDRP_FRIENDLYNAME),
                null,
                friendlyNameBuffer.cast(),
                MAX_PATH * 2,
                propertySize,
              );
              if (nameResult.value) {
                friendlyName = friendlyNameBuffer.cast<Utf16>().toDartString();
              }

              // Retrieve the absolute Device Instance ID for direct binding paths
              String deviceInstanceId = "UNKNOWN_INSTANCE_NODE";
              final instanceResult = SetupDiGetDeviceInstanceId(
                hDevInfo,
                devInfoData,
                PWSTR(instanceIdBuffer.cast()),
                MAX_PATH,
                null,
              );
              if (instanceResult.value) {
                deviceInstanceId = instanceIdBuffer
                    .cast<Utf16>()
                    .toDartString();
              }

              // Append verified target node to active device directory
              devicesFound.add(
                DiscoveredCamera(
                  friendlyName: friendlyName,
                  hardwareId: hardwareId,
                  deviceInstanceId: deviceInstanceId,
                ),
              );
            }
          }
          i++;
        }
      } finally {
        SetupDiDestroyDeviceInfoList(hDevInfo);
      }
    } finally {
      arena.releaseAll();
    }

    return devicesFound;
  }
}
