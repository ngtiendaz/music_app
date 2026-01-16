import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:music_app/core/network/apis_root.dart';
import 'package:dio/dio.dart';

class ApiBase {
  static const baseURL = ApisRoot.API_URL;
    static Dio dio = Dio();

  //Song APIs
   static const infoSong = '${baseURL}infosong';
   static const song = '${baseURL}song';
}
