import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';

class InheritedPlayer extends InheritedWidget {

  final Song song;

  InheritedPlayer({this.song, Widget child}) : super(child : child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }


  static InheritedPlayer of (BuildContext context) => context.inheritFromWidgetOfExactType(InheritedPlayer);

  void playMusic() {
    
  }

}