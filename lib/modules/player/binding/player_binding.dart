import 'package:get/get.dart';
import 'package:music_app/data/repositories/music_repository.dart';
import 'package:music_app/modules/player/controller/player_controller.dart';

class PlayerBinding extends Bindings {
  @override
  void dependencies() {
    // Inject MusicRepository nếu chưa có (thường đã có ở HomeBinding hoặc main)
    Get.lazyPut<MusicRepository>(() => MusicRepository());
    Get.lazyPut<PlayerController>(() => PlayerController(musicRepository: Get.find()));
  }
}