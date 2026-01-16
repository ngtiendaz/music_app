import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:music_app/data/apis/apis_home.dart'; // Import class ApisHome vừa tạo
import 'package:music_app/data/models/home_model.dart'; // Import model HomeResponse

class HomeRepository {
  /// Gọi API lấy dữ liệu trang chủ thông qua ApisHome
  Future<HomeResponse?> getHomeData({RxBool? isLoading}) async {
    return await ApisHome.getHomeData(isLoading: isLoading);
  }
}