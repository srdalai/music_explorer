import 'package:flutter/material.dart';
import 'package:music_explorer/home_page.dart';
import 'package:music_explorer/main_page.dart';
import 'package:music_explorer/musics_page.dart';
import 'package:music_explorer/profile_page.dart';
import 'package:music_explorer/search_page.dart';

void main() => runApp(MusicExplorer());

class MusicExplorer extends StatelessWidget {
  // This widget is the root of your application.

  final navigatorKey = GlobalKey<NavigatorState>();
  final pagesRouteFactories = {
    "/": () => MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
    "musics": () => MaterialPageRoute(
          builder: (context) => MusicsPage()
        ),
    "search": () => MaterialPageRoute(
          builder: (context) => SearchPage()
        ),
    "profile": () => MaterialPageRoute(
          builder: (context) => ProfilePage()
        ),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
        primaryIconTheme: IconThemeData(color: Colors.white),
        primaryTextTheme: Typography.whiteMountainView
      ),
      home:MainPage(),
    );
  }

  Widget _buildBody() =>
      MaterialApp(
        navigatorKey: navigatorKey,
        onGenerateRoute: (route) => pagesRouteFactories[route.name]()
        );

  Widget _buildBottomNavigationBar(context) => BottomNavigationBar(
        items: [
          _buildBottomNavigationBarItem("Home", Icons.home),
          _buildBottomNavigationBarItem("Musics", Icons.music_note),
          _buildBottomNavigationBarItem("Search", Icons.search),
          _buildBottomNavigationBarItem("Profile", Icons.person_outline)
        ],
        onTap: (routeIndex) =>
            navigatorKey.currentState.pushNamed(pagesRouteFactories.keys.toList()[routeIndex]),
      );

  _buildBottomNavigationBarItem(name, icon) => BottomNavigationBarItem(
      icon: Icon(icon), title: Text(name), backgroundColor: Colors.grey.shade900);
}