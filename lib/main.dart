import 'package:flutter/material.dart';
import 'package:memoir/app/app.dart';
import 'package:memoir/classes/database.dart';
import 'package:memoir/screens/error.dart';
import 'package:permission_handler/permission_handler.dart';

/// Entry Point of the Application
///
/// Initializes [SQLite] Database before launching the app
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return ErrorPage(errorDetails: errorDetails);
  };

  SQLite.instance.initDatabase().then((_) => runApp(const App()));
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
