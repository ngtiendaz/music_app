import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/data/models/song.dart';
import 'package:music_app/data/repositories/music_repository.dart';

class PlayerController extends GetxController {
  final MusicRepository musicRepository;
  PlayerController({required this.musicRepository});

  // Đối tượng phát nhạc
  final AudioPlayer audioPlayer = AudioPlayer();

  // Các biến quan sát (Observable)
  var currentSong = Rxn<Song>(); // Bài hát đang phát
  var isPlaying = false.obs;
  var isLoading = false.obs;
  
  var position = Duration.zero.obs; // Vị trí hiện tại
  var duration = Duration.zero.obs; // Tổng thời gian bài hát

  @override
  void onInit() {
    super.onInit();
    
    // Lắng nghe sự kiện từ AudioPlayer
    
    // 1. Trạng thái phát (đang play hay pause)
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      // Khi phát hết bài thì tự động pause hoặc next (xử lý sau)
      if (state.processingState == ProcessingState.completed) {
        isPlaying.value = false;
        position.value = Duration.zero;
      }
    });

    // 2. Vị trí hiện tại (để cập nhật thanh trượt)
    audioPlayer.positionStream.listen((p) {
      position.value = p;
    });

    // 3. Tổng thời gian (khi load xong nhạc)
    audioPlayer.durationStream.listen((d) {
      if (d != null) duration.value = d;
    });
  }

  // Hàm quan trọng: Phát một bài hát mới
  Future<void> playSong(Song song) async {
    try {
      isLoading.value = true;
      currentSong.value = song; // Cập nhật bài hát hiện tại
      
      // Reset trạng thái cũ
      await audioPlayer.stop(); 
      position.value = Duration.zero;
      duration.value = Duration.zero;

      // 1. Lấy link streaming từ API (Dùng hàm repository bạn đã có)
      // Lưu ý: encodeId là id của bài hát
      final sourceMap = await musicRepository.getSongSource(song.encodeId ?? '');
      
      if (sourceMap != null && sourceMap['128'] != null) {
        String streamUrl = sourceMap['128']; // Lấy chất lượng 128kbps (hoặc 320 nếu có VIP)
        
        // 2. Load nguồn nhạc vào player
        await audioPlayer.setUrl(streamUrl);
        
        // 3. Phát nhạc
        audioPlayer.play();
      } else {
        Get.snackbar("Lỗi", "Không tìm thấy nguồn nhạc (VIP hoặc lỗi server)");
      }
    } catch (e) {
      print("Error playing song: $e");
      Get.snackbar("Lỗi", "Không thể phát bài hát này");
    } finally {
      isLoading.value = false;
    }
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }

  void seekTo(Duration position) {
    audioPlayer.seek(position);
  }

  @override
  void onClose() {
    audioPlayer.dispose(); // Giải phóng tài nguyên khi tắt app/controller
    super.onClose();
  }
  
  // Format thời gian từ Duration sang 03:45
  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}