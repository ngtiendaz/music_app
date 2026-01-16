import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:music_app/core/network/api_base.dart';
import 'package:music_app/data/models/home_model.dart'; // Đảm bảo import đúng đường dẫn file model HomeResponse

class ApisHome {
  /// Hàm lấy dữ liệu trang chủ (Home)
  /// Trả về đối tượng [HomeResponse] chứa danh sách các Section (Banner, Playlist,...)
  static Future<HomeResponse?> getHomeData({
    RxBool? isLoading,
  }) async {
    // 1. Bật trạng thái loading nếu có biến isLoading truyền vào
    if (isLoading != null) isLoading.value = true;

    HomeResponse? homeResult;

    try {
      // Endpoint lấy từ ApiBase (Bạn cần khai báo static const home = '/api/home' trong ApiBase)
      const String apiUrl = ApiBase.home; 

      log('Calling API Home: $apiUrl');

      // 2. Gọi API GET
      final res = await ApiBase.dio.get(
        apiUrl,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      log('API Home Response Status: ${res.statusCode}');

      // 3. Xử lý kết quả trả về
      if (res.statusCode == 200) {
        final data = res.data;

        // Kiểm tra err code (0 là thành công theo chuẩn Zing MP3)
        if (data['err'] == 0) {
          // Parse JSON sang Model HomeResponse
          // Model này sẽ tự động parse tiếp ra HomeData -> List<Section> -> List<MusicItem>
          homeResult = HomeResponse.fromJson(data);
          log('Successfully loaded Home Data with ${homeResult.data?.items?.length ?? 0} sections');
        } else {
          // Xử lý khi API trả về lỗi logic (ví dụ: bảo trì, sai token...)
          log('API Home Logic Error: ${data['msg']}');
        }
      } else {
        log('API Home Error: Status code ${res.statusCode}');
      }

    } on DioException catch (e) {
      // Xử lý lỗi thư viện Dio (Timeout, No internet, 404, 500...)
      log('API Home Dio Error: ${e.message}');
      log('Response data: ${e.response?.data}');
    } catch (e) {
      // Xử lý các lỗi khác (Parse lỗi, null pointer...)
      log('API Home General Error: $e');
    } finally {
      // 4. Tắt trạng thái loading bất kể thành công hay thất bại
      if (isLoading != null) isLoading.value = false;
    }

    return homeResult;
  }
}