import 'package:get/get.dart';
import 'package:music_app/data/repositories/music_repository.dart'; // Đảm bảo đúng đường dẫn file Repository của bạn
import 'package:music_app/modules/search/controller/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Inject Repository (nếu chưa được inject ở main binding)
    Get.lazyPut<MusicRepository>(() => MusicRepository());

    // 2. Inject SearchController
    Get.lazyPut<SearchPageController>(() => SearchPageController(musicRepository: Get.find()));
  }
}