import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'core/constants/colors.dart'; // Import file màu vừa tạo

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Daz Music',
      debugShowCheckedModeBanner: false,
      
      // CẤU HÌNH THEME DARK MODE Ở ĐÂY
      themeMode: ThemeMode.dark, // Ép buộc chạy chế độ tối
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background, // Nền đen toàn app
        primaryColor: AppColors.primary,
        
        // Cấu hình AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),

        // Cấu hình Bottom Navigation Bar
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.bottomNavBackground,
          indicatorColor: AppColors.primary.withOpacity(0.2), // Màu nền khi tab được chọn
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          iconTheme: MaterialStateProperty.resolveWith((states) {
             if (states.contains(MaterialState.selected)) {
               return const IconThemeData(color: AppColors.textPrimary);
             }
             return const IconThemeData(color: AppColors.textGrey);
          }),
        ),
        
        // Cấu hình font chữ mặc định là màu trắng
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
        
        useMaterial3: true,
      ),

      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}