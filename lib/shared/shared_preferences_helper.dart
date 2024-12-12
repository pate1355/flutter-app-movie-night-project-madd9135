import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String deviceIdKey = 'device_id';
  static const String sessionIdKey = 'session_id';
  static const String codeKey = 'code';

  // Save code
  static Future saveCode(String? code) async {
    final sharePref = await SharedPreferences.getInstance();
    await sharePref.setString(codeKey, code!);
  }

  // Get code
  static Future<String?> getCode() async {
    final sharePref = await SharedPreferences.getInstance();
    return sharePref.getString('code');
  }

  // Save device ID
  static Future<void> saveDeviceId(String deviceId) async {
    final sharePref = await SharedPreferences.getInstance();
    await sharePref.setString(deviceIdKey, deviceId);
  }

  // Get device ID
  static Future<String?> getDeviceId() async {
    final sharePref = await SharedPreferences.getInstance();
    return sharePref.getString(deviceIdKey);
  }

  // Clear device ID (if needed)
  static Future<void> clearDeviceId() async {
    final sharePref = await SharedPreferences.getInstance();
    await sharePref.remove(deviceIdKey);
  }

  // Save session ID
  static Future<void> saveSessionId(String sessionId) async {
    final sharePref = await SharedPreferences.getInstance();
    await sharePref.setString(sessionIdKey, sessionId);
  }

  // Get session ID
  static Future<String?> getSessionId() async {
    final sharePref = await SharedPreferences.getInstance();
    return sharePref.getString(sessionIdKey);
  }

  // Clear session ID (if needed)
  static Future<void> clearSessionId() async {
    final sharePref = await SharedPreferences.getInstance();
    await sharePref.remove(sessionIdKey);
  }

  // Clear all data (if needed)
  static Future<void> clearAll() async {
    final sharePref = await SharedPreferences.getInstance();
    await sharePref.clear();
  }
}
