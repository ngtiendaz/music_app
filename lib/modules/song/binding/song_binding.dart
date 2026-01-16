import 'package:get/get.dart';
import 'package:music_app/data/repositories/music_repository.dart';
import 'package:music_app/modules/song/controller/song_controller.dart';
class SongBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MusicRepository>(() => MusicRepository());
    Get.lazyPut<SongController>(() => SongController(repository: Get.find()));
  }
}