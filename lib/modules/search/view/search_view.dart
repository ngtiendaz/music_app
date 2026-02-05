import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/modules/search/controller/search_controller.dart';
import 'package:music_app/modules/player/controller/player_controller.dart';
import 'package:music_app/widget/search_items.dart';
import 'package:music_app/widget/song_items.dart'; // File ArtistItem, PlaylistItemCard vừa tạo

class SearchView extends GetView<SearchPageController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text("Tìm kiếm", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              // SEARCH BAR
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                child: TextField(
                  controller: controller.textController,
                  focusNode: controller.focusNode,
                  onChanged: controller.onSearchChanged,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "Bạn muốn nghe gì?",
                    hintStyle: const TextStyle(color: Colors.black54),
                    prefixIcon: const Icon(Icons.search, color: Colors.black87),
                    suffixIcon: Obx(() => controller.keyword.isNotEmpty
                        ? IconButton(icon: const Icon(Icons.close, color: Colors.black), onPressed: controller.clearSearch)
                        : const SizedBox.shrink()),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // BODY CONTENT
              Expanded(
                child: Obx(() {
                  // 1. Loading
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  }

                  // 2. Màn hình mặc định (Chưa nhập gì)
                  if (controller.keyword.isEmpty) {
                    return _buildDefaultUI();
                  }

                  // 3. Hiển thị kết quả tìm kiếm
                  final data = controller.searchData.value;
                  if (data == null) {
                    return const Center(child: Text("Không tìm thấy kết quả", style: TextStyle(color: Colors.grey)));
                  }

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SECTION: NGHỆ SĨ (Ngang)
                        if (data.artists != null && data.artists!.isNotEmpty) ...[
                          _buildSectionTitle("Nghệ sĩ"),
                          SizedBox(
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.artists!.length,
                              itemBuilder: (context, index) {
                                return ArtistItem(
                                  artist: data.artists![index],
                                  onTap: () => controller.goToArtistPlaylist(data.artists![index]),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // SECTION: PLAYLIST (Ngang)
                        if (data.playlists != null && data.playlists!.isNotEmpty) ...[
                          _buildSectionTitle("Playlist & Album"),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.playlists!.length,
                              itemBuilder: (context, index) {
                                return PlaylistItemCard(
                                  playlist: data.playlists![index],
                                  onTap: () => controller.goToPlaylist(data.playlists![index]),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // SECTION: BÀI HÁT (Dọc)
                        if (data.songs != null && data.songs!.isNotEmpty) ...[
                          _buildSectionTitle("Bài hát"),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(), // Tắt cuộn riêng
                            shrinkWrap: true, // Co lại theo nội dung
                            itemCount: data.songs!.length,
                            itemBuilder: (context, index) {
                              final song = data.songs![index];
                              return SongItem(
                                song: song,
                                onTap: () => Get.find<PlayerController>().playSong(song),
                                onMoreTap: () {},
                              );
                            },
                          ),
                        ],
                        const SizedBox(height: 100), // Padding đáy
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  // Giao diện mặc định (Category, Explore)
  Widget _buildDefaultUI() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Khám phá nội dung mới mẻ"),
          SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.exploreItems.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = controller.exploreItems[index];
                return Container(
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(item['image']!),
                      fit: BoxFit.cover,
                      opacity: 0.7,
                    ),
                  ),
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(8),
                  child: Text(item['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle("Duyệt tìm tất cả"),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: controller.browseCategories.length,
            itemBuilder: (context, index) {
              final cat = controller.browseCategories[index];
              return Container(
                decoration: BoxDecoration(color: cat['color'], borderRadius: BorderRadius.circular(6)),
                padding: const EdgeInsets.all(10),
                child: Text(cat['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              );
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}