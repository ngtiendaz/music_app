import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:music_app/modules/home/view/home_view.dart';
import 'package:music_app/modules/search/view/search_view.dart';
import 'package:music_app/widget/bottom_nav_menu.dart';
import 'package:music_app/widget/mini_player.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Định nghĩa các màn hình con
    // Nên dùng const nếu có thể để tránh rebuild không cần thiết
    // Lưu ý: Không đặt list này vào trong Obx để tránh tạo instance mới liên tục
    final List<Widget> pages = [
      HomeView(),
      const SearchView(), // Thêm const nếu Constructor của SearchView cho phép
    ];

    // Tính toán chiều cao safe area
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final double bottomBarHeight = kBottomNavigationBarHeight + bottomPadding;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      
      body: Stack(
        children: [
          // Lớp 1: Nội dung chính (IndexedStack)
          // Obx chỉ bọc phần index thay đổi, không bọc việc tạo Widget
          Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: pages, 
          )),

          // Lớp 2: MiniPlayer
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomBarHeight, 
            child: const MiniPlayerView(),
          ),
        ],
      ),
      
      // Bottom Navigation
      bottomNavigationBar: Obx(() => BottomNavMenu(
        currentIndex: controller.tabIndex.value,
        onItemTapped: controller.changeTabIndex,
      )),
    );
  }
}