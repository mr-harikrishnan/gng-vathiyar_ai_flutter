import 'package:flutter/material.dart';

// SnackBar widget with parameter
class SnackBarWidget extends StatelessWidget {
  final String message;

  const SnackBarWidget({super.key, required this.message});

  // Static helper to show SnackBar from logic
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Run this after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Show the SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
    });

    // This widget itself shows nothing on screen
    return const SizedBox.shrink();
  }
}
