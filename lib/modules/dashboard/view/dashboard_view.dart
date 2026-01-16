// lib/modules/dashboard/view/dashboard_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:music_app/modules/home/view/home_view.dart';
import 'package:music_app/modules/song/view/song_view.dart';
import 'package:music_app/widget/bottom_nav_menu.dart';
import 'package:music_app/widget/mini_player.dart'; // Import PlayerView full

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Tính toán chiều cao safe area (phần tai thỏ/phím home ảo dưới đáy)
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    
    // Chiều cao mặc định của BottomNavigationBar là 56 (kToolbarHeight)
    // Tổng chiều cao cần đẩy lên = 56 + khoảng cách an toàn dưới đáy
    final double bottomBarHeight = kBottomNavigationBarHeight + bottomPadding;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true, // Cho phép nội dung tràn xuống dưới đáy (để tạo hiệu ứng kính mờ cho Menu)
      
      body: Stack(
        children: [
          // Lớp 1: Nội dung chính
          Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: [
              HomeView(),
              Container(color: Colors.black, child: const Center(child: Text("Tab 2", style: TextStyle(color: Colors.white)))), 
              SongView(),
            ],
          )),

          // Lớp 2: MiniPlayer
          Positioned(
            left: 0,
            right: 0,
            // --- SỬA Ở ĐÂY: Đẩy MiniPlayer lên trên BottomBar ---
            bottom: bottomBarHeight, 
            child: const MiniPlayerView(),
          ),
        ],
      ),
      
      bottomNavigationBar: Obx(() => BottomNavMenu(
        currentIndex: controller.tabIndex.value,
        onItemTapped: controller.changeTabIndex,
      )),
    );
  }
}