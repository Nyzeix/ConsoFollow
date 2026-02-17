import 'package:conso_follow/database/database_helper.dart';
import 'package:conso_follow/repositories/consumption_repository.dart';
import 'package:conso_follow/repositories/home_repository.dart';
import 'package:conso_follow/repositories/authentification_repository.dart';
import 'package:conso_follow/ui/screen/auth_screen.dart';
import 'package:conso_follow/viewModels/auth_view_model.dart';
import 'package:conso_follow/viewModels/home_view_model.dart';
import 'package:conso_follow/viewModels/statement_view_model.dart';
import 'package:flutter/material.dart';
import 'package:conso_follow/resources/theme.dart';
import 'package:provider/provider.dart';

/// Point d'entrée.
/// On y fait l'injection de dépendances
/// Et on lance la fonction "runApp" qui démarre l'application
/// 
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // Ici se fait l'injection de dépendances pour les ViewModels.
    MultiProvider(
      providers: [
        // Database
        Provider(create: (_) => DatabaseHelper()),

        // Authentification
        Provider<IAuthRepository>(
          create: (context) => AuthRepository(context.read<DatabaseHelper>()),
        ),

        // Repositories
        Provider<IConsumptionRepository>(
          create: (context) => ConsumptionRepository(context.read<DatabaseHelper>()),
        ),
        Provider<IHomeRepository>(
          create: (context) => HomeRepository(context.read<DatabaseHelper>()),
        ),

        // ViewModels
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(
            context.read<IAuthRepository>(),
          )..checkLastUser(), // Dès que l'injection de dépendance est terminé, on appelle la fonction "checkLastUser""
        ),

        // ChangeNotifierProxyProvider permet d'écouter les changements.
        // C'est à dire que dès que le "currentUser" évolue, le HomeViewModel et le StatementViewModel sont notifiés
        // Et à chaque changement, la fonction "update" est appelé.
        // Dans cette fonction, on y met à jour le "currentUser".
        ChangeNotifierProxyProvider<AuthViewModel, HomeViewModel>(
          create: (context) => HomeViewModel(context.read<IHomeRepository>()),
          update: (context, authViewModel, homeViewModel) {
            final viewModel =
                homeViewModel ?? HomeViewModel(context.read<IHomeRepository>());
            viewModel.setCurrentUser(authViewModel.currentUser);
            return viewModel;
          },
        ),


        ChangeNotifierProxyProvider<AuthViewModel, StatementViewModel>(
          create: (context) => StatementViewModel(context.read<IConsumptionRepository>()),
          update: (context, authViewModel, statementViewModel) {
            final viewModel =
                statementViewModel ?? StatementViewModel(context.read<IConsumptionRepository>());
            viewModel.setCurrentUser(authViewModel.currentUser);
            return viewModel;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

/// Initialisation du thème et lancement de la page d'accueil (Auth).
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Custom Theme created with Material Theme Builder
    MaterialTheme theme = MaterialTheme();

    return MaterialApp(
      title: 'ConsoFollow',
      theme: theme.light(),
      home: const AuthScreen(),
    );
  }
}