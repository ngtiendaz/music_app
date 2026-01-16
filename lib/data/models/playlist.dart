// lib/data/models/playlist_detail.dart
import 'package:music_app/data/models/song.dart';

class PlaylistDetail {
  String? encodeId;
  String? title;
  String? thumbnailM;
  String? sortDescription;
  String? artistsNames;
  int? like;
  List<Song>? songItems; // Danh sách bài hát trong playlist

  PlaylistDetail({
    this.encodeId,
    this.title,
    this.thumbnailM,
    this.sortDescription,
    this.artistsNames,
    this.like,
    this.songItems,
  });

  factory PlaylistDetail.fromJson(Map<String, dynamic> json) {
    return PlaylistDetail(
      encodeId: json['encodeId'],
      title: json['title'],
      thumbnailM: json['thumbnailM'],
      sortDescription: json['sortDescription'],
      artistsNames: json['artistsNames'],
      like: json['like'],
      // Quan trọng: Parse list songs từ json['song']['items']
      songItems: json['song'] != null && json['song']['items'] != null
          ? (json['song']['items'] as List)
              .map((e) => Song.fromJson(e))
              .toList()
          : [],
    );
  }
}