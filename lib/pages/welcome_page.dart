import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:movie_night/pages/enter_code_page.dart';
import 'package:movie_night/pages/share_code_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  String? _deviceId;

  @override
  void initState() {
    super.initState();
    _loadDeviceId();
  }

  Future<void> _loadDeviceId() async {
    try {
      String? deviceId = await PlatformDeviceId.getDeviceId;
      setState(() {
        _deviceId = deviceId;
      });
    } catch (e) {
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Night'),
        backgroundColor: Colors.redAccent[100],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/share_code');
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
              label: const Text('Start Session'),
              style: ButtonStyle(
                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                  vertical: 7,
                  horizontal: 40,
                )),
              ),
            ),
            const SizedBox(height: 150),
            const Text("Choose an option to begin."),
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
                  Icons.code,
                  color: Colors.white,
                ),
              ),
              label: const Text('Enter a code'),
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
