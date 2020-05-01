import 'package:flutter/material.dart';
import 'package:flutter_wordpress/screens/archive.dart';
import 'package:flutter_wordpress/screens/author.dart';
import 'package:flutter_wordpress/screens/error.dart';
import 'package:flutter_wordpress/screens/post.dart';
import 'package:flutter_wordpress/screens/result.dart';
import 'package:flutter_wordpress/screens/search.dart';
import 'screens/home.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Wordpress',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => HomeScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        final args = settings.arguments;
        switch (settings.name) {
          case "/archive":
            return MaterialPageRoute(
              builder: (_) => ArchiveScreen(
                category: args,
              ),
            );
            break;
          case "/author":
            return MaterialPageRoute(
              builder: (_) => AuthorScreen(
                author: args,
              ),
            );
            break;
          case "/search":
            return MaterialPageRoute(
              builder: (_) => SearchScreen(
                search: args,
              ),
            );
            break;
          case "/result":
            return MaterialPageRoute(
              builder: (_) => ResultScreen(
                search: args,
              ),
            );
            break;
          case "/post":
            return MaterialPageRoute(
              builder: (_) => PostScreen(
                post: args,
              ),
            );
            break;
          default:
            return MaterialPageRoute(builder: (_) => ErrorScreen());
            break;
        }
      },
    );
  }
}
