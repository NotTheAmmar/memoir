import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memoir/app/app.dart';
import 'package:memoir/classes/database.dart';
import 'package:memoir/classes/local_authenticator.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/screens/error.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secure_app_switcher/secure_app_switcher.dart';

/// Entry Point of the Application
///
/// Performs initialization takes before launching the app
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return ErrorPage(errorDetails: errorDetails);
  };

  Future.wait([
    dotenv.load(),
    SQLite.initDatabase(),
    UserPreferences.initializeStorage(),
    LocalAuthenticator.initialize()
  ]).then((_) {
    SecureAppSwitcher.on();

    runApp(const App());
  });
}

/// Checks and requests the Storage Permission required for Export and Import of Containers
///
/// Returns `false` if permission is not granted or missing
Future<bool> checkPermissions() async {
  final bool storage = await Permission.storage.isGranted;

  if (!storage) {
    final PermissionStatus status = await Permission.storage.request();

    if (!status.isGranted) return false;
  }

  final bool externalStorage = await Permission.manageExternalStorage.isGranted;
  if (!externalStorage) {
    final PermissionStatus status =
        await Permission.manageExternalStorage.request();

    if (!status.isGranted) return false;
  }

  return true;
}
