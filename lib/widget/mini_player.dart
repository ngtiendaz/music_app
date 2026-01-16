import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/modules/player/controller/player_controller.dart';
import 'package:music_app/modules/player/view/player_view.dart';
import 'package:music_app/widget/scrolling_text.dart';

class MiniPlayerView extends StatelessWidget {
  const MiniPlayerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();

    return Obx(() {
      final song = controller.currentSong.value;
      if (song == null) return const SizedBox.shrink();

      // Hàm mở Player Full
      void openPlayer() {
        Get.to(
          () => const PlayerView(),
          transition: Transition.downToUp, // Hiệu ứng trồi lên từ dưới
          duration: const Duration(milliseconds: 300),
          
          // --- QUAN TRỌNG: CHO PHÉP NHÌN XUYÊN THẤU ---
          opaque: false, 
          // -------------------------------------------
          
          fullscreenDialog: true, // Giúp hiệu ứng vuốt mượt hơn trên iOS
        );
      }

      return GestureDetector(
        // Bấm vào thì mở
        onTap: openPlayer,
        
        // Vuốt lên cũng mở (Giữ nguyên logic cũ)
        onVerticalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) < 0) {
             openPlayer();
          }
        },

        child: Container(
          height: 64,
          margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                // 1. Lớp nền
                Positioned.fill(
                  child: Image.network(
                    song.thumbnailM ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
                // 2. Lớp phủ
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
                    child: Container(
                      color: const Color(0xFF181818).withOpacity(0.75),
                    ),
                  ),
                ),
                // 3. Nội dung
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          song.thumbnail ?? '',
                          width: 48, height: 48, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: Colors.grey[800], width: 48, height: 48),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                              child: ScrollingText(
                                text: song.title ?? 'Unknown Title',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              song.artistsNames ?? 'Unknown Artist',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.devices, color: Colors.white70, size: 22),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            visualDensity: VisualDensity.compact,
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => controller.togglePlayPause(),
                            child: Icon(
                              controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ],
                  ),
                ),
                // 4. Progress Bar
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Obx(() {
                    final duration = controller.duration.value.inSeconds.toDouble();
                    final position = controller.position.value.inSeconds.toDouble();
                    final value = (duration > 0) ? (position / duration) : 0.0;
                    return LinearProgressIndicator(
                      value: value.clamp(0.0, 1.0),
                      minHeight: 2.0,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}