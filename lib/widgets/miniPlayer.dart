import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_coverflow/simple_coverflow.dart';
import 'package:audioplayer/audioplayer.dart';

enum PlayerState { stopped, playing, paused }

class MiniPlayer extends StatefulWidget {
  final Song song;
  final StreamController<Song> streamController;
  const MiniPlayer(
      {Key key, this.song, this.streamController})
      : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  List<Song> _songs;
  Song _song;
  String _albumArt, _artist, _album, _title;
  int _duration;
  StreamController<Song> _streamController;

  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _song = widget.song;
  
    _streamController = widget.streamController;
    _streamController.stream.listen((song) {
      print(song.title);
      changeSong(song);
    });
    initAudioPlayer();
  }

  void changeSong(Song song) {
    if (playerState != PlayerState.stopped) {
      _stop();
    }
    setState(() {
      _song = song;
    });
    _playLocal();
    upadateSP(song);
  }

  SharedPreferences sharedPreferences;
  void upadateSP(Song changedSong) async {
    sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic> songData = new Map();
    songData.putIfAbsent("id", () => changedSong.id);
    songData.putIfAbsent("artist", () => changedSong.artist);
    songData.putIfAbsent("title", () => changedSong.title);
    songData.putIfAbsent("album", () => changedSong.album);
    songData.putIfAbsent("albumId", () => changedSong.albumId);
    songData.putIfAbsent("duration", () => changedSong.duration);
    songData.putIfAbsent("uri", () => changedSong.uri);
    songData.putIfAbsent("albumArt", () => changedSong.albumArt);
    
    String songString = json.encode(songData);

    await sharedPreferences.setString("songString", songString);
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    _streamController.close();
    audioPlayer.stop();
    super.dispose();
  }

  Future _playLocal() async {
    await audioPlayer.play(_song.uri, isLocal: true);
    setState(() => playerState = PlayerState.playing);
  }

  Future _pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future _stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() => isMuted = muted);
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();

    _albumArt = _song.albumArt;
    _artist = _song.artist;
    _album = _song.album;
    _title = _song.title;
    _duration = _song.duration;
    print(_duration);
    print(_albumArt);

    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));

    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
          _positionSubscription.cancel();
          _audioPlayerStateSubscription.cancel();
          audioPlayer.stop();
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });

    //_playLocal();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      initialData: _song,
      stream: _streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return bottomPlayer(snapshot.data);
        }
      },
    );
  }


  Widget bottomPlayer(Song nowSong) {
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
                  child: nowSong.albumArt == null
                      ? Image.asset("assets/selena.jpg", fit: BoxFit.cover)
                      : Image.file(new File(nowSong.albumArt),
                          fit: BoxFit.cover),
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
                      nowSong.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(nowSong.artist,
                        style: TextStyle(color: Colors.white70, fontSize: 16.0))
                  ],
                ),
              ),
            ),
            Center(
              child: IconButton(
                onPressed: () {
                  isPlaying ? _pause() : _playLocal();
                },
                iconSize: 42.0,
                icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
