// lib/modules/player/controllers/mini_player_controller.dart
import 'package:get/get.dart';
import 'package:music_app/modules/player/controller/player_controller.dart';

class MiniPlayerController extends GetxController {
  // Lấy instance của PlayerController đã được put permanent
  final playerController = Get.find<PlayerController>();

  // Biến để ẩn/hiện Mini Player (ví dụ: khi đang ở màn hình Player full thì ẩn mini đi)
  var isVisible = true.obs; 
}