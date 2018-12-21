import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flute_music_player/flute_music_player.dart';

class MusicsPage extends StatefulWidget {
  final StreamController<Song> controller;
  MusicsPage({this.controller});
  @override
  _MusicsPageState createState() => _MusicsPageState();
}

class _MusicsPageState extends State<MusicsPage> {
  List<Song> _songs;
  MusicFinder audioPlayer;
  bool isLoded = false;
  StreamController<Song> _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoded = false;
    _controller = widget.controller;
    initPlayer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.close();
    super.dispose();
  }

  void initPlayer() async {
    audioPlayer = new MusicFinder();
    List<Song> songs = await MusicFinder.allSongs();
    songs = List.from(songs);

    songs.sort((songA, songB) => songA.title.toLowerCase().compareTo(songB.title.toLowerCase()));

    setState(() {
      _songs = songs;
      isLoded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          isLoded ? buildGridView() : Container(),
        ],
      ),
    );
  }

  Widget buildGridView() {
    double width = MediaQuery.of(context).size.width;

    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(_songs.length, (index) {
        return buildPadding(width, index);
      }),
    );
  }

  Padding buildPadding(double width, int index) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            SizedBox(
              width: width * 0.50,
              height: width * 0.50,
              child: Material(
                  child: InkWell(
                child: _songs[index].albumArt == null
                    ? Image.asset("assets/selena.jpg", fit: BoxFit.cover)
                    : Image.file(File(_songs[index].albumArt),
                        fit: BoxFit.cover),
                splashColor: Colors.grey.shade300,
                onTap: () {
                  _controller.sink.add(_songs[index]);

                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => MusicPlayer(
                  //           song: _songs[index],
                  //         )));
                },
              )),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              color: Colors.black.withOpacity(0.5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    _songs[index].title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(_songs[index].artist,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 14.0))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
