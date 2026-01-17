import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/modules/player/controller/player_controller.dart';
import 'package:music_app/widget/scrolling_text.dart'; // Widget chữ chạy bạn đã tạo

class PlayerView extends GetView<PlayerController> {
  const PlayerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Nền đen
      body: Obx(() {
        final song = controller.currentSong.value;
        if (song == null) return const Center(child: Text("Chưa chọn bài hát", style: TextStyle(color: Colors.white)));

        // --- BƯỚC 1: Bọc Stack trong GestureDetector ---
        return GestureDetector(
          // Bắt sự kiện khi người dùng nhấc tay khỏi màn hình sau khi vuốt dọc
          onVerticalDragEnd: (details) {
            // details.primaryVelocity > 0 nghĩa là vuốt xuống
            // details.primaryVelocity < 0 nghĩa là vuốt lên
            // Giá trị 500 là độ nhạy (tốc độ vuốt), số càng lớn cần vuốt càng nhanh
            if ((details.primaryVelocity ?? 0) > 500) {
              Get.back(); // Đóng màn hình
            }
          },
          
          child: Stack(
            children: [
              // 1. Ảnh nền mờ (Background Blur)
              Positioned.fill(
                child: Image.network(
                  song.thumbnailM ?? '',
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.6), // Làm tối ảnh nền
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              
              // 2. Nội dung chính
              SafeArea(
                child: Column(
                  children: [
                    // --- Header (Nút đóng) ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.white, size: 40),
                            onPressed: () => Get.back(), // Đóng màn hình player
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                
                                Text(
                                  song.album?.title ?? "Bài hát gợi ý",
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_horiz, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // --- Ảnh đĩa quay (Artwork) ---
                    Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(song.thumbnailM ?? ''),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                           BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, spreadRadius: 5),
                        ]
                      ),
                    ),

                    const Spacer(),

                    // --- Thông tin bài hát ---
                   Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SỬ DỤNG SCROLLING TEXT (Chỉ chạy khi dài)
                                SizedBox(
                                  height: 30, // Chiều cao cố định
                                  child: ScrollingText(
                                    text: song.title ?? "Unknown",
                                    style: const TextStyle(
                                      color: Colors.white, 
                                      fontSize: 22, 
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 5),
                                
                                Text(
                                  song.artistsNames ?? "Unknown Artist",
                                  style: TextStyle(color: Colors.grey[400], fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 40),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- Thanh trượt (Slider) ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 2,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                              activeTrackColor: Colors.white,
                              inactiveTrackColor: Colors.grey[800],
                              thumbColor: Colors.white,
                            ),
                            child: Slider(
                              value: controller.position.value.inSeconds.toDouble(),
                              min: 0.0,
                              max: controller.duration.value.inSeconds.toDouble() > 0 
                                  ? controller.duration.value.inSeconds.toDouble() 
                                  : 1.0,
                              onChanged: (value) {
                                controller.seekTo(Duration(seconds: value.toInt()));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(controller.formatDuration(controller.position.value), 
                                    style: const TextStyle(color: Colors.white, fontSize: 12)),
                                Text(controller.formatDuration(controller.duration.value), 
                                    style: const TextStyle(color: Colors.white, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // --- Các nút điều khiển ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shuffle, color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_previous, color: Colors.white, size: 36),
                          onPressed: () {},
                        ),
                        // Nút Play/Pause
                        GestureDetector(
                          onTap: () => controller.togglePlayPause(),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: controller.isLoading.value 
                                ? const CircularProgressIndicator(color: Colors.black)
                                : Icon(
                                    controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next, color: Colors.white, size: 36),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.loop, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),

                    // Bottom Actions
                    const SizedBox(height: 20),
                    const Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Icon(Icons.speaker_group_outlined, color: Colors.white),
                            Icon(Icons.share_outlined, color: Colors.white),
                           Icon(Icons.playlist_play, color: Colors.white),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}