import 'dart:async';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:music_explorer/home_page.dart';
import 'package:music_explorer/models/models.dart';
import 'package:music_explorer/musics_page.dart';
import 'package:music_explorer/profile_page.dart';
import 'package:music_explorer/search_page.dart';
import 'package:music_explorer/widgets/miniPlayer.dart';
import 'package:scoped_model/scoped_model.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin{
  int _currentIndex = 0;
  bool shouldChange = true;
  StreamController<Song> controller;
  List<Widget> _children = [
    HomePage(),
    MusicsPage(),
    SearchPage(),
    ProfilePage()
  ];




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _children = [
    HomePage(),
    MusicsPage(),
    SearchPage(),
    ProfilePage()
  ];

  controller = new StreamController.broadcast();
  shouldChange = true;
  }

  @override
  void dispose() {
      // TODO: implement dispose
      controller.close();
      super.dispose();
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _children[_currentIndex],
          ScopedModelDescendant<SongModel>(
            rebuildOnChange: false,
            builder: (context, _, model) {
              print(model.song.title);
              controller.sink.add(model.song);
              return MiniPlayer(song: model.song, streamController: controller);
             },
          )
          // RaisedButton(
          //   onPressed: _showPersBottomSheetCallBack,
          //   child: Text("Click Me"),
          // )
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.grey.shade900,
            primaryColor: Colors.red,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.white70))),
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
      shouldChange = false;
    });
  }
}


class NewHomePage extends StatelessWidget {

  final StreamController<Song> controller = new StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          MainPage(),
          Container(
            margin: EdgeInsets.only(bottom: 56.0),
            child: ScopedModelDescendant<SongModel>(
              rebuildOnChange: false,
              builder: (context, _, model) {
                print(model.song.title);
                controller.sink.add(model.song);
                return MiniPlayer(song: model.song, streamController: controller);
              },
            ),
          )

        ],
      ),
    );
  }
}
