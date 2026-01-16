// lib/modules/home/views/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/modules/home/controller/home_controller.dart';
import 'package:music_app/modules/home/view/widget/home_banner_slider.dart';
import 'package:music_app/modules/home/view/widget/home_playlist_section.dart';
import 'package:music_app/widget/custom_app_bar.dart';


class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: "Khám phá",
        avatarUrl: "https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_jpeg/avatars/1/4/a/9/14a9d7a2ab18978197a2ee4bf34c7a72.jpg", // Link test
        onAvatarTap: () {
          print("Bấm vào Avatar");
          // Get.toNamed(Routes.PROFILE);
        },
      ),
      // Sử dụng Obx để lắng nghe thay đổi từ Controller
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value, style: TextStyle(color: Colors.white)),
                ElevatedButton(
                  onPressed: () => controller.getHomeData(),
                  child: Text("Thử lại"),
                )
              ],
            ),
          );
        }

        final sections = controller.homeData.value?.data?.items ?? [];

        return ListView.builder(
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];

            // Render widget dựa trên sectionType
            switch (section.sectionType) {
              case 'banner':
                return HomeBannerSlider(banners: section.banners ?? []);
              
              case 'playlist':
                return HomePlaylistSection(
                  title: section.title ?? '',
                  playlists: section.playlists ?? [],
                );
              
              case 'new-release':
                // TODO: Tạo widget riêng cho New Release (bạn có thể làm tương tự Playlist)
                return SizedBox.shrink(); 
              
              default:
                return const SizedBox.shrink();
            }
          },
        );
      }),
    );
  }
}