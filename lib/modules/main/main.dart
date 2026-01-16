import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/core/constants/colors.dart';
import 'package:music_app/data/repositories/music_repository.dart';
import 'package:music_app/modules/player/controller/player_controller.dart';
import 'package:music_app/routes/app_pages.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Zing MP3 Clone',
      debugShowCheckedModeBanner: false,

      // --- CẤU HÌNH BINDING TOÀN CỤC (QUAN TRỌNG) ---
      initialBinding: BindingsBuilder(() {
        // 1. Inject Repository để gọi API
        Get.put(MusicRepository());
        
        // 2. Inject PlayerController (Permanent = true để sống mãi mãi)
        // Controller này quản lý việc phát nhạc, cần có mặt ở mọi nơi
        Get.put(PlayerController(musicRepository: Get.find()), permanent: true);
      }),

      // --- CẤU HÌNH ROUTE ---
      initialRoute: AppPages.INITIAL, // Thường là '/' trỏ về MainView
      getPages: AppPages.routes,

      // --- CẤU HÌNH THEME ---
      themeMode: ThemeMode.dark, 
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background, 
        primaryColor: AppColors.primary,
        useMaterial3: true,

        // Cấu hình AppBar mặc định
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Trong suốt để thấy nền
          elevation: 0,
          centerTitle: false, // Căn trái title (iOS style)
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),

        // Cấu hình Bottom Navigation Bar (Cho MainView)
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1C1C1E), // Màu xám tối (giống thanh tab bar iOS/Spotify)
          selectedItemColor: AppColors.textPrimary, // Màu icon khi chọn (Trắng)
          unselectedItemColor: AppColors.textGrey,  // Màu icon khi không chọn (Xám)
          selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 10),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),

        // Cấu hình Font chữ mặc định
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
          titleMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        
        // Cấu hình Slider (Thanh trượt nhạc)
        sliderTheme: SliderThemeData(
          activeTrackColor: Colors.white,
          inactiveTrackColor: Colors.grey[800],
          thumbColor: Colors.white,
          trackHeight: 2,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
        ),
      ),
    );
  }
}