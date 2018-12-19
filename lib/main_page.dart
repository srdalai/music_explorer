import 'package:flutter/material.dart';
import 'package:music_explorer/home_page.dart';
import 'package:music_explorer/musics_page.dart';
import 'package:music_explorer/profile_page.dart';
import 'package:music_explorer/search_page.dart';
import 'package:music_explorer/widgets/miniPlayer.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    HomePage(),
    MusicsPage(),
    SearchPage(),
    ProfilePage()
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  VoidCallback _showPersBottomSheetCallBack;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showPersBottomSheetCallBack = _showBottomSheet;
  }

  void _showBottomSheet() {
    setState(() {
      _showPersBottomSheetCallBack = null;
    });

    _scaffoldKey.currentState
        .showBottomSheet((context) {
          return MiniPlayer();
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showPersBottomSheetCallBack = _showBottomSheet;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade800,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _children[_currentIndex],
          //MiniPlayer()
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
    });
  }

  Widget bottomPlayer() {
    return Material(
      color: Colors.grey.shade700,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 60.0,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              width: 48.0,
              height: 48.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Material(
                  child: Image.asset("assets/selena.jpg", fit: BoxFit.cover),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Slow Down Slow Down Slow Down Slow Down Slow Down",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text("Selena Gomez",
                        style: TextStyle(color: Colors.white70, fontSize: 16.0))
                  ],
                ),
              ),
            ),
            Center(
              child: IconButton(
                iconSize: 36.0,
                color: Colors.white,
                icon: Icon(Icons.play_circle_filled),
                onPressed: () {
                  print("Hello");
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
