import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:music_app/data/models/song.dart';
import 'package:music_app/data/repositories/music_repository.dart';

class SongController extends GetxController {
  final MusicRepository repository;

  // Constructor nhận Repository (Dependency Injection)
  SongController({required this.repository});

  // --- State Variables ---
  var isLoading = false.obs;
  var currentSong = Rxn<Song>();
  var currentAudioUrl = Rxn<String>();
  // Thêm biến theo dõi trạng thái đang phát hay đang dừng
  var isPlaying = false.obs;

  final AudioPlayer audioPlayer = AudioPlayer();
  @override
  void onInit() {
    super.onInit();
  }
  @override
  void onClose() {
    // 3. Giải phóng bộ nhớ khi tắt controller
    audioPlayer.dispose();
    super.onClose();
  }

  // Hàm gọi qua Repository
  Future<void> loadSongDetail(String id) async {
    try {
      // Gọi repo, truyền biến isLoading vào để tự động cập nhật true/false
      final song = await repository.getSongDetail(id, isLoading: isLoading);
      
      if (song != null) {
        currentSong.value = song;
        log("Controller: Đã cập nhật song - ${song.title}");
        log("Song ID - ${song.encodeId}");
      } else {
        log("Controller: Không tìm thấy bài hát");
      }
    } catch (e) {
      log("Controller Error: $e");
    }
  }
  Future<void> loadSongSource(String id) async {
    try {
      final sources = await repository.getSongSource(id, isLoading: isLoading);
      
      if (sources != null) {
        String? finalUrl = sources['128'];

        if (finalUrl == null || finalUrl == "VIP") {
           Get.snackbar("Lỗi", "Bài hát yêu cầu VIP");
        } else {
           currentAudioUrl.value = finalUrl;
           log("Controller: Link nhạc: $finalUrl");
           
           // 4. Bắt đầu phát nhạc ngay khi có link 
           playMusic(finalUrl);
        }
      } 
    } catch (e) {
      log("Error Source: $e");
    }
  }

  // 5. Hàm điều khiển phát nhạc
  Future<void> playMusic(String url) async {
    try {
      // Dừng bài cũ (nếu có)
      await audioPlayer.stop(); 
      
      // Phát bài mới từ URL
      await audioPlayer.play(UrlSource(url));
      
      isPlaying.value = true;
    } catch (e) {
      log("Lỗi phát nhạc: $e");
    }
  }

  // 6. Hàm Pause/Resume (Dùng cho nút Play/Pause trên UI)
  Future<void> togglePlay() async {
    if (isPlaying.value) {
      await audioPlayer.pause();
      isPlaying.value = false;
    } else {
      await audioPlayer.resume();
      isPlaying.value = true;
    }
  }
  
}