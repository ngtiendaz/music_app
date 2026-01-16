import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? avatarUrl; // Link ảnh đại diện (có thể null)
  final VoidCallback? onAvatarTap;
  final List<Widget>? actions; // Danh sách các nút hành động bên phải (tùy chọn)

  const CustomAppBar({
    Key? key,
    required this.title,
    this.avatarUrl,
    this.onAvatarTap,
    this.actions, // Nhận danh sách widget từ bên ngoài
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black, // Nền đen
      elevation: 0, // Bỏ bóng đổ
      automaticallyImplyLeading: false, // Tắt nút back mặc định
      titleSpacing: 20, // Khoảng cách từ mép trái
      centerTitle: false, // Quan trọng: Đảm bảo tiêu đề căn trái trên cả iOS và Android

      // Phần bên trái: Avatar + Tiêu đề
      title: Row(
        // Cập nhật theo yêu cầu: Căn phần tử về phía bắt đầu (trái)
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, 
        children: [
          // 1. Avatar
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[800],
                image: avatarUrl != null
                    ? DecorationImage(
                        image: NetworkImage(avatarUrl!),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage('assets/images/default_avatar.png'),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),

          const SizedBox(width: 12), // Khoảng cách giữa Avatar và Tên

          // 2. Tiêu đề
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      // Phần bên phải: Hiển thị danh sách actions được truyền vào (nếu có)
      actions: [
        if (actions != null) ...actions!,
        const SizedBox(width: 10), // Padding cố định bên phải ngoài cùng cho đẹp
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}