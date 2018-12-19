import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:music_explorer/music_player.dart';
import 'package:music_explorer/widgets/inheritaedPlayer.dart';
import 'package:music_explorer/widgets/miniPlayer.dart';
import 'package:music_explorer/main_page.dart';

class MusicsPage extends StatefulWidget {
  //MusicsPage();
  @override
  _MusicsPageState createState() => _MusicsPageState();
}

class _MusicsPageState extends State<MusicsPage> {
  List<Song> _songs;
  Song _song;
  MusicFinder audioPlayer;
  bool isPlaying = false;
  bool isLoded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isPlaying = false;
    isLoded = false;
    initPlayer();
  }

  void initPlayer() async {
    audioPlayer = new MusicFinder();
    List<Song> songs = await MusicFinder.allSongs();
    songs = List.from(songs);

    setState(() {
      _songs = songs;
      isLoded = true;
    });
  }

  final number = new ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          isLoded ? buildGridView() : Container(),
          isPlaying ? MiniPlayer(song: _song,) : Container()
        ],
      ),
    );
  }

  Widget buildGridView() {
    double width = MediaQuery.of(context).size.width;

    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(_songs.length, (index) {
        return ValueListenableBuilder<int>(
        valueListenable: number,
        builder: (context, value, child) {
          return buildPadding(width, index);
        },
      );
        //return buildPadding(width, index);
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
                    splashColor: Colors.redAccent,
                    onTap: () {

                      
                      number.value++;
                      setState(() {
                        isPlaying = true;
                        _song = _songs[index];
                      });
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => MusicPlayer(
                      //           song: _songs[index],
                      //         )));
                    },
                    child: _songs[index].albumArt == null
                        ? Image.asset("assets/selena.jpg", fit: BoxFit.cover)
                        : Image.file(File(_songs[index].albumArt),
                            fit: BoxFit.cover),
                  ),
                ),
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

  ListView buildListView() {
    return ListView.builder(
      itemCount: _songs.length,
      itemBuilder: (context, index) {
        return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Text(_songs[index].title[0]),
            ),
            title: Text(
              _songs[index].title,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MusicPlayer(
                        song: _songs[index],
                      )));
            });
      },
    );
  }
}
