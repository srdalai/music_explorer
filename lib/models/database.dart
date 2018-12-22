
import 'package:flute_music_player/flute_music_player.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'dart:async';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name allsongs.db in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "allsongs.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name Songs with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    //await db.execute("CREATE TABLE Songs(id TEXT PRIMARY KEY, artist TEXT, title TEXT, album TEXT, albumId TEXT, duration TEXT, uri TEXT, albumArt TEXT )");
    await db.execute("CREATE TABLE Songs(id TEXT, artist TEXT, title TEXT, album TEXT, albumId TEXT, duration TEXT, uri TEXT, albumArt TEXT )");
    print("Created tables");
  }

  // Retrieving employees from Songs Tables
  Future<List<Song>> getSongs() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Songs');
    List<Song> songs = new List();
    for (int i = 0; i < list.length; i++) {
      songs.add(new Song(int.parse(list[i]["id"]), list[i]["artist"], list[i]["title"], list[i]["album"], int.parse(list[i]["albumId"]), int.parse(list[i]["duration"]), list[i]["uri"], list[i]["albumArt"]));
    }
    print(songs.length);
    return songs;
  }

  deleteAllSOngs() async {
    var dbClient = await db;
    await dbClient.rawQuery('DELETE FROM Songs');
  }

  void saveSong(Song song) async {

    int _id = song.id ?? 0;
    String _title = song.title ?? "";
    String _artist = song.artist ?? "";
    int _albumId = song.albumId ?? 0;
    String _album = song.album ?? "";
    int _duration = song.duration ?? 0;
    String _uri = song.uri ?? "";
    String _albumArt = song.albumArt ?? "";

    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Songs(id, artist, title, album, albumId, duration, uri, albumArt ) VALUES(' +
              '\'' +
              _id.toString() +
              '\'' +
              ',' +
              '\'' +
              _artist +
              '\'' +
              ',' +
              '\'' +
              _title +
              '\'' +
              ',' +
              '\'' +
              _album +
              '\'' +
              ',' +
              '\'' +
              _albumId.toString() +
              '\'' +
              ',' +
              '\'' +
              _duration.toString() +
              '\'' +
              ',' +
              '\'' +
              _uri +
              '\'' +
              ',' +
              '\'' +
              _albumArt +
              '\'' +
              ')');
    });

    print("One Row Inserted");
  }
}