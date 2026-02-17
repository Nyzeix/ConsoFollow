
import 'package:conso_follow/ui/screen/main_scaffold.dart';
import 'package:conso_follow/viewModels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();


  /// Affiche une erreur en SnackBar.
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating, 
      ),
    );
  }


  /// Nettoie les contrôleurs de texte pour éviter les fuites de mémoire.
  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }


  /// Le build de la page d'authentification. 
  /// Affiche un formulaire de connexion/inscription ou le MainScaffold si l'utilisateur est déjà connecté.
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    // Connecté, on affiche le MainScaffold
    if (vm.currentUser != null) {
      return MainScaffold();
    }


    // Connexion en cours
    return Scaffold(
      appBar: AppBar(title: Text("Authentification")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              TextField(
                controller: _usernameCtrl,
                decoration: const InputDecoration(
                  labelText: "Nom d'utilisateur",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),

            const SizedBox(height: 16),

            TextField(
              controller: _passwordCtrl,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),

            const SizedBox(height: 24),

            if (vm.isLoading) const Center(child: CircularProgressIndicator())
            else Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Connexion
                ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: () async {
                    final username = _usernameCtrl.text;
                    final error = await vm.login(username, _passwordCtrl.text);
                    
                    // Si une erreur est renvoyée, on l'affiche en SnackBar
                    if (error != null && context.mounted) {
                      // Ignorer les erreurs liées au Keychain (iOS) qui ne sont pas critiques pour l'utilisateur
                      // Pour passer outre cette erreur, il faut devenir développeur Apple.
                      if (!error.contains("Code: -34018")) {
                        _showError(error);
                      }
                    }
                  },
                  child: const Text("S'authentifier"),
                ),
                
                // Espacement simple entre les boutons
                const SizedBox(height: 10),

                // Inscription
                OutlinedButton(
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: () async {
                    final error = await vm.register(_usernameCtrl.text, _passwordCtrl.text);
                    
                    if (error != null && context.mounted) {
                      // Ignorer les erreurs liées au Keychain (iOS) qui ne sont pas critiques pour l'utilisateur
                      // Pour passer outre cette erreur, il faut devenir développeur Apple.
                      if (!error.contains("Code: -34018")) {
                        _showError(error);
                      }
                    }
                  },
                  child: const Text("S'inscrire"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
