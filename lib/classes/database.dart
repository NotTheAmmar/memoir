import 'package:memoir/classes/container.dart';
import 'package:memoir/classes/encryptor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// SQlite database wrapper class
///
/// Handles the Database Connection and provides all the relevant methods for storing, retrieving, and manipulating [Container]'s
///
/// [initDatabase] should be called before accessing any methods
///
/// Table Metadata:
///
/// Attributes:
///
/// `*id` (Primary Key) => `Integer`
///
/// `*name` => `Text`
///
/// `*password` => `Text`
///
/// Constraints: `Unique(name, password)`
abstract final class SQLite {
  /// Database Name
  static const String _databaseName = "vault";

  /// Table Name
  static const String _tableName = "containers";

  /// Database Object for SQLite
  static late final Database _database;

  /// Creates the necessary Tables in the Database
  static void _onCreate(Database database, int _) {
    database.execute(
      """
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        UNIQUE(name, password)
      )
      """,
    );
  }

  /// Opens the Database
  ///
  /// If the database is opened for the first, it will create the necessary tables as well
  static Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Adds a [Container] information
  ///
  /// Also encrypts the password
  ///
  /// Make sure not to insert a duplicate `name`
  static Future<void> addContainer(String name, String password) async {
    final int lastRowID = await _database.rawInsert(
      "INSERT INTO $_tableName(name, password) VALUES(?,?)",
      [name, Encryptor.encryptPassword(password)],
    );

    if (lastRowID == 0) addContainer(name, password);
  }

  /// Checks whether a Name already exists in the database of a Container
  ///
  /// To Maintain the Uniqueness of the `name` attribute
  ///
  /// Here [id] is of a container whose name is to be ignored when checking for duplicate names
  static Future<bool> doesNameExists(String name, {int id = 0}) async {
    final List<Map<String, dynamic>> result = await _database.rawQuery(
      "SELECT COUNT(*) FROM $_tableName WHERE name = ? and id <> ?",
      [name, id],
    );

    return result.first['COUNT(*)'] > 0;
  }

  /// Returns the Default [Container] Name.
  ///
  /// For example: 'Password N',
  /// where N starts from 1 and gets incremented for each password
  static Future<String> getDefaultContainerName() async {
    final List<Map<String, dynamic>> commonNames = await _database.rawQuery(
      "SELECT name FROM $_tableName WHERE name LIKE 'Password %' ORDER BY name",
    );

    int nextN = 1;
    if (commonNames.isNotEmpty) {
      // Getting Ns from 'Password N'
      List<int> nums = [];
      for (Map<String, dynamic> row in commonNames) {
        nums.add(int.parse(row['name'].substring(9)));
      }

      // No number missing from sequence
      if (nums.last == nums.length) {
        nextN = nums.last + 1;

        // One number missing from sequence
      } else if (nums.last == nums.length - 1) {
        int oneToNSum = List.generate(
          nums.last,
          (index) => index + 1,
        ).reduce((value, element) => value + element);

        int currentSum = nums.reduce((value, element) => value + element);

        nextN = oneToNSum - currentSum;

        // Some numbers missing so finding the first missing numbers
      } else {
        for (int i = 1; i < nums.length; i++) {
          if (nums[i] - nums[i - 1] != 1) {
            nextN = i + 1;
            break;
          }
        }
      }
    }

    return 'Password $nextN';
  }

  /// Returns a list of [Container] ordered by `name`
  ///
  /// decrypts the password when retrieving
  static Future<List<Container>> getContainers() async {
    final List<Map<String, dynamic>> containers = await _database.rawQuery(
      "SELECT * FROM $_tableName ORDER BY name",
    );

    return [
      for (Map<String, dynamic> container in containers)
        Container(
          id: container['id'],
          name: container['name'],
          password: Encryptor.decryptPassword(container['password']),
        )
    ];
  }

  /// Update a [Container] `password` using `name`
  ///
  /// Also encrypts the new password
  static Future<void> overridePassword(String name, String password) async {
    final int changes = await _database.rawUpdate(
      "UPDATE $_tableName SET password = ? WHERE name = ?",
      [Encryptor.encryptPassword(password), name],
    );

    if (changes == 0) overridePassword(name, password);
  }

  /// Removes a [Container] using its `id`
  static Future<void> removeContainer(int id) async {
    final int changes = await _database.rawDelete(
      "DELETE FROM $_tableName WHERE id = ?",
      [id],
    );

    if (changes == 0) removeContainer(id);
  }

  /// Update a [Container]'s information
  ///
  /// Cannot update its `id`
  ///
  /// Make sure the new `name` is Unique
  ///
  /// Also Encrypts the password
  static Future<void> updateContainer(Container container) async {
    final int changes = await _database.rawUpdate(
      "UPDATE $_tableName SET name = ?, password = ? WHERE id = ?",
      [
        container.name,
        Encryptor.encryptPassword(container.password),
        container.id
      ],
    );

    if (changes == 0) updateContainer(container);
  }
}
