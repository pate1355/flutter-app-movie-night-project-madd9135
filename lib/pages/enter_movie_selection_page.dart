import 'package:flutter/material.dart';

import 'package:movie_night/helpers/http_helper.dart';
import 'package:movie_night/shared/shared_preferences_helper.dart';

class EnterMovieSelectionPage extends StatefulWidget {
  const EnterMovieSelectionPage({super.key});

  @override
  EnterMovieSelectionPageState createState() => EnterMovieSelectionPageState();
}

class EnterMovieSelectionPageState extends State<EnterMovieSelectionPage> {
  final httpHelper = HttpHelper();
  final List<dynamic> _movies = [];
  int _currentIndex = 0;
  String? _sessionId;
  String? _deviceId;
  bool _isLoading = false;
  String? _code;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    setState(() {
      _isLoading = true;
    });

    // Retrieve sessionId and deviceId
    _code = await SharedPreferencesHelper.getCode();
    _sessionId = await SharedPreferencesHelper.getSessionId();
    _deviceId = await SharedPreferencesHelper.getDeviceId();

    // Fetch movies from TMDB
    await _fetchMovies();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchMovies({int page = 1}) async {
    try {
      final movies = await httpHelper.fetchMovies("popular", page);
      setState(() {
        _movies.addAll(movies);
      });
    } catch (e) {
      debugPrint('Error fetching movies: $e');
    }
  }

  Future<void> _voteMovie(int movieId, bool vote) async {
    try {
      print('Session ID: $_sessionId, Movie ID: $movieId, Vote: $vote');
      print("code is ${_code}");

      // Vote for the movie
      final response = await httpHelper.voteMovie(
        sessionId: _sessionId!,
        movieId: movieId,
        vote: vote,
      );
      print('Response: $response');
      print('Movie id: $movieId');
      print("Response Movie Id : ${response['movieId']}");

      // If the response has a match and the current movie is a match, show the match dialog
      if (response['match'] == true &&
          response['movie_id'] == movieId &&
          response['num_devices'] == 2) {
        _showMatchDialog(movieId);
      } else {
        _loadNextMovie();
      }
    } catch (e) {
      debugPrint('Error voting for movie: $e');
    }
  }

  void _loadNextMovie() {
    setState(() {
      _currentIndex++;
    });

    // Fetch more movies if we're at the end of the list
    if (_currentIndex >= _movies.length) {
      _fetchMovies(page: (_movies.length ~/ 20) + 1);
    }
  }

  void _showMatchDialog(dynamic movieId) {
    final int movieIdInt = movieId is String ? int.parse(movieId) : movieId;
    final matchedMovie =
        _movies.firstWhere((movie) => movie['id'] == movieIdInt);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('It’s a Match!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              'https://image.tmdb.org/t/p/w500${matchedMovie['poster_path'] ?? ''}',
              height: 150,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/default_poster.png',
                height: 150,
              ),
            ),
            const SizedBox(height: 16),
            Text(matchedMovie['title'] ?? 'No Title'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to the Welcome Screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_movies.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Movie Night!'),
        ),
        body: const Center(
          child: Text('No movies available. Please try again later.'),
        ),
      );
    }

    final currentMovie = _movies[_currentIndex];
    print('Current Movie: $currentMovie');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Night!'),
      ),
      body: Dismissible(
        key: Key(currentMovie['id'].toString()),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          final bool vote =
              direction == DismissDirection.endToStart ? false : true;

          print(currentMovie['id'].runtimeType);

          // Call _voteMovie with the appropriate direction based on swipe
          _voteMovie(currentMovie['id'], vote);
        },
        background: Container(
          color: Colors.green,
          alignment: Alignment.centerLeft,
          child: const Icon(Icons.thumb_up, color: Colors.white, size: 50),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: const Icon(Icons.thumb_down, color: Colors.white, size: 50),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                'https://image.tmdb.org/t/p/w500${currentMovie['poster_path'] ?? ''}',
                height: 300,
                errorBuilder: (_, __, ___) => Image.asset(
                  'assets/default_poster.png',
                  height: 300,
                ),
              ),
              Text("session id: $_sessionId"),
              Text("movie['id']: ${currentMovie['id']}"),
              const SizedBox(height: 16),
              Text(
                currentMovie['title'] ?? 'No Title',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(currentMovie['release_date'] ?? 'No Release Date'),
              const SizedBox(height: 8),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(currentMovie['overview'] ?? 'No Overview'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
