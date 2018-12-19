import 'package:flutter/material.dart';

class PlayPauseButton extends StatefulWidget {
  final Color parentColor;
  final double size;
  final bool isPlaying;
  PlayPauseButton({this.parentColor, this.size, this.isPlaying});

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.size/2,
      backgroundColor: Colors.white,
      child: Icon(
        Icons.play_arrow,
        size: widget.size * 0.75,
        color: widget.parentColor,
      ),
    );
  }
}
