import 'package:get/get.dart';
import 'package:music_app/data/repositories/music_repository.dart';
import 'package:music_app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:music_app/modules/song/controller/song_controller.dart';
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // LazyPut: Chỉ khởi tạo Controller khi cần dùng để tiết kiệm RAM
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<MusicRepository>(() => MusicRepository()); 
    Get.lazyPut<SongController>(() => SongController(repository: Get.find()));
  }
}