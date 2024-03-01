import 'package:flutter/material.dart';

void showMessage(message, context) {
  final snackBar = SnackBar(content: Text(message), backgroundColor: Colors.black, duration: const Duration(seconds: 1),);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}