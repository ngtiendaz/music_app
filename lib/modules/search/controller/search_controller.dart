import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/data/models/search_result.dart';
import 'package:music_app/data/repositories/music_repository.dart';
import 'package:music_app/modules/playlist/binding/playlist_binding.dart';
import 'package:music_app/modules/playlist/view/playlist_view.dart';

class SearchPageController extends GetxController {
  final MusicRepository musicRepository;
  SearchPageController({required this.musicRepository});

  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final RxBool isLoading = false.obs;
  final RxString keyword = ''.obs;
  
  // Biến chứa kết quả tìm kiếm tổng hợp
  final Rx<SearchResult?> searchData = Rx<SearchResult?>(null);

  // --- Dữ liệu UI Mặc định ---
  final exploreItems = <Map<String, String>>[
    {"title": "#vietnamese trap", "image": "https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_jpeg/avatars/1/4/a/9/14a9d7a2ab18978197a2ee4bf34c7a72.jpg"},
    {"title": "#v-pop", "image": "https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_jpeg/avatars/1/4/a/9/14a9d7a2ab18978197a2ee4bf34c7a72.jpg"},
  ];
  final browseCategories = <Map<String, dynamic>>[
    {"title": "Nhạc", "color": Colors.pink, "image": ""},
    {"title": "Podcast", "color": Colors.teal, "image": ""},
    {"title": "Sự kiện", "color": Colors.purple, "image": ""},
    {"title": "Dành Cho Bạn", "color": Colors.indigo, "image": ""},
  ];

  @override
  void onInit() {
    super.onInit();
    // Debounce: Đợi 500ms sau khi ngừng gõ mới gọi API
    debounce(keyword, (String val) {
      if (val.trim().isNotEmpty) {
        fetchSearch(val);
      } else {
        searchData.value = null; // Clear data
      }
    }, time: const Duration(milliseconds: 500));
  }

  void onSearchChanged(String val) => keyword.value = val;

  void clearSearch() {
    textController.clear();
    keyword.value = '';
    searchData.value = null;
    focusNode.unfocus();
  }

 Future<void> fetchSearch(String query) async {
    isLoading.value = true;
    try {
      // Dùng hàm searchFullData để lấy cả Artist, Playlist và Song
      // Nếu dùng hàm searchSong cũ, biến searchData sẽ bị lỗi kiểu dữ liệu
      final SearchResult? result = await musicRepository.searchFullData(query);
      
      if (result != null) {
        searchData.value = result;
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Chuyển sang màn hình Playlist khi bấm vào Nghệ sĩ
  void goToArtistPlaylist(Artist artist) {
    if (artist.playlistId != null) {
      // Điều hướng đến PlaylistView và truyền ID playlist của nghệ sĩ
      Get.to(
        () => const PlaylistView(),
        binding: PlaylistBinding(),
        arguments: artist.playlistId, 
      );
    } else {
      Get.snackbar("Thông báo", "Nghệ sĩ này chưa có playlist", colorText: Colors.white);
    }
  }
  
  // Chuyển sang màn hình Playlist khi bấm vào Playlist Item
  void goToPlaylist(Playlist playlist) {
      Get.to(
        () => const PlaylistView(),
        binding: PlaylistBinding(),
        arguments: playlist.encodeId, 
      );
  }

  @override
  void onClose() {
    textController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}