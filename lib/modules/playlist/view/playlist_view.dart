import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:music_app/modules/playlist/controller/playlist_controller.dart';
import 'package:music_app/modules/player/controller/player_controller.dart';
import 'package:music_app/widget/bottom_nav_menu.dart';
import 'package:music_app/widget/mini_player.dart';
import 'package:music_app/widget/song_items.dart';

class PlaylistView extends GetView<PlaylistController> {
  const PlaylistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();
    
    // 1. Controller để bắt sự kiện cuộn
    final ScrollController scrollController = ScrollController();
    final RxBool showAppBarTitle = false.obs;

    scrollController.addListener(() {
      // Khi kéo qua 250px (gần hết ảnh), kích hoạt hiệu ứng hiện title trên Bar
      if (scrollController.offset > 250 && !showAppBarTitle.value) {
        showAppBarTitle.value = true;
      } else if (scrollController.offset <= 250 && showAppBarTitle.value) {
        showAppBarTitle.value = false;
      }
    });

    final double bottomSafePadding = MediaQuery.of(context).padding.bottom;
    final double menuHeight = kBottomNavigationBarHeight + bottomSafePadding;
    final double listBottomPadding = menuHeight + 64 + 20;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // LỚP 1: NỘI DUNG CUỘN
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final playlist = controller.playlistDetail.value;
            if (playlist == null) {
              return const Center(child: Text("Không tìm thấy playlist", style: TextStyle(color: Colors.white)));
            }

            return CustomScrollView(
              controller: scrollController, // Gắn controller
              physics: const BouncingScrollPhysics(),
              slivers: [
                // --- A. AppBar ---
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 300.0,
                  backgroundColor: const Color(0xFF121212),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                    onPressed: () => Get.back(),
                  ),
                  
                  // --- TITLE NHỎ (Chỉ hiện khi cuộn lên) ---
                  centerTitle: true,
                  title: Obx(() => AnimatedSlide(
                    // Hiệu ứng dịch chuyển từ dưới lên
                    offset: showAppBarTitle.value ? Offset.zero : const Offset(0, 0.5),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutQuart,
                    child: AnimatedOpacity(
                      // Hiệu ứng mờ dần
                      opacity: showAppBarTitle.value ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          playlist.title ?? '',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  )),

                  actions: [
                    IconButton(icon: const Icon(Icons.favorite_border, color: Colors.white), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.more_horiz, color: Colors.white), onPressed: () {}),
                  ],
                  
                  // --- ẢNH NỀN (Bỏ title ở đây để không bị đè) ---
                  flexibleSpace: FlexibleSpaceBar(
                    title: null, // QUAN TRỌNG: Để null để không hiện chữ đè lung tung
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(playlist.thumbnailM ?? '', fit: BoxFit.cover),
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

                // --- B. TITLE TO & INFO (Nằm ở Body để sát viền) ---
                SliverToBoxAdapter(
                  child: Padding(
                    // Padding 16 giúp chữ sát viền trái (thẳng hàng nút Back)
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title to nằm ở đây
                        Text(
                          playlist.title ?? '',
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 24, 
                            fontWeight: FontWeight.bold
                          ),
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
                            Icon(Icons.music_note, color: Colors.green, size: 20),
                            SizedBox(width: 8),
                            Text("Dành riêng cho bạn", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                         ),
                         
                        const SizedBox(height: 8),
                        Text("${playlist.like ?? 0} lượt thích • ${playlist.songItems?.length ?? 0} bài hát", style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                        
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            IconButton(onPressed: (){}, icon: const Icon(Icons.favorite_border, color: Colors.grey, size: 28)),
                            IconButton(onPressed: (){}, icon: const Icon(Icons.download_for_offline_outlined, color: Colors.grey, size: 28)),
                            IconButton(onPressed: (){}, icon: const Icon(Icons.more_horiz, color: Colors.grey, size: 28)),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                if(playlist.songItems != null && playlist.songItems!.isNotEmpty){
                                   Get.find<PlayerController>().playSong(playlist.songItems![0]);
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

                // --- C. LIST SONGS ---
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final song = playlist.songItems![index];
                      return SongItem(
                        song: song,
                        onTap: () {
                          Get.find<PlayerController>().playSong(song);
                        },
                        onMoreTap: () {},
                      );
                    },
                    childCount: playlist.songItems?.length ?? 0,
                  ),
                ),
                
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