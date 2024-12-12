import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpHelper {
  final String movieNightBaseUrl = "https://movie-night-api.onrender.com";
  final String moviedbBaseUrl = "https://api.themoviedb.org/3";
  final String moviedbApiKey =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3MmUzNjc1NjExYTI4YWY4NmRmZDNkOTVlNjc3OGNmZSIsIm5iZiI6MTcwODM4NDYxMC4wNjcwMDAyLCJzdWIiOiI2NWQzZTE2MjBmMzY1NTAxNDllN2E1ZGUiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.Etknu900XRTPNLMP4lANoUyWJ9MWknVEexc9soKYahc"; // Store this securely

  Map<String, String> _getHeaders() {
    return {
      'Authorization': 'Bearer $moviedbApiKey',
      'Content-Type': 'application/json',
    };
  }

  Future<List<Map<String, dynamic>>> fetchMovies(
      String category, int page) async {
    final url = Uri.parse('$moviedbBaseUrl/movie/$category?page=$page');
    try {
      final response = await http.get(url, headers: _getHeaders());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'] is List) {
          return List<Map<String, dynamic>>.from(data['results']);
        } else {
          throw Exception('Unexpected response format: results is not a List.');
        }
      } else {
        throw Exception('Failed to fetch movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error in fetchMovies: $e');
    }
  }

  Future<Map<String, dynamic>> startSession(String? deviceID) async {
    if (deviceID == null || deviceID.isEmpty) {
      throw Exception('Invalid device ID.');
    }
    final url =
        Uri.parse('$movieNightBaseUrl/start-session?device_id=$deviceID');
    try {
      final response = await http.get(url, headers: _getHeaders());
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'] ?? {};
      } else {
        throw Exception('Failed to start session: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error in startSession: $e');
    }
  }

  Future<Map<String, dynamic>> joinSession(
      String? deviceId, String code) async {
    if (deviceId == null || deviceId.isEmpty || code.isEmpty) {
      throw Exception('Invalid device ID or code.');
    }
    final url = Uri.parse(
        '$movieNightBaseUrl/join-session?device_id=$deviceId&code=$code');
    try {
      final response = await http.get(url, headers: _getHeaders());
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'] ?? {};
      } else {
        throw Exception('Failed to join session: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error in joinSession: $e');
    }
  }

  Future<Map<String, dynamic>> voteMovie(
      {required String sessionId,
      required int movieId,
      required bool vote}) async {
    if (sessionId.isEmpty || movieId <= 0) {
      throw Exception('Invalid session ID or movie ID.');
    }
    final url = Uri.parse(
        '$movieNightBaseUrl/vote-movie?session_id=$sessionId&movie_id=$movieId&vote=$vote');
    try {
      final response = await http.get(
        url,
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'] ?? {};
      } else {
        print("response is ${jsonDecode(response.body)}");
        throw Exception('Failed to vote on movie: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error in voteMovie: $e');
    }
  }
}
