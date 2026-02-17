import 'package:conso_follow/ui/widgets/setting_area.dart';
import 'package:conso_follow/ui/widgets/setting_row.dart';
import 'package:conso_follow/viewModels/home_view_model.dart';
import 'package:conso_follow/resources/theme.dart';
import 'package:conso_follow/ui/widgets/multilines_chart.dart';
import 'package:conso_follow/utils/consumption_type_enum.dart';
import 'package:conso_follow/viewModels/statement_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Etat des paramètres d'affichage
  bool isElecEnabled = true;
  bool isWaterEnabled = true;
  bool isGasEnabled = true;

  // Nomnbre de jours à afficher
  int _selectedDays = 30;
  final List<int> _dayOptions = const [7, 14, 30, 60, 90];

  // Récupère le viewmodel pour les fonctions de filtrage
  StatementViewModel get vm => context.read<StatementViewModel>();



  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Bienvenue sur votre Dashboard !\n\nIci, vous pourrez visualiser vos consommations, analyser vos données et suivre vos progrès vers une consommation plus responsable.",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Nombre de jours : '),
                DropdownButton<int>(
                  value: _selectedDays,
                  items: _dayOptions
                      .map(
                        (day) => DropdownMenuItem<int>(
                          value: day,
                          child: Text('$day'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedDays = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Consumer2 permet d'écouter les changements provenants de deux viewModels différents
            // Néanmoins, il fonctionne de la même manière qu'un FutureBuilder,
            // Sauf qu'au lieu d'écouter un Future, il écoute les changements de viewModels.
            Consumer2<HomeViewModel, StatementViewModel>(
              builder: (context, homeViewModel, statementViewModel, _) {
                if (homeViewModel.isLoading || statementViewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (homeViewModel.errorMessage != null) {
                  return Text('Erreur maisons : ${homeViewModel.errorMessage}');
                }

                if (statementViewModel.errorMessage != null) {
                  return Text('Erreur consommations : ${statementViewModel.errorMessage}');
                }

                final homes = homeViewModel.homes;
                if (homes.isEmpty) {
                  return const Text('Aucune maison enregistrée.');
                }

                final allowedHomeNames = homes.map((home) => home.name).toSet();
                final userConsumptions = statementViewModel.consumptions
                    .where((consumption) => allowedHomeNames.contains(consumption.homeName))
                    .toList();

                return Column(
                  children: homes.map((home) {
                    final homeConsumptions = vm.filterBySelectedDays(
                      userConsumptions
                          .where((consumption) => consumption.homeName == home.name)
                          .toList(),
                      _selectedDays,
                    );

                    // On prépare la série de données à afficher.
                    final series = [
                      if (isElecEnabled) ...[vm.filterByType(homeConsumptions, ConsumptionType.electricity)],
                      if (isWaterEnabled) ...[vm.filterByType(homeConsumptions, ConsumptionType.water)],
                      if (isGasEnabled) ...[vm.filterByType(homeConsumptions, ConsumptionType.gas)],
                    ];

                    // On adapte la liste de couleurs en conséquence
                    final lineColors = [
                      if (isElecEnabled) MaterialTheme.electricity.value,
                      if (isWaterEnabled) MaterialTheme.water.value,
                      if (isGasEnabled) MaterialTheme.gas.value,
                    ];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        ExpansionTile(
                          initiallyExpanded: true,
                          title: Text(
                            home.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          children: [
                            ConsumptionMultiLineChart(
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              series: series,
                              lineColors: lineColors,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
            ),

            SettingArea(
              title: "Filtre par type", 
              color: Theme.of(context).colorScheme.surface,
              children: [
                SettingRow(title: "Electricité", isEnabled: isElecEnabled, valueChanged: (value) { setState(() { isElecEnabled = value; }); }),
                SettingRow(title: "Eau", isEnabled: isWaterEnabled, valueChanged: (value){ setState(() { isWaterEnabled = value; }); }),
                SettingRow(title: "Gaz", isEnabled: isGasEnabled, valueChanged: (value){ setState(() { isGasEnabled = value; }); }),
              ]
            ),
          ],
        ),
      ),
    );
  }
}