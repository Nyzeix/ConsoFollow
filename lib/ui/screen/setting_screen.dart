import 'package:conso_follow/controller/notifications_controller.dart';
import 'package:conso_follow/controller/theme_controller.dart';
import 'package:conso_follow/ui/widgets/setting_area.dart';
import 'package:conso_follow/ui/widgets/setting_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
  final ThemeController themeController = context.watch<ThemeController>();
  final NotificationsController notificationController = context.watch<NotificationsController>();
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SettingArea(
              title: "Notifications (WIP)",
              folded: true,
              leading: Icon(Icons.notifications_outlined),
              trailing: Switch( value: false,
                                onChanged: (value) {}),
              children: [
                Text("Choix des notifications à recevoir, définition d'à quelle limite recevoir une notification pour chaque catégorie"),
              ]),
            SettingArea(
              title: "Apparence",
              folded: false,
              leading: Icon(Icons.palette_outlined),
              children: [
                SettingRow(
                  title: "Thème sombre",
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                  isEnabled: themeController.isDarkMode,
                  valueChanged: (value) => themeController.toggleTheme()
                ),
              ]
            ),

            //
          ],
        )
      ),
    );
  }
}
