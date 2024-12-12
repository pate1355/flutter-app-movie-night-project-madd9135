import 'package:flutter/material.dart';
import 'package:movie_night/pages/enter_code_page.dart';
import 'package:movie_night/pages/share_movie_selection_page.dart';
import 'package:movie_night/pages/previous_yes_page.dart';
import 'package:movie_night/pages/share_code_page.dart';
import 'package:movie_night/pages/splash_screen.dart';
import 'package:movie_night/pages/welcome_page.dart';
import 'package:movie_night/pages/enter_movie_selection_page.dart';
import 'package:movie_night/pages/error_page.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const WelcomePage(),
        '/enter_code': (context) => const EnterCodePage(),
        '/share_code': (context) => const ShareCodePage(),
        '/share_movie_selection': (context) => const MovieSelectionPage(),
        '/enter_movie_selection': (context) => const EnterMovieSelectionPage(),
        '/previous_yes': (context) => const PreviousYesPage(),
        '/error_page': (context) => const ErrorPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
