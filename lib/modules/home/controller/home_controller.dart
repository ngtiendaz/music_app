// lib/modules/home/controller/home_controller.dart
import 'package:get/get.dart';
import 'package:music_app/data/models/home_model.dart';
import 'package:music_app/data/repositories/home_repository.dart';

class HomeController extends GetxController {
  final HomeRepository homeRepository;

  HomeController({required this.homeRepository});

  // Biến trạng thái (Reactive)
  var isLoading = true.obs;
  var homeData = Rxn<HomeResponse>(); // Rxn là biến có thể null
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getHomeData();
  }

  // Hàm gọi API
  void getHomeData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await homeRepository.getHomeData();
      if (response != null && response.err == 0) {
        homeData.value = response;
      } else {
        errorMessage.value = response?.msg ?? "Lỗi không xác định";
      }
    } catch (e) {
      errorMessage.value = "Lỗi kết nối: $e";
    } finally {
      isLoading.value = false;
    }
  }

  // Hàm xử lý khi user click vào playlist
  void onPlaylistClick(String encodeId) {
    print("Click Playlist: $encodeId");
    // TODO: Navigate to Playlist Detail
    // Get.toNamed(Routes.PLAYLIST_DETAIL, arguments: encodeId);
  }
}