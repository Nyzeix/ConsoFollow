import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:conso_follow/models/user.dart';
import 'package:conso_follow/database/database_helper.dart';


// L'interface
abstract class IAuthRepository {
  Future<User> registerAsync(String username, String password);
  Future<User> loginAsync(String username, String password);
}

class AuthRepository extends IAuthRepository {
  final DatabaseHelper _dbHelper;

  AuthRepository(this._dbHelper);

  /// Génère un salt aléatoire
  String _generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(64, (_) => random.nextInt(256));
    return base64Encode(saltBytes);
  }

  /// Hash le mot de passe avec le salt
  String _hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Inscription
  @override
  Future<User> registerAsync(String username, String password) async {
    final db = await _dbHelper.database;

    // Vérifie si l'utilisateur existe déjà
    final existingUsers = await db.query(
      'user',
      where: 'name = ?',
      whereArgs: [username],
    );

    if (existingUsers.isNotEmpty) {
      throw Exception("L'utilisateur existe déjà.");
    }

    // Génère le salt et hash le mot de passe
    final salt = _generateSalt();
    final hashedPassword = _hashPassword(password, salt);

    final insertedUserId = await db.insert('user', {
      'name': username,
      'password': hashedPassword,
      'salt': salt,
    });

    return User(
      id: insertedUserId.toString(),
      username: username,
      password: hashedPassword,
      salt: salt,
    );
  }

  /// Connexion
  @override
  Future<User> loginAsync(String username, String password) async {
    final db = await _dbHelper.database;

    // Récupère l'utilisateur de la base de données
    final users = await db.query(
      'user',
      where: 'name = ?',
      whereArgs: [username],
    );

    if (users.isEmpty) {
      throw Exception("Identifiants incorrects.");
    }

    // Utilise fromMap pour créer l'objet User
    final user = User.fromMap(users.first);

    // Hash le mot de passe fourni avec le salt stocké
    final providedPasswordHash = _hashPassword(password, user.salt!);

    // Vérifie si les hash correspondent
    if (providedPasswordHash != user.password) {
      throw Exception("Identifiants incorrects.");
    }

    // Connexion réussie, retourne l'utilisateur (sans le mot de passe hashé pour plus de sécurité)
    return User(
      id: user.id,
      username: user.username,
      password: '',
      salt: user.salt,
    );
  }
}