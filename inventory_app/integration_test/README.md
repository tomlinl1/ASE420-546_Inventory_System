# Integration Tests

Integration tests for the Inventory App verify the complete user journey through the application.

## Platform Support

⚠️ **Important**: Integration tests are **NOT supported on web platform**. The tests will automatically skip when run on web.

Supported platforms:
- ✅ Android (emulator or device)
- ✅ iOS (simulator or device)
- ✅ Windows
- ✅ macOS
- ✅ Linux

## Prerequisites

1. Ensure PocketBase is running at `http://127.0.0.1:8090`
2. Have an emulator/device connected or desktop platform available

## Running Integration Tests

### Option 1: Using flutter test (Recommended)
```bash
# Run on a connected device/emulator
flutter test integration_test/app_flow_integration_test.dart

# Run on Windows desktop
flutter test -d windows integration_test/app_flow_integration_test.dart

# Run on macOS desktop
flutter test -d macos integration_test/app_flow_integration_test.dart

# Run on Linux desktop
flutter test -d linux integration_test/app_flow_integration_test.dart
```

### Option 2: Using flutter drive
```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_flow_integration_test.dart
```

## Test Coverage

The integration tests verify:
1. Complete app navigation flow (Home → Check Stock → Update Stock)
2. Home page refresh functionality
3. Low stock warning display

## Troubleshooting

**Error: "Web devices are not supported for integration tests yet"**
- This is expected on web platform. The tests will automatically skip.
- Run the tests on a supported platform instead (Android, iOS, Windows, macOS, or Linux).

**Error: "Failed to connect to PocketBase"**
- Ensure PocketBase is running at `http://127.0.0.1:8090`
- Start PocketBase before running the tests

