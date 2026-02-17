import 'package:conso_follow/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:conso_follow/database/database_helper.dart';
import 'package:conso_follow/models/home.dart';

// L'interface
abstract class IHomeRepository {
  Future<List<Home>> getHomes(User user);
  Future<void> insertHome(Home home, User user);
  Future<void> deleteHome(int id);
}

// L'implémentation
class HomeRepository implements IHomeRepository {
  final DatabaseHelper _dbHelper;

  HomeRepository(this._dbHelper);


  /// Ajoute une maison pour l'utilisateur courant.
  @override
  Future<void> insertHome(Home home, User user) async {
    final db = await _dbHelper.database;
    // ConflictAlgorithm.replace : si l'ID existe déjà, on écrase les données
    final homeId = await db.insert(
      'home',
      home.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      'usertohome',
      {'home_id': homeId, 'user_id': user.id},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  /// Récupère la liste des maisons de l'utilisateur courant.
  @override
  Future<List<Home>> getHomes(User user) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('home', where: 'id IN (SELECT home_id FROM usertohome WHERE user_id = ?)', whereArgs: [user.id]);

    // C'est ici qu'on transforme la List<Map> (brute) en List<Home> (typée)
    return List.generate(maps.length, (i) {
      return Home.fromMap(maps[i]);
    });
  }


  /// Suppression d'une maison par son ID.
  @override
  Future<void> deleteHome(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'home',
      where: 'id = ?',
      whereArgs: [id],
    );

    await db.delete(
      'usertohome',
      where: 'home_id = ?',
      whereArgs: [id],
    );
  }
}
