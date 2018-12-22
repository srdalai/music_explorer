import 'dart:async';
import 'dart:convert';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:music_explorer/home_page.dart';
import 'package:music_explorer/musics_page.dart';
import 'package:music_explorer/profile_page.dart';
import 'package:music_explorer/search_page.dart';
import 'package:music_explorer/widgets/miniPlayer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {

  final StreamController<Song> controller;
  MainPage({this.controller});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{
  int _currentIndex = 0;
  List<Widget> _children;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _children = [
    HomePage(),
    MusicsPage(controller: widget.controller),
    SearchPage(),
    ProfilePage()
  ];

  }

  @override
  void dispose() {
      // TODO: implement dispose
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {

    ThemeData botomTheme = Theme.of(context).copyWith(
            canvasColor: Colors.grey.shade900,
            primaryColor: Colors.red,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.white70)));

    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: _children[_currentIndex],
      bottomNavigationBar: Theme(
        data: botomTheme,
        child: BottomNavigationBar(
            onTap: onTabTapped,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            fixedColor: Colors.white,
            items: bottomNavitems),
      ),
    );
  }


  final List<BottomNavigationBarItem> bottomNavitems =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
    BottomNavigationBarItem(icon: Icon(Icons.music_note), title: Text("Music")),
    BottomNavigationBarItem(icon: Icon(Icons.search), title: Text("Search")),
    BottomNavigationBarItem(
        icon: Icon(Icons.person_outline), title: Text("Profile"))
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}


class NewHomePage extends StatefulWidget {

  @override
  NewHomePageState createState() => NewHomePageState();
}

class NewHomePageState extends State<NewHomePage> {
  StreamController<Song> controller;
  Song song = new Song(0, "", "", "", 0, 0, "", "");
  bool isLoded = false;
  SharedPreferences sharedPreferences;

  void getDataFromSP() async {
    sharedPreferences = await SharedPreferences.getInstance();

    String songString = sharedPreferences.getString("songString");
    print("SOng Data for SP"+songString);

    Map<String, dynamic> songData = json.decode(songString);

    Song _song = new Song(
      songData['id'],
      songData['artist'],
      songData['title'],
      songData['album'],
      songData['albumId'],
      songData['duration'],
      songData['uri'],
      songData['albumArt'],
    );

    setState(() {
          song = _song;
          isLoded = true;
        });
  }

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      controller = new StreamController.broadcast();
      getDataFromSP();
    }

  @override
  void dispose() {
      // TODO: implement dispose
      controller.close();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          MainPage(controller: controller,),
          Container(
            margin: EdgeInsets.only(bottom: 56.0),
            child: MiniPlayer(song: song, streamController: controller)
            ),
        ],
      ),
    );
  }
}
