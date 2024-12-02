import 'package:flutter/material.dart';

class MovieSelectionPage extends StatelessWidget {
  const MovieSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Select a movie to watch.',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            'Press the button to continue.',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    ));
  }
}
