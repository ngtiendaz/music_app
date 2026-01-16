import 'package:music_app/data/models/artist.dart';

class Album {
  String? encodeId;
  String? title;
  String? thumbnail;
  bool? isoffical;
  String? link;
  bool? isIndie;
  String? releaseDate;
  String? sortDescription;
  int? releasedAt; // Lưu ý: Trong JSON album releasedAt là long, releaseDate là string
  List<String>? genreIds;
  bool? pr;
  List<Artist>? artists;
  String? artistsNames;

  Album({
    this.encodeId,
    this.title,
    this.thumbnail,
    this.isoffical,
    this.link,
    this.isIndie,
    this.releaseDate,
    this.sortDescription,
    this.releasedAt,
    this.genreIds,
    this.pr,
    this.artists,
    this.artistsNames,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      encodeId: json['encodeId'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      isoffical: json['isoffical'],
      link: json['link'],
      isIndie: json['isIndie'],
      releaseDate: json['releaseDate'],
      sortDescription: json['sortDescription'],
      releasedAt: json['releasedAt'],
      genreIds: (json['genreIds'] as List<dynamic>?)?.cast<String>(),
      pr: json['PR'],
      artists: (json['artists'] as List<dynamic>?)
          ?.map((e) => Artist.fromJson(e))
          .toList(),
      artistsNames: json['artistsNames'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'encodeId': encodeId,
      'title': title,
      'thumbnail': thumbnail,
      'isoffical': isoffical,
      'link': link,
      'isIndie': isIndie,
      'releaseDate': releaseDate,
      'sortDescription': sortDescription,
      'releasedAt': releasedAt,
      'genreIds': genreIds,
      'PR': pr,
      'artists': artists?.map((e) => e.toJson()).toList(),
      'artistsNames': artistsNames,
    };
  }
}