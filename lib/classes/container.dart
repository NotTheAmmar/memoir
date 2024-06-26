/// Stores Password Information
class Container {
  /// Unique Identifier
  final int _id;

  /// Account Name
  final String _name;

  /// Password of Account [_name]
  final String _password;

  Container({required int id, required String name, required String password})
      : _name = name,
        _password = password,
        _id = id;

  /// Unique Identifier for Container
  int get id => _id;

  /// Container | Account Name
  String get name => _name;

  /// Password of [name]
  String get password => _password;

  /// Json Representation of Container
  ///
  /// Doesn't Include Container [id]
  ///
  /// Uses `name` key for [name] and `password` key for [password]
  Map<String, String> toJson() => {'name': _name, 'password': _password};
}
