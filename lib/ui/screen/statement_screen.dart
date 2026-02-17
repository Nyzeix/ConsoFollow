import 'package:conso_follow/models/consumption.dart';
import 'package:conso_follow/ui/widgets/cancel_add_standard_row.dart';
import 'package:conso_follow/ui/widgets/data_card.dart';
import 'package:conso_follow/ui/widgets/statement_header.dart';
import 'package:conso_follow/utils/consumption_type_enum.dart';
import 'package:conso_follow/viewModels/home_view_model.dart';
import 'package:conso_follow/viewModels/statement_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class StatementScreen extends StatefulWidget {
  const StatementScreen({super.key});

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  bool _electricityExpanded = true;
  bool _waterExpanded = true;
  bool _gasExpanded = true;

  // Map de données qui trie les consommations par type
  late Future<Map<ConsumptionType, List<Consumption>>> _consumptionsFuture;

  /// Récupère les conso par type et les trie dans une map.
  Future<Map<ConsumptionType, List<Consumption>>> _fetchConsumptionsByType() async {
    final vm = context.read<StatementViewModel>();
    final results = await Future.wait([
      vm.fetchConsumptionsByType(ConsumptionType.electricity),
      vm.fetchConsumptionsByType(ConsumptionType.water),
      vm.fetchConsumptionsByType(ConsumptionType.gas),
    ]);

    return {
      ConsumptionType.electricity: results[0],
      ConsumptionType.water: results[1],
      ConsumptionType.gas: results[2],
    };
  }

  @override
  void initState() {
    super.initState();
    _consumptionsFuture = _fetchConsumptionsByType();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StatementViewModel>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: "Ajouter",
        isExtended: true,
        child: const Icon(Icons.add),
        onPressed: () {
          showAddConsumptionDialog(context);
        },
      ),
      body: FutureBuilder<Map<ConsumptionType, List<Consumption>>>(
        future: _consumptionsFuture,
        builder: (context, snapshot) {
          // Show loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          
          // Show error message with retry button
          if (snapshot.hasError || vm.errorMessage != null) {
            print("Error fetching consumptions: ${snapshot.error}");
            print("ViewModel error message: ${vm.errorMessage}");
            final errorMsg = vm.errorMessage ?? snapshot.error.toString();
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48,),
                  const SizedBox(height: 16),
                  Text(
                    "Erreur : $errorMsg",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _consumptionsFuture = _fetchConsumptionsByType();
                      });
                    },
                    child: const Text("Réessayer"),
                  ),
                ],
              ),
            );
          } 
          
          // Show data or empty state
          if (snapshot.hasData) {
            final consumptionsByType = snapshot.data!;
            final electricity =
                consumptionsByType[ConsumptionType.electricity] ?? [];
            final water = consumptionsByType[ConsumptionType.water] ?? [];
            final gas = consumptionsByType[ConsumptionType.gas] ?? [];
            final totalCount = electricity.length + water.length + gas.length;
            if (totalCount == 0) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined, size: 48),
                    SizedBox(height: 16),
                    Text("Aucune donnée."),
                  ],
                ),
              );
            } else {
              return success(electricity, water, gas);
            }
          } else {
            return const Text("Erreur dans la récupération des données. (E1)");
          }
        },
      ),
    );
  }

  Widget success(
    List<Consumption> electricity,
    List<Consumption> water,
    List<Consumption> gas,
  ) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StatementHeader(
              title: "Electricité",
              icon: Icons.bolt,
              isExpanded: _electricityExpanded,
              onTap: () {
                setState(() {
                  _electricityExpanded = !_electricityExpanded;
                });
              },
            ),
            if (_electricityExpanded) ...electricity.map((c) => Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: DataCard(consumption: c))),
            const Divider(thickness: 2, height: 40),
            StatementHeader(
              title: "Eau",
              icon: Icons.water_drop,
              isExpanded: _waterExpanded,
              onTap: () {
                setState(() {
                  _waterExpanded = !_waterExpanded;
                });
              },
            ),
            if (_waterExpanded) ...water.map((c) => Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: DataCard(consumption: c))),
            const Divider(thickness: 2, height: 40),
            StatementHeader(
              title: "Gaz",
              icon: Icons.gas_meter,
              isExpanded: _gasExpanded,
              onTap: () {
                setState(() {
                  _gasExpanded = !_gasExpanded;
                });
              },
            ),
            if (_gasExpanded) ...gas.map((c) => Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: DataCard(consumption: c))),
          ],
        ),
      ),
    );
  }

  /// Boite de dialogue pour ajouter une nouvelle consommation.
  void showAddConsumptionDialog(BuildContext context) {
    final typeController = TextEditingController();
    final amountController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final homeController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Ajouter une consommation',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    items: [
                      MapEntry('Electricité', ConsumptionType.electricity.unit),
                      MapEntry('Eau', ConsumptionType.water.unit),
                      MapEntry('Gaz', ConsumptionType.gas.unit),
                    ]
                      .map((entry) => DropdownMenuItem(
                        value: entry.value,
                        child: Text(entry.key),
                      ))
                      .toList(),
                    onChanged: (value) {
                      typeController.text = value ?? '';
                    },
                    decoration: const InputDecoration(labelText: 'Type'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(labelText: 'Quantité'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: typeController,
                          readOnly: true,
                          decoration: const InputDecoration(labelText: 'Type'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final now = DateTime.now();
                      final initialDate = dateController.text.isNotEmpty
                          ? selectedDate ?? now
                          : now;
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        selectedDate = picked;
                        dateController.text =
                            '${picked.year.toString().padLeft(4, '0')}-'
                            '${picked.month.toString().padLeft(2, '0')}-'
                            '${picked.day.toString().padLeft(2, '0')}';
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: timeController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Heure',
                      suffixIcon: Icon(Icons.schedule),
                    ),
                    onTap: () async {
                      final now = TimeOfDay.fromDateTime(DateTime.now());
                      final initialTime = selectedTime ?? now;
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: initialTime,
                      );
                      if (picked != null) {
                        selectedTime = picked;
                        timeController.text =
                            '${picked.hour.toString().padLeft(2, '0')}'
                            ':${picked.minute.toString().padLeft(2, '0')}';
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    items: [
                      for (var home in context.watch<HomeViewModel>().homes)
                        home.name,
                    ]
                      .map((homeName) => DropdownMenuItem(
                        value: homeName,
                        child: Text(homeName),
                      ))
                      .toList(),
                    onChanged: (value) {
                      homeController.text = value ?? '';
                    },
                    decoration: const InputDecoration(labelText: 'Maison'),
                  ),

                  const SizedBox(height: 16),

                  // Ligne de boutons Ajouter / Annuler standardisé
                  CancelAddStandardRow(
                     onPressedAdd: () async {
                      final validationError = context
                          .read<StatementViewModel>()
                          .validateConsumptionInputs(
                            type: typeController.text,
                            amountText: amountController.text,
                            dateText: dateController.text,
                            timeText: timeController.text,
                            homeText: homeController.text,
                          );
                      if (validationError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(validationError)),
                        );
                        return;
                      }
                      final now = DateTime.now();
                      final date = selectedDate ?? now;
                      final time = selectedTime ?? TimeOfDay.fromDateTime(now);
                      final combinedDateTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                      final amount = double.tryParse(amountController.text) ?? 0;
                      final newConsumption = Consumption(
                        consumptionType: typeController.text,
                        amount: amount,
                        date: combinedDateTime.toIso8601String(),
                        homeName: homeController.text,
                      );
                      await context
                          .read<StatementViewModel>()
                          .addConsumption(newConsumption);
                      setState(() {
                        _consumptionsFuture = _fetchConsumptionsByType();
                      });
                      Navigator.pop(context);
                    },
                    onPressedCancel: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
