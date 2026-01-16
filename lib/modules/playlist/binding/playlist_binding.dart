import 'package:get/get.dart';
import 'package:music_app/data/repositories/music_repository.dart';
import 'package:music_app/modules/playlist/controller/playlist_controller.dart';

class PlaylistBinding extends Bindings {
  @override
  void dependencies() {
    // Inject Controller
    Get.lazyPut<PlaylistController>(() => PlaylistController(musicRepository: Get.find()));
  }
}