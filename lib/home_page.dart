import 'package:flutter/material.dart';
import 'package:music_explorer/music_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
        //bottomPlayer(),
      ],
    );
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
                  child:
                      Image.asset("assets/selena.jpg", fit: BoxFit.cover),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
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
                        style: TextStyle(
                            color: Colors.white70, fontSize: 16.0))
                  ],
                ),
              ),
            ),
            Center(
              child: IconButton(
                iconSize: 36.0,
                color: Colors.white,
                icon: Icon(Icons.play_circle_filled),
                onPressed: () {print("Hello");},
              ),
            )
          ],
        ),
      ),
    );
  }
}
