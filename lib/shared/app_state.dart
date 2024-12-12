import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';

class AppState extends ChangeNotifier {
  String? _deviceId; // Store the unique device ID
  String? _sessionId; // Store the session ID
  bool _isMatch = false; // Tracks if a movie match occurred
  Map<String, dynamic>?
      _matchedMovie; // Stores the details of the matched movie

  // Getter for deviceId
  String? get deviceId => _deviceId;

  // Setter for deviceId
  void setDeviceId() async {
    // _deviceId = deviceId;

    try {
      String? deviceId = await PlatformDeviceId.getDeviceId;
      _deviceId = deviceId;
    } catch (e) {
      _deviceId = null;
    }

    notifyListeners(); // Notify listeners about the change
  }

  // Getter for sessionId
  String? get sessionId => _sessionId;

  // Setter for sessionId
  void setSessionId(String sessionId) {
    _sessionId = sessionId;
    notifyListeners();
  }

  // Getter for isMatch
  bool get isMatch => _isMatch;

  // Setter for isMatch
  void setMatch(bool isMatch, Map<String, dynamic>? matchedMovie) {
    _isMatch = isMatch;
    _matchedMovie = matchedMovie;
    notifyListeners();
  }

  // Getter for matchedMovie
  Map<String, dynamic>? get matchedMovie => _matchedMovie;

  // Reset state after a match is resolved
  void resetMatch() {
    _isMatch = false;
    _matchedMovie = null;
    notifyListeners();
  }
}
