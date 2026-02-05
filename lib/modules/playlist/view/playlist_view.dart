import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/data/models/song.dart';
import 'package:music_app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:music_app/modules/playlist/controller/playlist_controller.dart';
import 'package:music_app/modules/player/controller/player_controller.dart';
import 'package:music_app/widget/bottom_nav_menu.dart';
import 'package:music_app/widget/mini_player.dart';
import 'package:music_app/widget/song_items.dart'; // Đảm bảo import đúng tên file widget SongItem

class PlaylistView extends GetView<PlaylistController> {
  const PlaylistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tìm DashboardController để xử lý BottomMenu
    final dashboardController = Get.find<DashboardController>();
    
    // Controller để bắt sự kiện cuộn cho hiệu ứng AppBar
    final ScrollController scrollController = ScrollController();
    final RxBool showAppBarTitle = false.obs;

    scrollController.addListener(() {
      // Khi kéo qua 250px, hiện title trên AppBar
      if (scrollController.offset > 250 && !showAppBarTitle.value) {
        showAppBarTitle.value = true;
      } else if (scrollController.offset <= 250 && showAppBarTitle.value) {
        showAppBarTitle.value = false;
      }
    });

    final double bottomSafePadding = MediaQuery.of(context).padding.bottom;
    final double menuHeight = kBottomNavigationBarHeight + bottomSafePadding;
    // Khoảng trống dưới cùng để không bị che bởi MiniPlayer + BottomMenu
    final double listBottomPadding = menuHeight + 64 + 20; 

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // LỚP 1: NỘI DUNG CUỘN (CustomScrollView)
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: Colors.green));
            }

            final playlist = controller.playlistDetail.value;
            if (playlist == null) {
              return const Center(child: Text("Không tìm thấy playlist", style: TextStyle(color: Colors.white)));
            }

            // Lấy danh sách bài hát để dùng chung
            final List<Song> songs = playlist.songItems ?? [];

            return CustomScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // --- A. AppBar (Hiệu ứng co giãn) ---
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 300.0,
                  backgroundColor: const Color(0xFF121212),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                    onPressed: () => Get.back(),
                  ),
                  
                  // Title nhỏ (chỉ hiện khi cuộn lên)
                  centerTitle: true,
                  title: Obx(() => AnimatedOpacity(
                    opacity: showAppBarTitle.value ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      playlist.title ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )),

                  actions: [
                    IconButton(icon: const Icon(Icons.favorite_border, color: Colors.white), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.more_horiz, color: Colors.white), onPressed: () {}),
                  ],
                  
                  // Ảnh nền Playlist
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(playlist.thumbnailM ?? '', fit: BoxFit.cover),
                        // Lớp phủ Gradient đen mờ
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withOpacity(0.8), Colors.black],
                              stops: const [0.0, 0.7, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // --- B. Thông tin Playlist & Nút Play ---
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playlist.title ?? '',
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          playlist.sortDescription ?? playlist.artistsNames ?? "Tuyển tập nhạc hay",
                          style: TextStyle(color: Colors.grey[400], fontSize: 14),
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          children: [
                            Icon(Icons.music_note, color: Color(0xFF1ED760), size: 20),
                            SizedBox(width: 8),
                            Text("Dành riêng cho bạn", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                         ),
                        const SizedBox(height: 8),
                        Text("${playlist.like ?? 0} lượt thích • ${songs.length} bài hát", 
                             style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                        
                        const SizedBox(height: 16),
                        
                        // Hàng nút thao tác
                        Row(
                          children: [
                            IconButton(onPressed: (){}, icon: const Icon(Icons.favorite_border, color: Colors.grey, size: 28)),
                            IconButton(onPressed: (){}, icon: const Icon(Icons.download_for_offline_outlined, color: Colors.grey, size: 28)),
                            IconButton(onPressed: (){}, icon: const Icon(Icons.more_horiz, color: Colors.grey, size: 28)),
                            const Spacer(),
                            
                            // --- NÚT PLAY LỚN (MÀU XANH) ---
                            GestureDetector(
                              onTap: () {
                                if(songs.isNotEmpty){
                                   // QUAN TRỌNG: Truyền bài đầu tiên VÀ danh sách nhạc
                                   Get.find<PlayerController>().playSong(
                                     songs[0], 
                                     newPlaylist: songs // <-- Để Controller biết list nhạc mà next
                                   );
                                }
                              },
                              child: Container(
                                width: 56, height: 56,
                                decoration: const BoxDecoration(color: Color(0xFF1ED760), shape: BoxShape.circle),
                                child: const Icon(Icons.play_arrow, color: Colors.black, size: 32),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // --- C. Danh sách bài hát ---
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final song = songs[index];
                      return SongItem(
                        song: song,
                        onTap: () {
                          // QUAN TRỌNG: Truyền bài được chọn VÀ danh sách nhạc
                          Get.find<PlayerController>().playSong(
                            song, 
                            newPlaylist: songs // <-- Để Controller biết list nhạc mà next
                          );
                        },
                        onMoreTap: () {},
                      );
                    },
                    childCount: songs.length,
                  ),
                ),
                
                // Khoảng trống dưới cùng
                SliverToBoxAdapter(child: SizedBox(height: listBottomPadding)),
              ],
            );
          }),

          // LỚP 2: MINI PLAYER
          Positioned(
            left: 0,
            right: 0,
            bottom: menuHeight, 
            child: const MiniPlayerView(),
          ),

          // LỚP 3: BOTTOM MENU
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(() => BottomNavMenu(
              currentIndex: dashboardController.tabIndex.value,
              onItemTapped: (index) {
                // Quay lại Dashboard rồi mới chuyển tab
                Get.back(); 
                dashboardController.changeTabIndex(index);
              },
            )),
          ),
        ],
      ),
    );
  }
}