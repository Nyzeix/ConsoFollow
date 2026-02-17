import 'package:conso_follow/models/home.dart';
import 'package:conso_follow/ui/widgets/cancel_add_standard_row.dart';
import 'package:conso_follow/ui/widgets/dashboard.dart';
import 'package:conso_follow/viewModels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Row(children: [const Text("Ajouter"), const SizedBox(width: 8), const Icon(Icons.house)],),
        tooltip: "Ajouter une maison",
        isExtended: true, 
        onPressed: () {
          showAddHouseDialog(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Dashboard(),
            ],
          ),
        ),
      ),
    );
  }

    /// Boite de dialogue pour ajouter une nouvelle maison.
  void showAddHouseDialog(BuildContext context) {
    final houseInputController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Ajouter une maison',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                  TextField(
                    controller: houseInputController,
                    decoration: const InputDecoration(labelText: 'Maison'),
                  ),

                const SizedBox(height: 16),

                CancelAddStandardRow(
                  onPressedAdd: () {
                    final validationError = context
                      .read<HomeViewModel>()
                      .validateHomeInputs(
                        house: houseInputController.text,
                      );
                    if (validationError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(validationError)),
                      );
                      return;
                    }
                    final newHome = Home(
                      name: houseInputController.text,
                    );
                    context
                      .read<HomeViewModel>()
                      .addHome(newHome);
                    Navigator.pop(context);
                  },
                  onPressedCancel: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}