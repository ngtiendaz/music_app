import 'dart:ui'; // Cần import để dùng ImageFilter
import 'package:flutter/material.dart';

class BottomNavMenu extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const BottomNavMenu({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        // Độ mờ nền (giữ mức vừa phải để không bị đục)
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          decoration: BoxDecoration(
            // --- YÊU CẦU 1: ĐEN HƠN NHƯNG VẪN TRONG SUỐT ---
            // Dùng màu đen với độ phủ cao (0.92) để nền rất tối giống ảnh mẫu,
            // nhưng vẫn cho phép màu sắc mạnh ở dưới ánh lên nhẹ nhàng.
            color: Colors.black.withOpacity(0.92), 
            
            // Viền trên cực mờ (hoặc bỏ hẳn nếu muốn giống hệt Spotify mới nhất)
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.05), // Rất mờ
                width: 0.5,
              ),
            ),
          ),
          child: Theme(
            // Tắt hiệu ứng ripple khi bấm
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onItemTapped,
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              
              // --- YÊU CẦU 2: ICON TO HƠN ---
              iconSize: 32, // Tăng từ 28 lên 32 để icon nổi bật, dày dặn
              
              selectedItemColor: Colors.white,
              unselectedItemColor: const Color(0xFFB3B3B3), // Xám Spotify

              // --- YÊU CẦU 3: SÁT VIỀN HƠN (TEXT GỌN) ---
              selectedLabelStyle: const TextStyle(
                fontSize: 10, // Chữ nhỏ
                fontWeight: FontWeight.w600,
                height: 1.2, // Giảm chiều cao dòng để chữ sát vào icon hơn
                letterSpacing: 0.2,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                height: 1.2, // Giảm chiều cao dòng
                letterSpacing: 0.2,
              ),

              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_filled),
                  label: 'Trang chủ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  // Dùng icon search đậm (weight 700-800) nếu có font hỗ trợ, 
                  // hoặc dùng icon mặc định to ra cũng đẹp
                  activeIcon: Icon(Icons.search, weight: 700), 
                  label: 'Tìm kiếm',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_music_outlined),
                  activeIcon: Icon(Icons.library_music),
                  label: 'Thư viện',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.workspace_premium_outlined), 
                  activeIcon: Icon(Icons.workspace_premium),
                  label: 'Premium',
                ),
                 BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_outlined),
                  activeIcon: Icon(Icons.add_box),
                  label: 'Tạo',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}