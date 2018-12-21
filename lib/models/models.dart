import 'package:flute_music_player/flute_music_player.dart';
import 'package:scoped_model/scoped_model.dart';

class SongModel extends Model {
  
  Song _song = new Song(1, "artist", "title", "album", 1, 500, "uri", "albumArt");
  
  Song get song => _song;

  void changeSong(Song song) {
    this._song = song;
    notifyListeners();
  }
}