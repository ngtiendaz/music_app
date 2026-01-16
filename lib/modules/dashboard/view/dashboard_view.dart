import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:music_app/modules/dashboard/view/bottom_nav_menu.dart';
import 'package:music_app/modules/home/view/home_view.dart';
import 'package:music_app/modules/player/view/player_view.dart';
import 'package:music_app/modules/song/view/song_view.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.tabIndex.value, // Lắng nghe thay đổi index
        children: const [
          HomeView(),
          PlayerView(),
          SongView(),
        ],
      )),
      bottomNavigationBar: Obx(() => BottomNavMenu(
        currentIndex: controller.tabIndex.value, // Lắng nghe thay đổi index
        onItemTapped: controller.changeTabIndex, // Gọi hàm trong controller
      )),
    );
  }
}