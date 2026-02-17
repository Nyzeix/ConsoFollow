import 'package:flutter/material.dart';

class CancelAddStandardRow extends StatefulWidget {
  final VoidCallback? onPressedCancel;
  final VoidCallback? onPressedAdd;
  const CancelAddStandardRow({super.key, this.onPressedCancel, required this.onPressedAdd});


  @override
  State<CancelAddStandardRow> createState() => _CancelAddStandardRowState();
}

class _CancelAddStandardRowState extends State<CancelAddStandardRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Bouton annuler
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),

        const SizedBox(width: 10),

        // Bouton ajouter
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          onPressed: () {
            if (widget.onPressedAdd != null) {
              widget.onPressedAdd!();
            }
          },
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}