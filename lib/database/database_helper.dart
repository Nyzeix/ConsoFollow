import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton : on ne peut pas instancier cette classe depuis l'extérieur
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  /// Getter asynchrone : renvoie la connexion existante ou l'initialise
  Future<Database> get database async {
    if (_database != null) return _database!; // Si la connexion à la Bdd existe, on la retourne, sinon on la créé
    _database = await _initDatabase();
    return _database!;
  }

  /// Ouverture physique du fichier et création des tables si nécessaire
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ConsoFollow.db');

    // Il existe l'argument "onUpgrade" dans openDatabse qui prends une fonction en argument.
    // Elle permet de gérer les migrations de la Bdd.
    // Je n'ai pas essayé de l'implémenter, car je ne sais pas encore bien le faire. 
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE user(id INTEGER PRIMARY KEY, name TEXT, password TEXT, salt TEXT)',
        );
        await db.execute(
          'CREATE TABLE home(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
        );
        await db.execute(
          'CREATE TABLE usertohome(id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, home_id INTEGER, FOREIGN KEY(user_id) REFERENCES user(id), FOREIGN KEY(home_id) REFERENCES home(id))',
        );
        await db.execute(
          'CREATE TABLE consumption(id INTEGER PRIMARY KEY AUTOINCREMENT, amount REAL, consumption_type TEXT, date TEXT, home_name TEXT, FOREIGN KEY(home_name) REFERENCES home(name))',
        );
      },
    );
  }
}
