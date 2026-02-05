import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
// Đảm bảo import đúng file chứa class ApiBase mới của bạn
import 'package:music_app/core/network/api_base.dart';
import 'package:music_app/data/models/lyric.dart';
import 'package:music_app/data/models/search_result.dart'; 
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

  // Hàm tìm kiếm bài hát theo từ khóa
  static Future<List<Song>> searchSong({
    required String keyword,
    RxBool? isLoading,
  }) async {
    // 1. Bật loading
    if (isLoading != null) isLoading.value = true;

    List<Song> searchResults = [];

    try {
      // Giả định trong ApiBase bạn đã định nghĩa: static const search = '/api/search';
      // Hoặc thay bằng đường dẫn cụ thể tương ứng với ảnh Postman của bạn
      const String apiUrl = ApiBase.search; 
      final queryParams = {
        "keyword": keyword, // Khớp với tham số 'keyword' trong ảnh Postman
      };

      log('Calling Search API: $apiUrl');
      log('Keyword: $keyword');

      // 2. Gọi API GET
      final res = await ApiBase.dio.get(
        apiUrl,
        queryParameters: queryParams,
      );

      // 3. Xử lý kết quả
      if (res.statusCode == 200) {
        final data = res.data;
        
        // Kiểm tra cấu trúc JSON của bạn (thông thường là data['err'] == 0 hoặc data['data'])
        if (data['err'] == 0 && data['data'] != null) {
          // Nếu API trả về một list trong data['data']['items'] hoặc tương tự
          // Tùy vào cấu trúc JSON thực tế của API tìm kiếm, bạn có thể cần chỉnh lại dòng dưới:
          var items = data['data']['items'] ?? []; 
          
          searchResults = (items as List)
              .map((item) => Song.fromJson(item))
              .toList();
              
          log('Found ${searchResults.length} songs for keyword: $keyword');
        }
      } else {
        log('Search API Error: Status code ${res.statusCode}');
      }
    } on DioException catch (e) {
      log('Search API Dio Error: ${e.message}');
    } catch (e) {
      log('Search API General Error: $e');
    } finally {
      // 4. Tắt loading
      if (isLoading != null) isLoading.value = false;
    }

    return searchResults;
  }
  static Future<SearchResult?> searchFull({
    required String keyword,
    RxBool? isLoading,
  }) async {
    if (isLoading != null) isLoading.value = true;
    SearchResult? result;

    try {
       const String apiUrl = ApiBase.search; 
      final queryParams = {"keyword": keyword};
      log('Calling Search Full: $apiUrl');

      final res = await ApiBase.dio.get(apiUrl, queryParameters: queryParams);

      if (res.statusCode == 200) {
        final data = res.data;
        if (data['err'] == 0 && data['data'] != null) {
          // Parse toàn bộ cục data sang SearchResult
          result = SearchResult.fromJson(data['data']);
        }
      }
    } catch (e) {
      log('Search Full Error: $e');
    } finally {
      if (isLoading != null) isLoading.value = false;
    }
    return result;
  }
  static Future<Lyric?> getLyric({
    required String id,
  }) async {
    try {
      // Endpoint: /api/lyric
       const String apiUrl = ApiBase.lyric; 
      
      final queryParams = {"id": id};
      
      log('Calling Lyric API: $apiUrl - ID: $id');

      final res = await ApiBase.dio.get(
        apiUrl,
        queryParameters: queryParams,
      );

      if (res.statusCode == 200) {
        final data = res.data;
        // Check err = 0 và có data
        if (data['err'] == 0 && data['data'] != null) {
          return Lyric.fromJson(data['data']);
        }
      }
    } catch (e) {
      log('Lyric API Error: $e');
    }
    return null;
  }
}