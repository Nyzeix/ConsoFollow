import 'package:conso_follow/models/nav_destination.dart';
import 'package:conso_follow/ui/screen/auth_page.dart';
import 'package:conso_follow/ui/screen/dashboard_screen.dart';
import 'package:conso_follow/ui/screen/statement_screen.dart';
import 'package:conso_follow/viewModels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


/// MainScaffold est la structure de base de l'application une fois connecté.
/// Elle gère la navigation entre les différentes pages (Dashboard, Relevé, Paramètre) et adapte son affichage en fonction de la taille de l'écran (mobile vs desktop).
/// Elle génère uniquement l'AppBar et la Navigation (BottomNavigationBar pour mobile, NavigationRail pour desktop).
/// Elle ne contient pas le contenu de chaque page. Elle se contente de l'appeler.
/// 
/// A titre indicatif, un "StatefulWidget" permet de gérer un état local (ici, la page sélectionnée) et de redessiner l'interface en conséquence lorsque son état interne évolue.
/// A contrario, un "StatelessWidget" est immuable et ne peut pas changer d'état après sa création. Il est utilisé pour des composants qui ne nécessitent pas de gestion d'état local.
/// Ce dernier est recréer QUE lorsque son parent est redessiné.
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  String selectedPageLabel = "";
  int currentIndex = 0;

  late final List<NavDestination> destinations;

  @override
  void initState() {
    super.initState();
    // Initialisation des destinations
    destinations = [
      NavDestination(
        label: "Dashboard",
        iconSelected: Icons.dashboard,
        iconUnselected: Icons.dashboard_outlined,
        screen: const DashboardScreen(),
      ),
      NavDestination(
        label: "Relevé",
        iconSelected: Icons.text_snippet,
        iconUnselected: Icons.text_snippet_outlined,
        screen: const StatementScreen(),
      ),
      NavDestination(
        label: "Paramètre",
        iconSelected: Icons.settings,
        iconUnselected: Icons.settings_outlined,
        screen: const Placeholder(),
      ),
    ];
    
    // Initialisation par défaut
    selectedPageLabel = destinations[0].label;
    currentIndex = 0;
  }


  void _onDestinationSelected(int index) {
    setState(() {
      currentIndex = index;
      selectedPageLabel = destinations[index].label;
    });
  }


  @override
  Widget build(BuildContext context) {

    IndexedStack pages = IndexedStack(
      index: currentIndex,
      children: destinations.map((dest) => dest.screen).toList(),
    );

    // LayoutBuilder pour adapter l'affichage en fonction de la taille de l'écran
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _buildMobileLayout(destinations, pages);
        } else {
          return _buildDesktopLayout(destinations, pages, constraints.maxWidth);
        }
      },
    );
  }


  /// AppBar commune aux deux layouts
  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text("ConsoFollow - $selectedPageLabel"),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: IconButton(
            icon: const Icon(Icons.replay_outlined),
            tooltip: "Actualiser",
            onPressed: () {
              // TODO: Action du bouton de rechargement des données
              // Ajouter un controller
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () {
              context.read<AuthViewModel>().logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AuthPage()),
              );
            },
          ),
        ),
      ],
    );
  }


  /// Affichage pour les écrans plus petits (mobile)
  Widget _buildMobileLayout(List<NavDestination> navDestinations, IndexedStack pages) {
    return Scaffold(
      body: pages,
      appBar: _appBar(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
        unselectedItemColor: Theme.of(context).colorScheme.onSecondaryContainer,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        items: [
          ...navDestinations.map((dest) => dest.toNavigationBarItem()),
        ],
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            _onDestinationSelected(value);
          });
        },
      ),
    );
  }

  /// Affichage pour les écrans plus larges (tablettes, desktop)
  Widget _buildDesktopLayout(List<NavDestination> navDestinations, IndexedStack pages, width) {
    return Scaffold(
      appBar: _appBar(),
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              extended: width >= 1000,
              destinations: [
                ...navDestinations.map((dest) => dest.toNavigationRailDestination()),
              ],
              selectedIndex: currentIndex,
              onDestinationSelected: (value) {
                setState(() {
                  _onDestinationSelected(value);
                });
              },
            ),
          ), 
          Expanded(child: pages),
        ],
      ),
    );
  }
}
