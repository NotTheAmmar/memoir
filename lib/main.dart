import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memoir/app/app.dart';
import 'package:memoir/classes/database.dart';
import 'package:memoir/classes/local_authenticator.dart';
import 'package:memoir/classes/user_preferences.dart';
import 'package:memoir/screens/error.dart';
import 'package:permission_handler/permission_handler.dart';

/// Entry Point of the Application
///
/// Performs initialization takes before launching the app
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return ErrorPage(errorDetails: errorDetails);
  };

  Future.wait([
    dotenv.load().then((_) async {
      return EncryptedSharedPreferences.initialize(
        dotenv.env["SHARED_PREFERENCES_ENCRYPTION_KEY"]!,
      );
    }),
    SQLite.initDatabase(),
    UserPreferences.initializeStorage(),
    LocalAuthenticator.initialize()
  ]).then((_) => runApp(const App()));
}

/// Checks and requests the Storage Permission required for Export and Import of Containers
///
/// Returns `false` if permission is not granted or missing
Future<bool> checkPermissions() async {
  if (!await Permission.storage.isGranted) {
    if (!(await Permission.storage.request()).isGranted) return false;
  }

  if (!await Permission.manageExternalStorage.isGranted) {
    if (!(await Permission.manageExternalStorage.request()).isGranted) {
      return false;
    }
  }

  return true;
}
