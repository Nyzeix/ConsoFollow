# ConsoFollow
Application de gestion de sa consommation énergétique. Réalisé en 3J pour le partiel 1 M1 LDFS. Auteur: S. Nicolas

# Structure
* **lib/** contient le code 
* **lib/databse** contient la racine du code pour la création et l'accès à la base de données.
* **lib/ui/** contient toutes les interfaces graphiques de l'application
  * **lib/ui/widgets/** contient tout les widgets personnalisés de l'application (Par exemple: le widget répété d'une consommation)
  * **lib/ui/screens/** contient tout les écrans
* **lib/models/** contient les models des objets. 
* **lib/repositories/** contient les interfaces et leurs implémentations. Fait le lien viewModel - Database.
* **lib/resources/** contient des ressources générales de l'application. En l'occurence, le thème.
* **lib/utils/** contient des fichiers, fonctions, Enumerations qui peuvent s'avérer utile à travers le projet.
* **lib/viewModels/** contient les différents viewModels de l'application (Fait la liaison entre Front-End (UI) et Back-End (Database))

## Notes
Tous les textes sont codés en dur dans l'application en français.

En Flutter, il n'y a pas d'indication de "niveau de protection" d'une variable (private, protected, public).  
Le nom de la variable définie de lui même son niveau d'accessibilité. Si la variable commence avec un "\_", alors elle est privée.  
C'est pour cela que vous trouverez souvent des variables commencant avec un "\_" ainsi qu'une seconde nommé identiquement, sans "\_", avec un getter personnalisé.


Vous appercevrez des classes étendre ```extends ChangeNotifier```. Cela permet de d'ajouter les fonctionnalitées de mise à jour de l'UI, lorsque que la fonction ```notifyListeners``` est appelée.  

Dans chaque objet de classe dans **lib/models/**, il y a des fonctions:
```
  Map<String, dynamic> Object.toMap() {...}
factory Consumption.fromMap(Map<String dynamic> map) {...}
```
Ces fonctions permettent la conversion entre l'objet lui-même et sa copie nécessaire pour le mettre en base de données.  


## Installation de l'application
Dans la section Release, vous trouverez, dans la dernière release, un fichier Zip contenant le fichier de l'application installable et exécutable pour Android (.apk) et macOS (.dmg).  

## Récupération du dépot
Cloner le dépot sur votre ordinateur.  
[Installer VSCode](https://code.visualstudio.com/).
[Installer les extensions Flutter dans VSCode](https://docs.flutter.dev/install/with-vs-code).
Optionel: Installer les outils de simulation pour votre plateforme favorite.
