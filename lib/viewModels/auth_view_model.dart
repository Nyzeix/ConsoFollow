import 'package:conso_follow/models/user.dart';
import 'package:conso_follow/repositories/authentification_repository.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final IAuthRepository _authService;

  bool _isLoading = false;
  User? _currentUser;

  bool get isLoading => _isLoading;
  User? get currentUser => _currentUser;

  AuthViewModel(this._authService); 

  /// Vérifie s'il existe un utilisateur précédemment connecté et met à jour l'état en conséquence.
  Future<void> checkLastUser() async {
    notifyListeners();
  }

  /// Inscription d'un nouvel utilisateur. Retourne un message d'erreur en cas d'échec, ou null en cas de succès.
  Future<String?> register(String username, String password) async {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      return "Veuillez remplir tous les champs.";
    }
    _setLoading(true);
    try {
      _currentUser = await _authService.registerAsync(username, password);
      return null; // Succès
    } catch (e) {
      return e.toString().replaceAll("Exception: ", "");
    } finally {
      _setLoading(false);
    }
  }

  /// Connexion d'un utilisateur existant. Retourne un message d'erreur en cas d'échec, ou null en cas de succès.
  Future<String?> login(String username, String password) async {
    if (password.trim().isEmpty) {
      return "Veuillez entrer votre mot de passe.";
    }
    //if (!isReturningUser && username.trim().isEmpty) {
    if (username.trim().isEmpty) {
      return "Veuillez entrer votre nom d'utilisateur.";
    }

    _setLoading(true);
    try {
      _currentUser = await _authService.loginAsync(username, password);
      return null; // Succès
    } catch (e) {
      return e.toString().replaceAll("Exception: ", "");
    } finally {
      _setLoading(false);
    }
  }


  /// Permet à l'utilisateur de se déconnecter et de supprimer les informations de connexion stockées, forçant ainsi une nouvelle authentification complète lors de la prochaine utilisation.
  Future<void> switchAccount() async {
    _currentUser = null;
    notifyListeners();
  }
  
  /// Permet à l'utilisateur de se déconnecter sans supprimer les informations de connexion stockées, permettant une reconnexion rapide avec le même compte.
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  /// Méthode utilitaire pour mettre à jour l'état de chargement et notifier les écouteurs de changement.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
