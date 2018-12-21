import 'package:flutter/material.dart';
import 'package:music_explorer/main_page.dart';
import 'package:music_explorer/models/models.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MusicExplorer(songModel: SongModel()));

class MusicExplorer extends StatelessWidget {
  // This widget is the root of your application.

  final SongModel songModel;

  MusicExplorer({this.songModel});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SongModel>(
      model: songModel,
      child: MaterialApp(
        title: 'Music Explorer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blueGrey,
            primaryIconTheme: IconThemeData(color: Colors.white),
            primaryTextTheme: Typography.whiteMountainView),
        home: NewHomePage(),
      ),
    );
  }
}
