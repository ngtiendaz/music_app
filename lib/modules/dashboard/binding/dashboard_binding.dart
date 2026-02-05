import 'package:get/get.dart';
import 'package:music_app/data/repositories/home_repository.dart';
import 'package:music_app/data/repositories/music_repository.dart';
import 'package:music_app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:music_app/modules/home/controller/home_controller.dart';
import 'package:music_app/modules/player/controller/player_controller.dart';
import 'package:music_app/modules/search/controller/search_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Repositories (Khởi tạo trước để các Controller có thể tìm thấy)
    Get.lazyPut<MusicRepository>(() => MusicRepository());
    Get.lazyPut<HomeRepository>(() => HomeRepository());

    // 2. Dashboard Controller
    Get.lazyPut<DashboardController>(() => DashboardController());

    // 3. Child Controllers (Home & Search)
    // Lưu ý: Vì dùng IndexedStack, Controller sẽ được tạo khi tab được mở lần đầu
    // và sẽ sống cùng với Dashboard.
    Get.lazyPut<HomeController>(() => HomeController(homeRepository: Get.find()));
    Get.lazyPut<SearchPageController>(() => SearchPageController(musicRepository: Get.find()));

    // 4. Player Controller (Sống vĩnh viễn trong phiên chạy)
    // Dùng Get.put để khởi tạo ngay lập tức vì MiniPlayer luôn hiển thị
    Get.put<PlayerController>(
      PlayerController(musicRepository: Get.find()), 
      permanent: true
    );
  }
}