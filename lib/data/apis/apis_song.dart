import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
// Đảm bảo import đúng file chứa class ApiBase mới của bạn
import 'package:music_app/core/network/api_base.dart'; 
import 'package:music_app/data/models/song.dart';

class ApisSong {
  static Future<Song?> getSongDetail({
    required String id,
    RxBool? isLoading,
  }) async {
    // 1. Bật loading nếu có truyền vào
    if (isLoading != null) isLoading.value = true;
    
    Song? songResult;

    try {
      // SỬA ĐỔI: Sử dụng URL từ ApiBase thay vì hardcode string
    const  String apiUrl = ApiBase.infoSong; 

      final queryParams = {
        "id": id,
      };

      log('Calling API: $apiUrl');
      log('Query params: $queryParams');

      // 2. Gọi API
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

      log('API Response Status: ${res.statusCode}');
      
      if (res.statusCode == 200) {
        final data = res.data;
        
        // Kiểm tra err code (0 là thành công)
        if (data['err'] == 0) {
          if (data['data'] != null) {
            // Parse JSON sang Model Song
            songResult = Song.fromJson(data['data']);
            log('Successfully loaded song: ${songResult.title}');
          }
        } else {
          // Xử lý khi API trả về lỗi logic
          log('API Logic Error: ${data['msg']}');
        }
      } else {
        log('API Error: Status code ${res.statusCode}');
      }

    } on DioException catch (e) {
      log('API Dio Error: ${e.message}');
      log('Response data: ${e.response?.data}');
    } catch (e) {
      log('API General Error: $e');
    } finally {
      // 4. Tắt loading
      if (isLoading != null) isLoading.value = false;
    }

    return songResult;
  }
  // Hàm lấy link nhạc để phát (Streaming Source)
  static Future<Map<String, dynamic>?> getSongSource({
    required String id,
    RxBool? isLoading,
  }) async {
    // 1. Bật loading
    if (isLoading != null) isLoading.value = true;

    Map<String, dynamic>? sourceResult;

    try {
      // Dùng endpoint /song như trong ảnh Postman
      // Đảm bảo trong ApiBase bạn đã khai báo: static const song = '${baseURL}song';
      const String apiUrl = ApiBase.song; 

      final queryParams = {
        "id": id,
      };

      log('Calling API Source: $apiUrl');
      log('Params: $queryParams');

      // 2. Gọi API GET
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

      // 3. Xử lý kết quả
      if (res.statusCode == 200) {
        final data = res.data;
        // Check err = 0 là thành công
        if (data['err'] == 0) {
          if (data['data'] != null) {
            // Trả về object data chứa các link nhạc {"128": "...", "320": "..."}
            sourceResult = data['data'];
            log('Successfully loaded source: $sourceResult');
          }
        } else {
          log('API Logic Error: ${data['msg']}');
        }
      } else {
        log('API Error: Status code ${res.statusCode}');
      }
    } on DioException catch (e) {
      log('API Dio Error: ${e.message}');
    } catch (e) {
      log('API General Error: $e');
    } finally {
      // 4. Tắt loading
      if (isLoading != null) isLoading.value = false;
    }

    return sourceResult;
  }
}