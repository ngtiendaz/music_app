import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/modules/player/controller/player_controller.dart';

class LyricView extends StatefulWidget {
  const LyricView({Key? key}) : super(key: key);

  @override
  State<LyricView> createState() => _LyricViewState();
}

class _LyricViewState extends State<LyricView> {
  final PlayerController controller = Get.find<PlayerController>();
  bool isUserScrolling = false;
  Timer? _scrollTimer;
  
  // GIẢM KHOẢNG CÁCH DÒNG: 60.0 (Gọn hơn, tinh tế hơn)
  final double itemHeight = 60.0; 

  @override
  void initState() {
    super.initState();
    ever(controller.currentLyricIndex, (index) {
      if (!isUserScrolling) {
        _scrollToCenter(index);
      }
    });
  }

  void _scrollToCenter(int index) {
    if (controller.lyricScrollController.hasClients) {
      // Tính chiều cao khả dụng (trừ đi padding trên dưới)
      double screenHeight = MediaQuery.of(context).size.height;
      double topPadding = MediaQuery.of(context).padding.top + kToolbarHeight + 20; // +20 extra padding
      double bottomPadding = screenHeight * 0.5;
      
      // Chiều cao vùng nhìn thấy của listview
      // Lưu ý: Expanded flex cũng ảnh hưởng, nhưng ở đây ta tính tương đối
      double visibleListHeight = screenHeight - topPadding - 180; // Trừ khoảng cho controls

      // Công thức căn giữa:
      // Offset = (Vị trí dòng) - (Một nửa vùng nhìn thấy) + (Một nửa dòng)
      double targetOffset = (index * itemHeight) - (visibleListHeight / 2) + (itemHeight / 2);

      if (targetOffset < 0) targetOffset = 0;

      controller.lyricScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic, 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double topSafeHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
    final double bottomPadding = MediaQuery.of(context).size.height * 0.5;

    return Obx(() => Scaffold(
      extendBodyBehindAppBar: true, 
      backgroundColor: Colors.transparent, 
      
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 32),
          onPressed: () => Get.back(),
        ),
        title: Column(
          children: [
            Text(
              controller.currentSong.value?.title ?? "",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
              const SizedBox(height: 2),
            Text(
              controller.currentSong.value?.artistsNames ?? "",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white70),
              maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              controller.backgroundColor.value,
              Color.alphaBlend(Colors.black.withOpacity(0.4), controller.backgroundColor.value),
            ],
          ),
        ),
        child: Column(
          children: [
            // Đẩy nội dung xuống dưới AppBar
            SizedBox(height: topSafeHeight),

            // --- 1. LYRIC LIST ---
            Expanded(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent, 
                      Colors.white,       
                      Colors.white,
                      Colors.transparent  
                    ],
                    stops: [0.0, 0.1, 0.85, 1.0], 
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Obx(() {
                  if (controller.isLyricLoading.value) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white54));
                  }

                  final lyric = controller.currentLyric.value;
                  if (lyric == null || lyric.sentences == null || lyric.sentences!.isEmpty) {
                    return _buildEmptyState();
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollStartNotification) {
                        isUserScrolling = true;
                        _scrollTimer?.cancel();
                      } else if (scrollNotification is ScrollEndNotification) {
                        _scrollTimer = Timer(const Duration(seconds: 2), () {
                          if (mounted) {
                            setState(() { isUserScrolling = false; });
                            _scrollToCenter(controller.currentLyricIndex.value);
                          }
                        });
                      }
                      return false;
                    },
                    child: ListView.builder(
                      controller: controller.lyricScrollController,
                      physics: const BouncingScrollPhysics(),
                      itemExtent: itemHeight, 
                      padding: EdgeInsets.only(
                        left: 28, 
                        right: 28, 
                        top: 20, 
                        bottom: bottomPadding 
                      ),
                      itemCount: lyric.sentences!.length,
                      itemBuilder: (context, index) {
                        final sentence = lyric.sentences![index];
                        
                        return Obx(() {
                          final currentIndex = controller.currentLyricIndex.value;
                          
                          // LOGIC MÀU SẮC MỚI:
                          // - isPastOrCurrent (index <= currentIndex): Đã/Đang phát -> TRẮNG
                          // - Future (index > currentIndex): Chưa phát -> ĐEN MỜ
                          final bool isPastOrCurrent = index <= currentIndex;

                          return Container(
                            alignment: Alignment.centerLeft,
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                              style: TextStyle(
                                fontSize: 26, // Cỡ chữ vẫn to rõ
                                height: 1.1, // Line height thấp hơn để các dòng gần nhau hơn
                                fontFamily: 'Roboto', 
                                fontWeight: FontWeight.w900, // Đậm
                                color: isPastOrCurrent 
                                    ? Colors.white // Đã/Đang hát: Trắng
                                    : Colors.black.withOpacity(0.5), // Chưa hát: Đen mờ
                              ),
                              child: Text(
                                sentence.content,
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  );
                }),
              ),
            ),

            // --- 2. CONTROLS ---
            _buildBottomControls(context),
          ],
        ),
      ),
    ));
  }

  // ... (Giữ nguyên các hàm _buildEmptyState và _buildBottomControls)
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_note_rounded, color: Colors.white.withOpacity(0.3), size: 80),
          const SizedBox(height: 16),
          Text(
            "Lời bài hát đang được cập nhật",
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.share_outlined, color: Colors.white.withOpacity(0.9), size: 26),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_horiz_rounded, color: Colors.white.withOpacity(0.9), size: 30),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              SizedBox(
                height: 20, 
                child: Obx(() => SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3, 
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: Colors.white,
                    trackShape: const RoundedRectSliderTrackShape(),
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
                )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                      controller.formatDuration(controller.position.value),
                      style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                    )),
                    Obx(() => Text(
                      "-${controller.formatDuration(controller.duration.value - controller.position.value)}",
                      style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                    )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() => GestureDetector(
            onTap: () => controller.togglePlayPause(),
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: controller.isLoading.value
                  ? const Padding(
                      padding: EdgeInsets.all(22.0),
                      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
                    )
                  : Icon(
                      controller.isPlaying.value ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.black,
                      size: 48,
                    ),
            ),
          )),
        ],
      ),
    );
  }
}