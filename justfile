set windows-shell := ["powershell.exe", "-Command"]

default:
    @just --list

# Initial workspace configuration & alignment
setup:
    @echo "Initializing native Flutter workspace..."
    flutter pub get
    just check-camera

# Verify the hardware connection state of the Camera over USB
check-camera:
    @echo "Scanning local USB hubs for a Camera (Vendor ID: 0x3454)..."
    if ($IsWindows) { \
        Get-PnpDevice -PresentOnly | Where-Object { $_.InstanceId -like "*VID_3454*" } | Select-Object FriendlyName, Status \
    } else { \
        lsusb | grep -i "3454" || echo "Warning: No matching UVC peripheral found on /dev/bus/usb" \
    }

# Trigger code-generation across the unified workspace
build-runner:
    @echo "Running build_runner across the native workspace..."
    flutter pub run build_runner build --delete-conflicting-outputs --workspace

# Platform Build Commands (Strictly Windows & Linux Shells)
run-windows:
    cd apps/windows && flutter run -d windows

run-linux:
    cd apps/linux && flutter run -d linux

build-windows-release:
    cd apps/windows && flutter build windows --release

build-linux-release:
    cd apps/linux && flutter build linux --release

# Testing & Quality Assurance
test-all:
    @echo "Executing pure Dart logic tests across workspace..."
    cd packages/cammy_core && dart test
    @echo "Executing presentation component tests..."
    cd ui_packages/cammy_ui && flutter test

analyze:
    @echo "Running unified compiler linter check..."
    flutter analyze

# Clean up local environment artifacts
clean-all:
    @echo "Flushing localized Flutter and Dart compiler caches..."
    flutter clean
    cd apps/windows && flutter clean
    cd apps/linux && flutter clean
    cd ui_packages/cammy_ui && flutter clean
    cd packages/cammy_core && dart clean

# Detailed Developer Handbook and Execution Guide
_help_text := '''
==========================================================
       CAMMY DEVELOPER COMMAND HANDBOOK
==========================================================
1. INITIAL SETUP & ENVIRONMENT
   just setup           - Run this FIRST when cloning down or updating.
                          Installs dependencies and validates USB link.
   just check-camera    - Run this if the UI isn't detecting the camera.
                          Queries Windows/Linux hardware buses for Vendor ID.

2. ACTIVE DEVELOPMENT & COMPILATION
   just build-runner    - Run this when changing models or structures.
                          Generates serialization and FFI layers via workspace.
   just run-windows     - Launches the desktop target shell on Windows 10.
   just run-linux       - Launches the desktop target shell on Linux (NixOS).

3. TESTING & CODE QUALITY
   just analyze         - Run before committing. Checks strict workspace linter rules.
   just test-all        - Runs isolated unit tests across Core and UI packages.

4. PRODUCTION DISTRIBUTION
   just build-windows-release - Compiles optimized release binary for Windows 10.
   just build-linux-release   - Compiles optimized release binary for Linux targets.
   just clean-all       - Run this if the compiler exhibits caching anomalies.
==========================================================
'''

# Detailed Developer Handbook and Execution Guide
help:
    @echo "{{_help_text}}"