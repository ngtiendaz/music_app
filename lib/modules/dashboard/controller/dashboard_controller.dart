import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Biến lưu trạng thái tab hiện tại, dùng .obs để lắng nghe thay đổi
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }
}