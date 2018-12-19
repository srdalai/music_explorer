import 'package:flutter/material.dart';
import 'package:music_explorer/music_player.dart';
import 'package:marquee/marquee.dart';

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
          child: Padding(
            padding: const EdgeInsets.only(top: 56.0, left: 56.0, right: 56.0),
            child: Card(
              color: Colors.grey.shade500,
              child: Container(),
            ),
          ),
        ),
        SizedBox(height: 30.0,),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Playlists", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
              Text("more",style: TextStyle(color: Colors.white, fontSize: 16.0))
            ],
          ),
        ),
        buildPlaylist(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("New Musics", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
              Text("more",style: TextStyle(color: Colors.white, fontSize: 16.0))
            ],
          ),
        ),
        buildMaterial(),
        //bottomPlayer(),
      ],
    );
  }

  Widget buildMaterial() {
    return Container(
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, position) {
          return Container(
            margin: EdgeInsets.all(12.0),
            width: 120.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    "assets/selena.jpg",
                    width: 120.0,
                    height: 120.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  "Start Dance",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  "Selena Gomez Selena",
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildPlaylist() {
    return Container(
      height: 100.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, position) {
          return Container(
            margin: EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                "assets/selena.jpg",
                width: 180.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
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
