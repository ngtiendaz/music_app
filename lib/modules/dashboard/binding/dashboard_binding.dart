import 'package:get/get.dart';
import 'package:music_app/data/repositories/home_repository.dart';
import 'package:music_app/data/repositories/music_repository.dart';
import 'package:music_app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:music_app/modules/home/controller/home_controller.dart';
import 'package:music_app/modules/player/controller/player_controller.dart';
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // LazyPut: Chỉ khởi tạo Controller khi cần dùng để tiết kiệm RAM
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<MusicRepository>(() => MusicRepository()); 
    Get.lazyPut<HomeRepository>(() => HomeRepository()); 
    Get.lazyPut<HomeController>(() => HomeController(homeRepository: Get.find()));
    Get.put<PlayerController>(PlayerController(musicRepository: Get.find()), permanent: true);

  }
}