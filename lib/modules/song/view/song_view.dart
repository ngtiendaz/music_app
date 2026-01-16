import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/modules/song/controller/song_controller.dart';

class SongView extends StatefulWidget {
  const SongView({super.key});

  @override
  State<SongView> createState() => _SongViewState();
}

class _SongViewState extends State<SongView> {
  // Tìm Controller đã được inject từ Binding
  final SongController controller = Get.find<SongController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chi tiết bài hát")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dùng Obx để lắng nghe thay đổi trạng thái UI
            Obx(() {
              // 1. Trạng thái Loading
              if (controller.isLoading.value) {
                return const CircularProgressIndicator();
              }

              final song = controller.currentSong.value;
              
              // 2. Trạng thái chưa có dữ liệu hoặc null
              if (song == null) {
                return const Text(
                  "Chưa có dữ liệu.\nBấm nút bên dưới để tải.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                );
              }

              // 3. Trạng thái có dữ liệu
              return Column(
                children: [
                  if (song.thumbnailM != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
                        ]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(song.thumbnailM!, height: 400, width: 400, fit: BoxFit.cover),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    song.title ?? "Unknown Title",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    song.artistsNames ?? "Unknown Artist",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              );
            }),
            const SizedBox(height: 40), 
            ElevatedButton.icon(
              onPressed: () {
                // ID bài hát ví dụ
                controller.loadSongDetail("Z7A960DB");
              },
              icon: const Icon(Icons.cloud_download),
              label: const Text("Tải bài hát"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
             ElevatedButton.icon(
              onPressed: () {
                // ID bài hát ví dụ
                controller.loadSongSource("Z7A960DB");
              },
              icon: const Icon(Icons.play_circle_outlined),
              label: const Text("Phát bài hát"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}