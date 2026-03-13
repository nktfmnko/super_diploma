import 'package:flutter/material.dart';

void showErrorSnackBar(String message, BuildContext context) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
