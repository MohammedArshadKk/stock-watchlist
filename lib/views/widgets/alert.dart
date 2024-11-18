import 'package:flutter/material.dart';

Future<void> showAlertDialog(
    BuildContext context, Function alertFunction, String alerttext) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Are you sure'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(alerttext),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              alertFunction();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}