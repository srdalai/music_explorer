import 'package:flutter/material.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:music_explorer/music_player.dart';

class MusicsPage extends StatefulWidget {
  @override
  _MusicsPageState createState() => _MusicsPageState();
}

class _MusicsPageState extends State<MusicsPage> {
  List<Song> _songs;
  MusicFinder audioPlayer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlayer();
  }

  void initPlayer() async {
    audioPlayer = new MusicFinder();
    List<Song> songs = await MusicFinder.allSongs();
    songs = List.from(songs);

    setState(() {
        _songs = songs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Text(_songs[index].title[0]),
            ),
            title: Text(_songs[index].title, style: TextStyle(color: Colors.white),),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MusicPlayer(song: _songs[index],)));
            }
          );
        },
      ),
    );
  }
}
