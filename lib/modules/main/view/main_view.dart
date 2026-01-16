import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/modules/home/view/home_view.dart';
import 'package:music_app/modules/main/controller/main_controller.dart';
import 'package:music_app/widget/mini_player.dart';

class MainView extends StatelessWidget {
  MainView({Key? key}) : super(key: key);
  
  final MainController controller = Get.put(MainController());

  // Danh sách các màn hình chính
  final List<Widget> pages = [
    HomeView(),
    Container(color: Colors.black, child: const Center(child: Text("Tìm kiếm", style: TextStyle(color: Colors.white)))), // Thay bằng SearchView
    Container(color: Colors.black, child: const Center(child: Text("Thư viện", style: TextStyle(color: Colors.white)))), // Thay bằng LibraryView
    Container(color: Colors.black, child: const Center(child: Text("Premium", style: TextStyle(color: Colors.white)))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Nội dung chính (Page View)
          Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: pages,
          )),

          // 2. Mini Player (Luôn nằm trên cùng, dưới BottomBar)
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0, // Dính sát đáy (trên BottomNavigationBar nếu có)
            child: MiniPlayerView(),
          ),
        ],
      ),
      
      // 3. Bottom Navigation Bar
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changeTab,
        backgroundColor: Colors.black.withOpacity(0.95), // Hơi trong suốt
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tìm kiếm"),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: "Thư viện"),
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: "Premium"),
        ],
      )),
    );
  }
}