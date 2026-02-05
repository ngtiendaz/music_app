import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:music_app/core/network/apis_root.dart';
import 'package:dio/dio.dart';

class ApiBase {
  static const baseURL = ApisRoot.API_URL;
  static Dio dio = Dio();

  //Song APIs
  static const infoSong = '${baseURL}infosong';
  static const song = '${baseURL}song';

  //Home APIs
  static const home = '${baseURL}home';
  static const chartHome = '${baseURL}charthome';
  static const newreleasechart = '${baseURL}newreleasechart';
  static const top100 = '${baseURL}top100';

  //Playlist APIs
  static const detailplaylist = '${baseURL}detailplaylist';

  // Search Song APIs
  static const search = '${baseURL}search';

  // Lyric APIs
  static const lyric = '${baseURL}lyric';
}
