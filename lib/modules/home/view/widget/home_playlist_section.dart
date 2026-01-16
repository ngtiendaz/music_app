import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Để dùng Get.find nếu cần gọi controller
import 'package:music_app/data/models/album.dart';
import 'package:music_app/modules/home/controller/home_controller.dart';

class HomePlaylistSection extends StatelessWidget {
  final String title;
  final List<Album> playlists;

  const HomePlaylistSection({
    Key? key,
    required this.title,
    required this.playlists,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (playlists.isEmpty) return SizedBox.shrink();
    
    // Lấy controller để gọi hàm onPlaylistClick
    final controller = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 200, // Tăng chiều cao để chứa cả ảnh và text
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final item = playlists[index];
              return GestureDetector(
                onTap: () => {
                  Get.toNamed('/playlist_detail', arguments: item.encodeId)
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.thumbnail ?? '',
                          height: 140,
                          width: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (_,__,___) => Container(height: 140, width: 140, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}