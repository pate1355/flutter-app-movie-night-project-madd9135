import 'package:flutter/material.dart';
import 'package:movie_night/pages/enter_code_page.dart';
import 'package:movie_night/pages/movie_selection_page.dart';
import 'package:movie_night/pages/previous_yes_page.dart';
import 'package:movie_night/pages/share_code_page.dart';
import 'package:movie_night/pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
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
        '/': (context) => const WelcomePage(),
        '/enter_code': (context) => const EnterCodePage(),
        '/share_code': (context) => const ShareCodePage(),
        '/movie_selection': (context) => const MovieSelectionPage(),
        '/previous_yes': (context) => const PreviousYesPage(),
      },
    );
  }
}
