import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:music_app/data/apis/apis_playlist.dart';
import 'package:music_app/data/apis/apis_song.dart';
import 'package:music_app/data/models/lyric.dart';
import 'package:music_app/data/models/search_result.dart';
import 'package:music_app/data/models/song.dart';

class MusicRepository {
  Future<Song?> getSongDetail(String id, {RxBool? isLoading}) async {
    return await ApisSong.getSongDetail(id: id, isLoading: isLoading);
  }
  Future<Map<String, dynamic>?> getSongSource(String id, {RxBool? isLoading}) async {
    return await ApisSong.getSongSource(id: id, isLoading: isLoading);
  }
  Future<Map<String, dynamic>?> getDetailPlaylist(String id, {RxBool? isLoading}) async {
    return await ApisPlaylist.getDetailPlaylist(id: id, isLoading: isLoading);
  }
  Future<List<Song>> searchSong(String keyword, {RxBool? isLoading}) async {
    return await ApisSong.searchSong(keyword: keyword, isLoading: isLoading);
  }
  Future<SearchResult?> searchFullData(String keyword, {RxBool? isLoading}) async {
    return await ApisSong.searchFull(keyword: keyword, isLoading: isLoading);
  }
  Future<Lyric?> getLyric(String id) async {
    return await ApisSong.getLyric(id: id);
  }
}