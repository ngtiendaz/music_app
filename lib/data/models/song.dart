import 'package:music_app/data/models/album.dart';
import 'package:music_app/data/models/artist.dart';
import 'package:music_app/data/models/genre.dart';

class Song {
  String? encodeId;
  String? title;
  String? alias;
  bool? isOffical;
  String? username;
  String? artistsNames;
  List<Artist>? artists;
  bool? isWorldWide;
  String? thumbnailM;
  String? link;
  String? thumbnail;
  int? duration;
  bool? zingChoice;
  bool? isPrivate;
  bool? preRelease;
  int? releaseDate;
  List<String>? genreIds;
  String? distributor;
  bool? isIndie;
  int? streamingStatus;
  bool? allowAudioAds;
  bool? hasLyric;
  int? userid;
  List<Genre>? genres;
  List<Artist>? composers;
  Album? album;
  bool? isRBT;
  int? like;
  int? listen;
  bool? liked;
  int? comment;

  Song({
    this.encodeId,
    this.title,
    this.alias,
    this.isOffical,
    this.username,
    this.artistsNames,
    this.artists,
    this.isWorldWide,
    this.thumbnailM,
    this.link,
    this.thumbnail,
    this.duration,
    this.zingChoice,
    this.isPrivate,
    this.preRelease,
    this.releaseDate,
    this.genreIds,
    this.distributor,
    this.isIndie,
    this.streamingStatus,
    this.allowAudioAds,
    this.hasLyric,
    this.userid,
    this.genres,
    this.composers,
    this.album,
    this.isRBT,
    this.like,
    this.listen,
    this.liked,
    this.comment,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      encodeId: json['encodeId'],
      title: json['title'],
      alias: json['alias'],
      isOffical: json['isOffical'],
      username: json['username'],
      artistsNames: json['artistsNames'],
      artists: (json['artists'] as List<dynamic>?)
          ?.map((e) => Artist.fromJson(e))
          .toList(),
      isWorldWide: json['isWorldWide'],
      thumbnailM: json['thumbnailM'],
      link: json['link'],
      thumbnail: json['thumbnail'],
      duration: json['duration'],
      zingChoice: json['zingChoice'],
      isPrivate: json['isPrivate'],
      preRelease: json['preRelease'],
      releaseDate: json['releaseDate'],
      genreIds: (json['genreIds'] as List<dynamic>?)?.cast<String>(),
      distributor: json['distributor'],
      isIndie: json['isIndie'],
      streamingStatus: json['streamingStatus'],
      allowAudioAds: json['allowAudioAds'],
      hasLyric: json['hasLyric'],
      userid: json['userid'],
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => Genre.fromJson(e))
          .toList(),
      composers: (json['composers'] as List<dynamic>?)
          ?.map((e) => Artist.fromJson(e))
          .toList(),
      album: json['album'] != null ? Album.fromJson(json['album']) : null,
      isRBT: json['isRBT'],
      like: json['like'],
      listen: json['listen'],
      liked: json['liked'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'encodeId': encodeId,
      'title': title,
      'alias': alias,
      'isOffical': isOffical,
      'username': username,
      'artistsNames': artistsNames,
      'artists': artists?.map((e) => e.toJson()).toList(),
      'isWorldWide': isWorldWide,
      'thumbnailM': thumbnailM,
      'link': link,
      'thumbnail': thumbnail,
      'duration': duration,
      'zingChoice': zingChoice,
      'isPrivate': isPrivate,
      'preRelease': preRelease,
      'releaseDate': releaseDate,
      'genreIds': genreIds,
      'distributor': distributor,
      'isIndie': isIndie,
      'streamingStatus': streamingStatus,
      'allowAudioAds': allowAudioAds,
      'hasLyric': hasLyric,
      'userid': userid,
      'genres': genres?.map((e) => e.toJson()).toList(),
      'composers': composers?.map((e) => e.toJson()).toList(),
      'album': album?.toJson(),
      'isRBT': isRBT,
      'like': like,
      'listen': listen,
      'liked': liked,
      'comment': comment,
    };
  }
}