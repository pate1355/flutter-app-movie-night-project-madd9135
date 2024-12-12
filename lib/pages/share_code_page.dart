import 'package:flutter/material.dart';
import 'package:movie_night/helpers/http_helper.dart';
import 'package:movie_night/shared/shared_preferences_helper.dart';

class ShareCodePage extends StatefulWidget {
  const ShareCodePage({super.key});

  @override
  ShareCodePageState createState() => ShareCodePageState();
}

class ShareCodePageState extends State<ShareCodePage> {
  String? deviceID;
  String? code;
  final HttpHelper httpHelper = HttpHelper();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeSession();
  }

  Future<void> initializeSession() async {
    await getDeviceId();
    if (deviceID != null) {
      await startSession();
      await joinSession();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getDeviceId() async {
    try {
      final deviceId = await SharedPreferencesHelper.getDeviceId();
      if (deviceId != null) {
        deviceID = deviceId;
      } else {
        throw Exception('Device ID not found');
      }
    } catch (e) {
      showErrorSnackBar('Error retrieving Device ID');
    }
  }

  Future<void> startSession() async {
    try {
      final response = await httpHelper.startSession(deviceID);
      if (response['code'] != null) {
        code = response['code'];
        await SharedPreferencesHelper.saveCode(code!);
      } else {
        throw Exception('Session code not received');
      }
    } catch (e) {
      showErrorSnackBar('Error starting session: ${e.toString()}');
    }
  }

  Future<void> joinSession() async {
    try {
      if (code == null) throw Exception('Session code is missing');
      final response = await httpHelper.joinSession(deviceID, code!);
      if (response['session_id'] != null) {
        print('Joined session: ${response['session_id']}');
        await SharedPreferencesHelper.saveSessionId(response['session_id']);
      } else {
        throw Exception('Failed to join session');
      }
    } catch (e) {
      showErrorSnackBar('Error joining session: ${e.toString()}');
    }
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Session'),
        backgroundColor: Colors.redAccent[100],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : code == null
              ? const Center(child: Text('Error loading session code'))
              : buildSessionUI(),
    );
  }

  Widget buildSessionUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            code!,
            style: const TextStyle(fontSize: 36, letterSpacing: 10),
          ),
          const SizedBox(height: 20),
          const Text("Share the code with friends."),
          const SizedBox(height: 50),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/share_movie_selection');
            },
            icon: const Icon(Icons.play_arrow, color: Colors.black),
            label: const Text('Begin Movie Matching',
                style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent[100],
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
