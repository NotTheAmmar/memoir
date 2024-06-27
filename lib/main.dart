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

  SQLite.instance.initDatabase().then((_) {
    runApp(const App());

    Permission.storage.isGranted.then((value) {
      if (!value) Permission.storage.request();
    });

    Permission.manageExternalStorage.isGranted.then((value) {
      if (!value) Permission.manageExternalStorage.request();
    });
  });
}
