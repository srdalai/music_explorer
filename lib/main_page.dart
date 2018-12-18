import 'package:flutter/material.dart';
import 'package:music_explorer/home_page.dart';
import 'package:music_explorer/musics_page.dart';
import 'package:music_explorer/profile_page.dart';
import 'package:music_explorer/search_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    HomePage(),MusicsPage(),SearchPage(),ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0.0,),
      backgroundColor: Colors.grey.shade800,
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        fixedColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              backgroundColor: Colors.grey.shade900),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              title: Text("Music"),
              backgroundColor: Colors.grey.shade900),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text("Search"),
              backgroundColor: Colors.grey.shade900),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              title: Text("Profile"),
              backgroundColor: Colors.grey.shade900)
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
          _currentIndex = index;
        });
  }
}
