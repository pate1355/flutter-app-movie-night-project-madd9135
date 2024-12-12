import 'package:flutter/material.dart';
import 'package:movie_night/helpers/http_helper.dart';
import 'package:movie_night/shared/shared_preferences_helper.dart';

class MovieSelectionPage extends StatefulWidget {
  const MovieSelectionPage({super.key});

  @override
  MovieSelectionPageState createState() => MovieSelectionPageState();
}

class MovieSelectionPageState extends State<MovieSelectionPage> {
  final httpHelper = HttpHelper();
  final List<Map<String, dynamic>> _movies = [];
  int _currentIndex = 0;
  String? currentSessionId;
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

    try {
      _code = await SharedPreferencesHelper.getCode();
      currentSessionId = await SharedPreferencesHelper.getSessionId();
      _deviceId = await SharedPreferencesHelper.getDeviceId();

      if (currentSessionId == null) {
        Navigator.pushNamed(context, '/error_page');
        return;
      }

      await _fetchMovies();
    } catch (e) {
      debugPrint('Initialization error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
      final response = await httpHelper.voteMovie(
        sessionId: currentSessionId!,
        movieId: movieId,
        vote: vote,
      );

      if (response['match'] == true) {
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

    if (_currentIndex >= _movies.length) {
      _fetchMovies(page: (_movies.length ~/ 20) + 1);
    }
  }

  void _showMatchDialog(dynamic movieId) {
    final int movieIdInt = movieId is String ? int.parse(movieId) : movieId;
    final matchedMovie = _movies
        .firstWhere((movie) => movie['id'] == movieIdInt, orElse: () => {});

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
            Text("session id is $currentSessionId!"),
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
          title: const Text('Movie Selection'),
          backgroundColor: Colors.redAccent[100],
        ),
        body: const Center(
          child: Text('No movies available. Please try again later.'),
        ),
      );
    }

    final currentMovie = _movies[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Selection'),
        backgroundColor: Colors.redAccent[100],
      ),
      body: Dismissible(
        key: Key(currentMovie['id'].toString()),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          final vote = direction == DismissDirection.endToStart ? false : true;
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
