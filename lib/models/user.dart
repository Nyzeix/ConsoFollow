class User {
  final String id;
  final String username;
  final String password;
  final String? salt;

  User({
    required this.id,
    required this.username,
    required this.password,
    this.salt,
  });

  // Mandatory function for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': int.parse(id),
      'name': username,
      'password': password,
      'salt': salt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'].toString(),
      username: map['name'] as String,
      password: map['password'] as String,
      salt: map['salt'] as String?,
    );
  }
}
