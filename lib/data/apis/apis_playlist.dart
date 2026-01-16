import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:music_app/core/network/api_base.dart';
class ApisPlaylist {

  static Future<dynamic> getDetailPlaylist({
    required String id,
    RxBool? isLoading,
  }) async {
    try {
      const String apiUrl = ApiBase.detailplaylist;

      final queryParams = {
        "id": id,
      };

      log('Calling API Detail Playlist: $apiUrl');
      log('Params: $queryParams');

      // Gọi API
      final res = await ApiBase.dio.get(
        apiUrl,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      // Xử lý dữ liệu trả về
      if (res.statusCode == 200) {
        final data = res.data;
        
        if (data['err'] == 0) {
          // Trả về cục data chứa thông tin playlist và list bài hát
          // Bạn có thể parse sang Model Playlist tại đây nếu đã tạo Model
          return data['data']; 
        } else {
          log('API Logic Error: ${data['msg']}');
          return null;
        }
      } else {
        log('API Error: Status code ${res.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      log('API Dio Error: ${e.message}');
      return null;
    } catch (e) {
      log('API General Error: $e');
      return null;
    }
  }
}