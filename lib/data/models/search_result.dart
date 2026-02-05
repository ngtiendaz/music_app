import 'package:music_app/data/models/song.dart';

class SearchResult {
  List<Artist>? artists;
  List<Playlist>? playlists;
  List<Song>? songs;
  // List<Video>? videos; // Có thể thêm nếu cần

  SearchResult({this.artists, this.playlists, this.songs});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      artists: json['artists'] != null
          ? (json['artists'] as List).map((i) => Artist.fromJson(i)).toList()
          : [],
      playlists: json['playlists'] != null
          ? (json['playlists'] as List).map((i) => Playlist.fromJson(i)).toList()
          : [],
      songs: json['songs'] != null
          ? (json['songs'] as List).map((i) => Song.fromJson(i)).toList()
          : [],
    );
  }
}

class Artist {
  String? id;
  String? name;
  String? thumbnail;
  String? playlistId; // Quan trọng: Dùng để navigate sang trang Playlist

  Artist({this.id, this.name, this.thumbnail, this.playlistId});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      thumbnail: json['thumbnail'],
      playlistId: json['playlistId'],
    );
  }
}

class Playlist {
  String? encodeId;
  String? title;
  String? thumbnailM;
  String? artistsNames;

  Playlist({this.encodeId, this.title, this.thumbnailM, this.artistsNames});

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      encodeId: json['encodeId'],
      title: json['title'],
      thumbnailM: json['thumbnailM'],
      artistsNames: json['artistsNames'],
    );
  }
}