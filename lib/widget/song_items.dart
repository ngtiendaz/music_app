import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/data/models/song.dart';
import 'package:music_app/modules/player/controller/player_controller.dart';
import 'package:music_app/widget/playing_indicator.dart';

// Import widget PlayingIndicator (nếu bạn để file riêng)
// import 'path/to/playing_indicator.dart';

class SongItem extends StatelessWidget {
  final Song song;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const SongItem({
    Key? key,
    required this.song,
    this.onTap,
    this.onMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Tìm PlayerController
    final PlayerController playerController = Get.find<PlayerController>();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        // 2. Bọc nội dung trong Obx để cập nhật giao diện khi đổi bài
        child: Obx(() {
          // Logic kiểm tra bài hát đang phát
          final currentSong = playerController.currentSong.value;
          final bool isSelected = currentSong != null && currentSong.encodeId == song.encodeId;
          final bool isPlaying = playerController.isPlaying.value;

          // Màu chữ: Nếu đang chọn thì màu Xanh, còn lại màu Trắng
          final Color titleColor = isSelected ? const Color(0xFF1ED760) : Colors.white;

          return Row(
            children: [
              // --- ẢNH BÌA & HIỆU ỨNG ---
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      song.thumbnailM ?? '',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      // Nếu đang phát thì làm tối ảnh đi một chút để hiện icon rõ hơn
                      color: isSelected ? Colors.black.withOpacity(0.6) : null,
                      colorBlendMode: isSelected ? BlendMode.darken : null,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[800],
                          child: const Icon(Icons.music_note, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  
                  // Hiển thị Sóng nhạc nếu bài này đang được chọn
                  if (isSelected)
                    PlayingIndicator(isPlaying: isPlaying),
                ],
              ),
              
              const SizedBox(width: 12),

              // --- THÔNG TIN BÀI HÁT ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên bài hát (Đổi màu khi active)
                    Text(
                      song.title ?? "Unknown Title",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: titleColor, // <-- Màu thay đổi ở đây
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Tên ca sĩ
                    Text(
                      song.artistsNames ?? "Unknown Artist",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // --- NÚT MORE HOẶC SÓNG NHẠC ---
              // (Optional) Bạn có thể để icon sóng nhạc ở đây thay vì đè lên ảnh
              IconButton(
                onPressed: onMoreTap,
                icon: const Icon(Icons.more_horiz, color: Colors.white),
              ),
            ],
          );
        }),
      ),
    );
  }
}