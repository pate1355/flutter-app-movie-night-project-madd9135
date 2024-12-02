import 'dart:math';
import 'package:flutter/material.dart';

// Text(
//   "${Random().nextInt(10)} ${Random().nextInt(10)} ${Random().nextInt(10)} ${Random().nextInt(10)}",
//   style: const TextStyle(fontSize: 36),
// )

class ShareCodePage extends StatelessWidget {
  const ShareCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Session'),
        backgroundColor: Colors.redAccent[100],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${Random().nextInt(10)} ${Random().nextInt(10)} ${Random().nextInt(10)} ${Random().nextInt(10)}",
              style: const TextStyle(fontSize: 36),
            ),
            const SizedBox(height: 150),
            const Text("Share the code with friends."),
            const SizedBox(height: 150),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/enter_code');
              },
              icon: Container(
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(7),
                child: const Icon(
                  Icons.start,
                  color: Colors.white,
                ),
              ),
              label: const Text('Begin'),
              style: ButtonStyle(
                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                  vertical: 7,
                  horizontal: 40,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
