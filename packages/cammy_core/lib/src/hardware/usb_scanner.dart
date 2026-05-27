import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import '../models/discovered_camera.dart';

class UsbScanner {
  static const int largeBufferLength = 2048;

  /// Audits the Windows multimedia streaming architecture to find and return
  /// EVERY active video capture component connected to the host system.
  List<DiscoveredCamera> discoverActiveCameras() {
    final devicesFound = <DiscoveredCamera>[];
    final arena = Arena();

    try {
      // Manually build KSCATEGORY_VIDEO {E5323777-F976-4f5b-9B55-B94699C46E44}
      final guidVideo = arena<GUID>();
      guidVideo.ref.Data1 = 0xE5323777;
      guidVideo.ref.Data2 = 0xF976;
      guidVideo.ref.Data3 = 0x4F5B;
      guidVideo.ref.Data4[0] = 0x9B;
      guidVideo.ref.Data4[1] = 0x55;
      guidVideo.ref.Data4[2] = 0xB9;
      guidVideo.ref.Data4[3] = 0x46;
      guidVideo.ref.Data4[4] = 0x99;
      guidVideo.ref.Data4[5] = 0xC4;
      guidVideo.ref.Data4[6] = 0x6E;
      guidVideo.ref.Data4[7] = 0x44;

      // Manually build KSCATEGORY_CAPTURE {65E8773D-8F56-11D0-A3B9-00A0C9223196}
      final guidCapture = arena<GUID>();
      guidCapture.ref.Data1 = 0x65E8773D;
      guidCapture.ref.Data2 = 0x8F56;
      guidCapture.ref.Data3 = 0x11D0;
      guidCapture.ref.Data4[0] = 0xA3;
      guidCapture.ref.Data4[1] = 0xB9;
      guidCapture.ref.Data4[2] = 0x00;
      guidCapture.ref.Data4[3] = 0xA0;
      guidCapture.ref.Data4[4] = 0xC9;
      guidCapture.ref.Data4[5] = 0x22;
      guidCapture.ref.Data4[6] = 0x31;
      guidCapture.ref.Data4[7] = 0x96;

      final processingCategories = [guidVideo, guidCapture];

      for (final targetGuid in processingCategories) {
        final hDevInfoResult = SetupDiGetClassDevs(
          targetGuid,
          null,
          null,
          SETUP_DI_GET_CLASS_DEVS_FLAGS(DIGCF_PRESENT | DIGCF_DEVICEINTERFACE),
        );

        if (hDevInfoResult.error.isError) continue;

        final hDevInfo = hDevInfoResult.value;

        try {
          final devInfoData = arena<SP_DEVINFO_DATA>();
          devInfoData.ref.cbSize = sizeOf<SP_DEVINFO_DATA>();

          int i = 0;
          // Walk down the device info blocks directly mapped within the interface category set
          while (SetupDiEnumDeviceInfo(hDevInfo, i, devInfoData).value) {
            final hardwareIdBuffer = arena<Uint16>(largeBufferLength);
            final friendlyNameBuffer = arena<Uint16>(largeBufferLength);
            final instanceIdBuffer = arena<Uint16>(largeBufferLength);
            final propertySize = arena<Uint32>();

            // Extract unique device instance path
            String deviceInstanceId = "UNKNOWN-NODE-$i";
            final instanceResult = SetupDiGetDeviceInstanceId(
              hDevInfo,
              devInfoData,
              PWSTR(instanceIdBuffer.cast()),
              largeBufferLength,
              null,
            );
            if (instanceResult.value) {
              deviceInstanceId = instanceIdBuffer.cast<Utf16>().toDartString();
            }

            // Avoid adding items tracked across multiple multimedia categories
            if (devicesFound.any(
              (d) => d.deviceInstanceId == deviceInstanceId,
            )) {
              i++;
              continue;
            }

            // Extract the Hardware ID descriptor string
            String hardwareId = "UNKNOWN_HW_ID";
            final hwResult = SetupDiGetDeviceRegistryProperty(
              hDevInfo,
              devInfoData,
              const SETUP_DI_REGISTRY_PROPERTY(SPDRP_HARDWAREID),
              null,
              hardwareIdBuffer.cast(),
              largeBufferLength * 2,
              propertySize,
            );
            if (hwResult.value) {
              hardwareId = hardwareIdBuffer.cast<Utf16>().toDartString();
            }

            // Extract string representation name
            String friendlyName = "Camera Device";
            final nameResult = SetupDiGetDeviceRegistryProperty(
              hDevInfo,
              devInfoData,
              const SETUP_DI_REGISTRY_PROPERTY(SPDRP_FRIENDLYNAME),
              null,
              friendlyNameBuffer.cast(),
              largeBufferLength * 2,
              propertySize,
            );

            if (nameResult.value) {
              friendlyName = friendlyNameBuffer.cast<Utf16>().toDartString();
            } else {
              // Fallback to base kernel driver description if friendly name is missing
              final descResult = SetupDiGetDeviceRegistryProperty(
                hDevInfo,
                devInfoData,
                const SETUP_DI_REGISTRY_PROPERTY(SPDRP_DEVICEDESC),
                null,
                friendlyNameBuffer.cast(),
                largeBufferLength * 2,
                propertySize,
              );
              if (descResult.value) {
                friendlyName = friendlyNameBuffer.cast<Utf16>().toDartString();
              }
            }

            // Skip virtual streaming audio hardware nodes inside the capture loop
            if (hardwareId.contains('AUDIO') ||
                friendlyName.toLowerCase().contains('microphone') ||
                friendlyName.toLowerCase().contains('speakers')) {
              i++;
              continue;
            }

            devicesFound.add(
              DiscoveredCamera(
                friendlyName: friendlyName,
                hardwareId: hardwareId,
                deviceInstanceId: deviceInstanceId,
              ),
            );
            i++;
          }
        } finally {
          SetupDiDestroyDeviceInfoList(hDevInfo);
        }
      }
    } finally {
      arena.releaseAll();
    }

    return devicesFound;
  }
}
