import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:music_app/data/apis/apis_song.dart';
import 'package:music_app/data/models/song.dart';

class MusicRepository {
  Future<Song?> getSongDetail(String id, {RxBool? isLoading}) async {
    return await ApisSong.getSongDetail(id: id, isLoading: isLoading);
  }
  Future<Map<String, dynamic>?> getSongSource(String id, {RxBool? isLoading}) async {
    return await ApisSong.getSongSource(id: id, isLoading: isLoading);
  }
}