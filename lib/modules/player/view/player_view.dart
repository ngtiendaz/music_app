import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/modules/player/controller/player_controller.dart';
import 'package:music_app/modules/player/view/lyric_view.dart'; // Đảm bảo import đúng đường dẫn LyricView bạn đã tạo
import 'package:music_app/widget/scrolling_text.dart';

class PlayerView extends GetView<PlayerController> {
  const PlayerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Màu xanh Spotify dùng cho các trạng thái active
    const activeColor = Color(0xFF1ED760);

    return Obx(() => Scaffold(
      backgroundColor: controller.backgroundColor.value, 
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) > 500) Get.back();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                controller.backgroundColor.value.withOpacity(0.8),
                Colors.black.withOpacity(0.6),
                Colors.black,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          
          child: SafeArea(
            child: Obx(() {
              final song = controller.currentSong.value;
              if (song == null) return const Center(child: Text("Chưa chọn bài hát", style: TextStyle(color: Colors.white)));

              return Column(
                children: [
                  // --- 1. HEADER ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.white, size: 32),
                          onPressed: () => Get.back(),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                song.album?.title ?? "Gợi ý cho bạn",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  // Dùng Spacer để đẩy Artwork và Info ra giữa nhưng không quá xa
                  const Spacer(flex: 1),

                  // --- 2. ARTWORK ---
                  Container(
                    width: 400,
                    height:400,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(song.thumbnailM ?? ''),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                         BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, spreadRadius: 2, offset: const Offset(0, 10)),
                      ]
                    ),
                  ),

                  const Spacer(flex: 1),

                  // --- 3. INFO ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 35,
                                child: ScrollingText(
                                  text: song.title ?? "Unknown",
                                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 4),
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
                          icon: const Icon(Icons.favorite_border, color: Colors.white, size: 28),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // --- 4. SLIDER ---
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
                            inactiveTrackColor: Colors.white.withOpacity(0.2),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(controller.formatDuration(controller.position.value), 
                                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                              Text(controller.formatDuration(controller.duration.value), 
                                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- 5. CONTROLS ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.shuffle, color: controller.isShuffle.value ? activeColor : Colors.white),
                        iconSize: 28,
                        onPressed: () => controller.toggleShuffle(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_previous, color: Colors.white),
                        iconSize: 42,
                        onPressed: () => controller.previousSong(),
                      ),
                      GestureDetector(
                        onTap: () => controller.togglePlayPause(),
                        child: Container(
                          width: 72, height: 72,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                          child: controller.isLoading.value 
                              ? const Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3))
                              : Icon(controller.isPlaying.value ? Icons.pause : Icons.play_arrow, color: Colors.black, size: 40),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: Colors.white),
                        iconSize: 42,
                        onPressed: () => controller.nextSong(),
                      ),
                      IconButton(
                        icon: _getLoopIcon(controller.loopMode.value, activeColor),
                        iconSize: 28,
                        onPressed: () => controller.cycleLoopMode(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- 6. LYRICS CARD (THÊM VÀO ĐÂY) ---
                  _buildLyricsCard(context),

                  const SizedBox(height: 20),
                ],
              );
            }),
          ),
        ),
      ),
    ));
  }

  // Widget hiển thị thẻ Lyrics
  Widget _buildLyricsCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Chuyển sang màn hình LyricView Full
        Get.to(() => const LyricView(), transition: Transition.downToUp);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        // Dùng chiều cao cố định hoặc linh hoạt
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          // Màu nền thẻ hơi sáng hơn nền chính một chút để nổi bật
          color: controller.backgroundColor.value.withOpacity(0.6), // Hoặc một màu cố định như Color(0xFFB54628) nếu muốn giống ảnh
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bản xem trước lời bài hát",
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 14, 
                    letterSpacing: 0.5
                  ),
                ),
                // Nút mở rộng
                Icon(Icons.open_in_full_rounded, color: Colors.white70, size: 18)
              ],
            ),
            const SizedBox(height: 12),
            
            // Hiển thị câu hát hiện tại
            Obx(() {
              if (controller.isLyricLoading.value) {
                return const Text("Đang tải lời...", style: TextStyle(color: Colors.white70, fontSize: 16));
              }
              
              final lyric = controller.currentLyric.value;
              // Kiểm tra xem có lời không
              if (lyric == null || lyric.sentences == null || lyric.sentences!.isEmpty) {
                return const Text(
                  "Hiện chưa có lời bài hát này",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                );
              }

              // Lấy câu hiện tại đang hát
              final index = controller.currentLyricIndex.value;
              final sentences = lyric.sentences!;
              String currentLine = "";
              
              if (index >= 0 && index < sentences.length) {
                currentLine = sentences[index].content;
              } else {
                currentLine = sentences.first.content; // Mặc định hiện câu đầu
              }

              return Text(
                currentLine,
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 20, 
                  fontWeight: FontWeight.bold,
                  height: 1.3
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _getLoopIcon(LoopMode mode, Color activeColor) {
    if (mode == LoopMode.off) {
      return const Icon(Icons.repeat, color: Colors.grey);
    } else if (mode == LoopMode.all) {
      return Icon(Icons.repeat, color: activeColor);
    } else {
      return Icon(Icons.repeat_one, color: activeColor);
    }
  }
}