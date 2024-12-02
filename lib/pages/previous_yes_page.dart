import 'package:flutter/material.dart';

class PreviousYesPage extends StatelessWidget {
  const PreviousYesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You said yes to a previous movie night.',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Would you like to use the same code?',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
