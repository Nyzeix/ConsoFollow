import 'package:conso_follow/models/consumption.dart';
import 'package:conso_follow/models/user.dart';
import 'package:conso_follow/repositories/consumption_repository.dart';
import 'package:conso_follow/utils/consumption_type_enum.dart';
import 'package:flutter/material.dart';


/// Ce viewModel est globalement similaire au HomeViewModel.

class StatementViewModel extends ChangeNotifier {
  final IConsumptionRepository _consumptionRepository;
  List<Consumption> _consumptions = [];
  List<Consumption> get consumptions => _consumptions;

  User? _currentUser;

  // Gestion de status
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  StatementViewModel(this._consumptionRepository);

  /// Met à jour l'utilisateur courant et recharge les consommations associées.
  void setCurrentUser(User? user) {
    _currentUser = user;
    if (user == null) {
      _consumptions = [];
      notifyListeners();
      return;
    }
    loadConsumptions();
  }


  /// Charge les consommations.
  Future<void> loadConsumptions() async {
    if (_currentUser == null) {
      return;
    }
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _consumptions = await _consumptionRepository.getConsumptions(_currentUser!.id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  /// Validateur de formulaire pour l'ajout d'une consommation.
  /// Founir les arguments entre {} permet de les rendre nommées.
  /// L'argument "required" rend l'argument obligatoire.
  String? validateConsumptionInputs({
    required String type,
    required String amountText,
    required String dateText,
    required String timeText,
    required String homeText,
  }) {
    if (type.trim().isEmpty ||
        amountText.trim().isEmpty ||
        dateText.trim().isEmpty ||
        timeText.trim().isEmpty ||
        homeText.trim().isEmpty) {
      return 'Tous les champs sont obligatoires.';
    }
    return null;
  }


  /// Ajoute une consommation pour l'utilisateur courant.
  Future<void> addConsumption(Consumption consumption) async {
    await _consumptionRepository.insertConsumption(consumption);
    await loadConsumptions();
  }


  /// Suppression d'une consommation par son ID.
  Future<void> deleteConsumption(int id) async {
    await _consumptionRepository.deleteConsumption(id);
    await loadConsumptions();
  } 

  /// Récupère la liste des consommations de l'utilisateur courant.
  Future<List<Consumption>> fetchConsumptions() async {
    if (_currentUser == null) {
      _errorMessage = 'Utilisateur non connecté.';
      notifyListeners();
      return [];
    }
    try {
      return await _consumptionRepository.getConsumptions(_currentUser!.id);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return [];
    }
  }

  /// Récupère les consommations de l'utilisateur courant filtrées par type.
  Future<List<Consumption>> fetchConsumptionsByType(ConsumptionType type) async {
    if (_currentUser == null) {
      _errorMessage = 'Utilisateur non connecté.';
      notifyListeners();
      return [];
    }
    try {
      return await _consumptionRepository.getConsumptionsByType(
        _currentUser!.id,
        type,
      );
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return [];
    }
  }
}