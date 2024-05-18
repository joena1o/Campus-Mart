import 'package:flutter/material.dart';

void showMessage(message, context) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.green),
    ),
    backgroundColor: Colors.greenAccent,
    duration: const Duration(seconds: 4),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showMessageError(message, context) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
    duration: const Duration(seconds: 4),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showMessageWithButton(message, context, action) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
    duration: const Duration(seconds: 4),
    action: SnackBarAction(
      textColor: Colors.white,
      label: 'Verify',
      onPressed: () {
        action();
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
