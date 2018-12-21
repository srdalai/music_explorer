import 'dart:io';
import 'dart:async';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:simple_coverflow/simple_coverflow.dart';
import 'package:audioplayer/audioplayer.dart';

enum PlayerState { stopped, playing, paused }

class MusicPlayer extends StatefulWidget {
  final Song song;
  const MusicPlayer({Key key, this.song}) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  List<Song> _songs;
  Song _song;
  String _albumArt, _artist, _album, _title;
  int _duration;

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
    initAudioPlayer();
    
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
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
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });

    _playLocal();
  }

  Widget buildCards() {
    return Container(
      child: CoverFlow(
        dismissibleItems: false,
        itemCount: 1,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              top: 20.0,
              right: 10.0,
              bottom: 80.0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Material(
                  elevation: 8.0,
                  child: _song.albumArt == null
                      ? Image.asset("assets/selena.jpg", fit: BoxFit.cover)
                      : Image.file(new File(_song.albumArt), fit: BoxFit.cover)
                  // child: Image.asset("assets/selena.jpg", fit: BoxFit.cover),
                  ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSecondRow() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Slider(
          min: 0.0,
          max: duration.inMilliseconds.toDouble(),
          activeColor: Colors.white,
          inactiveColor: Colors.white54,
          value: position?.inMilliseconds?.toDouble() ?? 0.0,
          onChanged: (value) =>
              audioPlayer.seek((value / 1000).roundToDouble()),
        ));
  }

  Widget buildFirstRow() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            iconSize: 28.0,
            onPressed: () {
              mute(!isMuted);
            },
            icon: Icon(isMuted ? Icons.volume_up : Icons.volume_off,
                color: Colors.white),
          ),
          IconButton(
            iconSize: 28.0,
            onPressed: () {},
            icon: Icon(Icons.favorite_border, color: Colors.white),
          ),
          IconButton(
            iconSize: 28.0,
            onPressed: () {},
            icon: Icon(Icons.save_alt, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget buildThirdRow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            iconSize: 24.0,
            onPressed: () {},
            icon: Icon(Icons.shuffle, color: Colors.white),
          ),
          IconButton(
            iconSize: 36.0,
            onPressed: () {},
            icon: Icon(Icons.skip_previous, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              isPlaying ? _pause() : _playLocal();
            },
            iconSize: 64.0,
            icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                color: Colors.white),
          ),
          //PlayPauseButton(size: 48.0,parentColor: Colors.grey.shade800),
          IconButton(
            iconSize: 36.0,
            onPressed: () {},
            icon: Icon(Icons.skip_next, color: Colors.white),
          ),
          IconButton(
            iconSize: 24.0,
            onPressed: () {},
            icon: Icon(Icons.repeat, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget buildPlayControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: <Widget>[buildFirstRow(), buildSecondRow(), buildThirdRow()],
      ),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            _title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(_artist, style: TextStyle(color: Colors.white70, fontSize: 20.0))
        ],
      ),
    );
  }

  Widget buidCoverCards() {
    return Expanded(
        child: Container(
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[buildCards(), buildTitle()],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: Column(
        children: <Widget>[
          buidCoverCards(),
          buildPlayControls(),
          SizedBox(
            height: 56.0,
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 56.0,
              color: Colors.white30,
            ),
          )
        ],
      ),
    );
  }
}
