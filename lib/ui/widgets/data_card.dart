import 'package:conso_follow/models/consumption.dart';
import 'package:flutter/material.dart';

class DataCard extends StatefulWidget {
  final Consumption consumption;

  const DataCard({super.key, required this.consumption});

  @override
  State<DataCard> createState() => _DataCardState();
}

class _DataCardState extends State<DataCard> {
  late DateTime parsedDate;

  @override
  void initState() {
    super.initState();
    // Convertit la date stockée en String en un objet DateTime à la volée pour faciliter son affichage
    parsedDate = DateTime.parse(widget.consumption.date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Date et heure
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  "${parsedDate.hour}:${parsedDate.minute.toString().padLeft(2, '0')}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),

            const Spacer(),

            // Valeur de la consommation
            Text(
              "${widget.consumption.amount} ${widget.consumption.consumptionType}",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Spacer(),

            // Maison associée
            Text(
              widget.consumption.homeName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        )
      ),
    );
  }
}

/** Format de la DataCard :
 * A gauche de la DataCard, on écrit la date de la consommation (Jour, mois, année).
 * En dessous de la date, on ajoute l'horaire de la consommation (Heure, minute).
 * Au centre, on écrit la valeur de la consommation avec son unité, mis en avant.
 * A droite, le nom de la maison associée à la consommation
 */