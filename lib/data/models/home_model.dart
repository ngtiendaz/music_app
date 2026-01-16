import 'package:music_app/data/models/album.dart';
import 'package:music_app/data/models/song.dart';

// 1. Model bao bọc ngoài cùng (Wrapper)
class HomeResponse {
  int? err;
  String? msg;
  HomeData? data;

  HomeResponse({this.err, this.msg, this.data});

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      err: json['err'],
      msg: json['msg'],
      data: json['data'] != null ? HomeData.fromJson(json['data']) : null,
    );
  }
}

// 2. Model Data chứa danh sách các Section
class HomeData {
  List<Section>? items;

  HomeData({this.items});

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Section.fromJson(e))
          .toList(),
    );
  }
}

// 3. Model Section: Đại diện cho từng mục trên màn hình Home (Banner, Playlist, Chart...)
class Section {
  String? sectionType; // Quan trọng: dùng để phân loại UI (banner, playlist, new-release...)
  String? title;
  String? viewType;
  // Items có thể là Album, Banner, hoặc Song tuỳ vào sectionType
  // Để đơn giản, ta có thể tách riêng hoặc dùng dynamic, nhưng ở đây mình sẽ gom nhóm
  List<Album>? playlists; 
  List<BannerItem>? banners;
  // Dữ liệu cho phần New Release (Mới phát hành) hơi phức tạp, cần xử lý riêng nếu muốn kỹ
  NewReleaseData? newRelease;

  Section({this.sectionType, this.title, this.viewType, this.playlists, this.banners, this.newRelease});

  factory Section.fromJson(Map<String, dynamic> json) {
    String type = json['sectionType'] ?? '';
    
    List<Album>? listPlaylists;
    List<BannerItem>? listBanners;
    NewReleaseData? newReleaseData;

    if (type == 'playlist' || type == 'album') {
      listPlaylists = (json['items'] as List<dynamic>?)
          ?.map((e) => Album.fromJson(e))
          .toList();
    } else if (type == 'banner') {
      listBanners = (json['items'] as List<dynamic>?)
          ?.map((e) => BannerItem.fromJson(e))
          .toList();
    } else if (type == 'new-release') {
       // Xử lý riêng cho cục "Mới phát hành" vì cấu trúc nó khác (là object chứa list chứ k phải list)
       if (json['items'] != null) {
         newReleaseData = NewReleaseData.fromJson(json['items']);
       }
    }

    return Section(
      sectionType: type,
      title: json['title'],
      viewType: json['viewType'],
      playlists: listPlaylists,
      banners: listBanners,
      newRelease: newReleaseData
    );
  }
}

// 4. Model Banner (Vì banner có trường 'banner' chứa link ảnh, khác với 'thumbnail')
class BannerItem {
  String? type;
  String? banner;
  String? cover;
  String? target;
  String? title;
  String? link;
  String? encodeId;

  BannerItem({this.banner, this.encodeId, this.link});

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      banner: json['banner'],
      encodeId: json['encodeId'],
      link: json['link'],
    );
  }
}

// 5. Model cho New Release (Mới phát hành)
class NewReleaseData {
  List<Song>? all;
  List<Song>? vPop;
  List<Song>? others;

  NewReleaseData({this.all, this.vPop, this.others});
  
  factory NewReleaseData.fromJson(Map<String, dynamic> json) {
     return NewReleaseData(
       all: (json['all'] as List<dynamic>?)?.map((e) => Song.fromJson(e)).toList(),
       vPop: (json['vPop'] as List<dynamic>?)?.map((e) => Song.fromJson(e)).toList(),
       others: (json['others'] as List<dynamic>?)?.map((e) => Song.fromJson(e)).toList(),
     );
  }
}