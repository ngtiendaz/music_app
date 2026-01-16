// lib/modules/home/bindings/home_binding.dart
import 'package:get/get.dart';
import 'package:music_app/data/repositories/home_repository.dart';
import 'package:music_app/modules/home/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Inject Repository trước
    Get.lazyPut<HomeRepository>(() => HomeRepository());
    
    // 2. Inject Controller (Controller sẽ tìm Repository tự động qua Get.find)
    Get.lazyPut<HomeController>(() => HomeController(homeRepository: Get.find()));
  }
}