import 'package:flutter/material.dart';

/// Dialog to confirm reset action
class ConfirmResetDialog extends StatelessWidget {
  const ConfirmResetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Reset Counter?"),
      content: Text("This action can't be undone"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Confirm', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
