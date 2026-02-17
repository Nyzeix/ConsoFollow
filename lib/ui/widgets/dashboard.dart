import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "Bienvenue sur votre Dashboard !\n\nIci, vous pourrez visualiser vos consommations, analyser vos données et suivre vos progrès vers une consommation plus responsable."
          "\n\nAjouter total sur le dernier mois etc..."
          "\n\nReste à faire :\n- Ajouter une maison\n- Afficher les consommations récentes\n- Afficher des graphiques de suivi",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}