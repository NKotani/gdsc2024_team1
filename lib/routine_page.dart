import 'package:flutter/material.dart';

class RoutinePage extends StatelessWidget {
  final String routine;

  const RoutinePage({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Routine')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          routine,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
