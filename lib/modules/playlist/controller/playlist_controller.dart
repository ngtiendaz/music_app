import 'package:get/get.dart';
import 'package:music_app/data/models/playlist.dart';
import 'package:music_app/data/repositories/music_repository.dart';

class PlaylistController extends GetxController {
  final MusicRepository musicRepository;
  PlaylistController({required this.musicRepository});

  var isLoading = true.obs;
  var playlistDetail = Rxn<PlaylistDetail>();
  String? playlistId;

  @override
  void onInit() {
    super.onInit();
    // Lấy ID playlist từ arguments khi điều hướng
    playlistId = Get.arguments as String?; 
    if (playlistId != null) {
      fetchPlaylistDetail(playlistId!);
    }
  }

  void fetchPlaylistDetail(String id) async {
    isLoading.value = true;
    try {
      final response = await musicRepository.getDetailPlaylist(id);
      if (response != null) {
        playlistDetail.value = PlaylistDetail.fromJson(response);
      }
    } catch (e) {
      print("Error fetching playlist: $e");
    } finally {
      isLoading.value = false;
    }
  }
}