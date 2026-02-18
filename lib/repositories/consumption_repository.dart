import 'package:sqflite/sqflite.dart';
import 'package:conso_follow/database/database_helper.dart';
import 'package:conso_follow/models/consumption.dart';
import 'package:conso_follow/utils/consumption_type_enum.dart';

// L'interface
abstract class IConsumptionRepository {
  Future<List<Consumption>> getConsumptions(String userId);
  Future<List<Consumption>> getConsumptionsByType(
    String userId,
    ConsumptionType type,
  );
  Future<void> insertConsumption(Consumption consumption);
  Future<void> deleteConsumption(int id);
  Future<void> updateConsumption(Consumption consumption);
}

// L'implémentation
class ConsumptionRepository implements IConsumptionRepository {
  final DatabaseHelper _dbHelper;

  ConsumptionRepository(this._dbHelper);

  /// Ajoute une consommation pour l'utilisateur courant.
  @override
  Future<void> insertConsumption(Consumption consumption) async {
    final db = await _dbHelper.database;
    // ConflictAlgorithm.replace : si l'ID existe déjà, on écrase les données
    await db.insert(
      'consumption',
      consumption.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  /// Récupère la liste des consommations de l'utilisateur courant.
  @override
  Future<List<Consumption>> getConsumptions(String userId) async {
    final db = await _dbHelper.database;
    // rawQuery car les conditions de récupérations sont plus complexes (jointures)
    // On récupère les consommations liées aux maisons, elles mêmes liées  à l'utilisateur courant.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT c.* FROM consumption c
      INNER JOIN home h ON c.home_name = h.name
      INNER JOIN usertohome uth ON h.id = uth.home_id
      WHERE uth.user_id = ?
      ''',
      [userId],
    );

    return List.generate(maps.length, (i) {
      return Consumption.fromMap(maps[i]);
    });
  }


  /// Récupère les consommations de l'utilisateur courant filtrées par type.
  @override
  Future<List<Consumption>> getConsumptionsByType(
    String userId,
    ConsumptionType type,
  ) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT c.* FROM consumption c
      INNER JOIN home h ON c.home_name = h.name
      INNER JOIN usertohome uth ON h.id = uth.home_id
      WHERE uth.user_id = ? AND c.consumption_type = ?
      ''',
      [userId, type.unit],
    );

    return List.generate(maps.length, (i) {
      return Consumption.fromMap(maps[i]);
    });
  }


  /// Suppression d'une consommation par son ID.
  @override
  Future<void> deleteConsumption(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'consumption',
      where: 'id = ?', // Clause WHERE sécurisée contre les injections SQL
      whereArgs: [id],
    );
  }

  /// Mise à jour d'une consommation.
  @override
  Future<void> updateConsumption(Consumption consumption) async {
    final db = await _dbHelper.database;
    await db.update(
      'consumption',
      consumption.toMap(),
      where: 'id = ?',
      whereArgs: [consumption.id],
    );
  }
}
