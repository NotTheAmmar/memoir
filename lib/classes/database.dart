import 'package:memoir/classes/container.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// SQlite database wrapper class
///
/// Handles the Database Connection and provides all the relevant methods for storing, retrieving, and manipulating [Container]'s
///
/// It is singleton class and data is to be accessed through [instance]
///
/// Table Metadata:
///
/// Attributes:
/// `*id` (Primary Key) => `Integer`,
/// `*name` => `Text`,
/// `*password` => `Text`
///
/// Constraints: `Unique(name, password)`
class SQLite {
  /// Database Name
  final String _databaseName = "vault";

  /// Table Name
  final String _tableName = "containers";

  /// Private Default Constructor
  SQLite._();

  /// Actual Instance
  static final SQLite _instance = SQLite._();

  /// Instance of the Class
  ///
  /// All the properties and methods are to be accessed through this
  static SQLite get instance => _instance;

  /// Database Object for SQLite
  late final Database _database;

  /// Creates the necessary Tables in the Database
  void _onCreate(Database database, int _) {
    database.execute(
      "CREATE TABLE $_tableName("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "name TEXT NOT NULL UNIQUE,"
      "password TEXT NOT NULL,"
      "UNIQUE(name, password)"
      ")",
    );
  }

  /// Opens the Database
  ///
  /// If the database is opened for the first, it will create the necessary tables as well
  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Adds a [Container] information
  ///
  /// Make sure not to insert a duplicate `name`
  Future<void> addContainer(String name, String password) async {
    final int lastRowID = await _database.rawInsert(
      'INSERT INTO $_tableName(name, password) VALUES(?,?)',
      [name, password],
    );

    if (lastRowID == 0) addContainer(name, password);
  }

  /// Checks whether a Name already exists in the database of a Container
  ///
  /// To Maintain the Uniqueness of the `name` attribute
  ///
  /// Here [id] is of a container whose name is to be ignored when checking for duplicate names
  Future<bool> doesNameExists(String name, {int id = 0}) async {
    final List<Map<String, dynamic>> result = await _database.rawQuery(
      'SELECT COUNT(*) FROM $_tableName WHERE name = ? and id <> ?',
      [name, id],
    );

    return result.first['COUNT(*)'] > 0;
  }

  /// Returns the Default [Container] Name.
  ///
  /// For example: 'Password N',
  /// where N starts from 1 and gets incremented for each password
  Future<String> getDefaultContainerName() async {
    final List<Map<String, dynamic>> commonNames = await _database.rawQuery(
      "SELECT name FROM $_tableName WHERE name LIKE 'Password %' ORDER BY name",
    );

    int n = 1;
    if (commonNames.isNotEmpty) {
      // Getting Ns from 'Password N'
      List<int> nums = [];
      for (Map<String, dynamic> row in commonNames) {
        nums.add(int.parse(row['name'].substring(9)));
      }

      // No number missing from sequence
      if (nums.last == nums.length) {
        n = nums.last + 1;

        // One number missing from sequence
      } else if (nums.last == nums.length - 1) {
        int oneToNSum = List.generate(
          nums.last,
          (index) => index + 1,
        ).reduce((value, element) => value + element);

        int currentNumSum = nums.reduce((value, element) => value + element);

        n = oneToNSum - currentNumSum;

        // Some numbers missing so finding the first missing numbers
      } else {
        for (int i = 1; i < nums.length; i++) {
          if (nums[i] - nums[i - 1] != 1) {
            n = i + 1;
            break;
          }
        }
      }
    }

    return 'Password $n';
  }

  /// Returns a list of [Container] ordered by `name`
  Future<List<Container>> getContainers() async {
    final List<Map<String, dynamic>> containers = await _database.rawQuery(
      'SELECT * FROM $_tableName ORDER BY name',
    );

    return [
      for (Map<String, dynamic> container in containers)
        Container(
          id: container['id'],
          name: container['name'],
          password: container['password'],
        )
    ];
  }

  /// Update a [Container] `password` using `name`
  Future<void> overridePassword(String name, String pass) async {
    final int changes = await _database.rawUpdate(
      'UPDATE $_tableName SET password = ? WHERE name = ?',
      [pass, name],
    );

    if (changes == 0) overridePassword(name, pass);
  }

  /// Removes a [Container] using its `id`
  Future<void> removeContainer(int id) async {
    final int changes = await _database.rawDelete(
      'DELETE FROM $_tableName WHERE id = ?',
      [id],
    );

    if (changes == 0) removeContainer(id);
  }

  /// Update a [Container]'s information
  ///
  /// Cannot update its `id`
  ///
  /// Make sure the new `name` is Unique
  Future<void> updateContainer(Container container) async {
    final int changes = await _database.rawUpdate(
      'UPDATE $_tableName SET name = ?, password = ? WHERE id = ?',
      [container.name, container.password, container.id],
    );

    if (changes == 0) updateContainer(container);
  }
}
