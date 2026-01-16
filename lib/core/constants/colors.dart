import 'package:flutter/material.dart';

class AppColors {
  // Màu nền chính (Đen tuyền giống SoundCloud)
  static const Color background = Color(0xFF000000); 
  
  // Màu nền của các Card/Box (Xám rất tối)
  static const Color surface = Color(0xFF121212);
  
  // Màu nền của Bottom Navigation Bar (thường nhạt hơn nền chính 1 chút hoặc đen hẳn)
  static const Color bottomNavBackground = Color(0xFF0C0C0C);

  // Màu chủ đạo (SoundCloud dùng màu Cam, hoặc bạn có thể dùng Tím của bạn)
  static const Color primary = Color(0xFFFF5500); // SoundCloud Orange
  // static const Color primary = Colors.deepPurple; // Hoặc giữ màu tím cũ

  // Màu chữ
  static const Color textPrimary = Color(0xFFFFFFFF); // Trắng tinh
  static const Color textSecondary = Color(0xFFAAAAAA); // Xám nhạt
  static const Color textGrey = Color(0xFF757575); // Xám đậm hơn

  // Màu Gradient (Cho cái card "Your Likes")
  static const Color gradientStart = Color(0xFFFF5500);
  static const Color gradientEnd = Color(0xFF8F2600);
}