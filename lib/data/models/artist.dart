class Artist {
  String? id;
  String? name;
  String? link;
  bool? spotlight;
  String? alias;
  String? thumbnail;
  String? thumbnailM;
  bool? isOA;
  bool? isOABrand;
  String? playlistId;
  int? totalFollow;

  Artist({
    this.id,
    this.name,
    this.link,
    this.spotlight,
    this.alias,
    this.thumbnail,
    this.thumbnailM,
    this.isOA,
    this.isOABrand,
    this.playlistId,
    this.totalFollow,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      link: json['link'],
      spotlight: json['spotlight'],
      alias: json['alias'],
      thumbnail: json['thumbnail'],
      thumbnailM: json['thumbnailM'],
      isOA: json['isOA'],
      isOABrand: json['isOABrand'],
      playlistId: json['playlistId'],
      totalFollow: json['totalFollow'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'link': link,
      'spotlight': spotlight,
      'alias': alias,
      'thumbnail': thumbnail,
      'thumbnailM': thumbnailM,
      'isOA': isOA,
      'isOABrand': isOABrand,
      'playlistId': playlistId,
      'totalFollow': totalFollow,
    };
  }
}