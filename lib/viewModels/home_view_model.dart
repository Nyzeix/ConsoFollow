import 'package:conso_follow/models/home.dart';
import 'package:conso_follow/models/user.dart';
import 'package:conso_follow/repositories/home_repository.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final IHomeRepository _homeRepository;
  List<Home> _homes = [];
  List<Home> get homes => _homes;

  User? _currentUser;


  // Gestion de status
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  HomeViewModel(this._homeRepository);

  /// Met à jour l'utilisateur courant et recharge les maisons associées.
  void setCurrentUser(User? user) {
    _currentUser = user;
    if (user == null) {
      _homes = [];
      notifyListeners();
      return;
    }
    loadHomes();
  }


  /// Charge les maisons.
  Future<void> loadHomes() async {
    if (_currentUser == null) {
      return;
    }
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _homes = await _homeRepository.getHomes(_currentUser!);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  /// Validateur de formulaire pour l'ajout d'une maison.
  String? validateHomeInputs({required String house}) {
    if (house.trim().isEmpty ) {
      return 'Ecrivez le nom de votre maison';
    }
    return null;
  }


  /// Ajoute une maison pour l'utilisateur courant.
  Future<void> addHome(Home home) async {
    if (_currentUser == null) {
      _errorMessage = 'Utilisateur non connecte.';
      notifyListeners();
      return;
    }
    await _homeRepository.insertHome(home, _currentUser!);
    await loadHomes();
  }

  /// Suppression d'une maison par son ID.
  /// Non restreint par utilisateur parce que l'accès des maisons est déjà filtré par utilisateur.
  Future<void> removeHome(int id) async {
    await _homeRepository.deleteHome(id);
    await loadHomes();
  }


  /// Récupère la liste des maisons de l'utilisateur courant.
  Future<List<Home>> fetchHomes() async {
    if (_currentUser == null) {
      _errorMessage = 'Utilisateur non connecte.';
      notifyListeners();
      return [];
    }
    try {
      return await _homeRepository.getHomes(_currentUser!);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return [];
    }
  }

}