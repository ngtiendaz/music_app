import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/data/models/song.dart';
import 'package:music_app/data/models/lyric.dart'; 
import 'package:music_app/data/repositories/music_repository.dart';
import 'package:palette_generator/palette_generator.dart';

class PlayerController extends GetxController {
  final MusicRepository musicRepository;
  PlayerController({required this.musicRepository});

  final AudioPlayer audioPlayer = AudioPlayer();
  
  // Controller cho Scroll View của Lyric
  final ScrollController lyricScrollController = ScrollController();

  // --- VARIABLES ---
  var currentSong = Rxn<Song>();
  var isPlaying = false.obs;
  var isLoading = false.obs;
  var position = Duration.zero.obs;
  var duration = Duration.zero.obs;
  var backgroundColor = Rx<Color>(const Color(0xFF000000));

  // QUẢN LÝ LYRIC
  var currentLyric = Rxn<Lyric>(); // Dữ liệu lời
  var currentLyricIndex = 0.obs;   // Index câu đang hát
  var isLyricLoading = false.obs;

  // QUẢN LÝ PLAYLIST
  var playlist = <Song>[].obs;
  var currentIndex = 0.obs;
  var loopMode = LoopMode.off.obs; 
  var isShuffle = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    // 1. Trạng thái phát nhạc
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        _handleAutoNext();
      }
    });

    // 2. Vị trí phát -> Đồng bộ Lyric
    audioPlayer.positionStream.listen((p) {
      position.value = p;
      _syncLyric(p); 
    });

    // 3. Thời lượng bài hát
    audioPlayer.durationStream.listen((d) {
      if (d != null) duration.value = d;
    });
  }

  // --- LOGIC PHÁT NHẠC ---
  Future<void> playSong(Song song, {List<Song>? newPlaylist}) async {
    try {
      isLoading.value = true;
      
      if (newPlaylist != null) playlist.assignAll(newPlaylist);
      if (playlist.isEmpty) playlist.add(song);
      int index = playlist.indexWhere((e) => e.encodeId == song.encodeId);
      if (index != -1) currentIndex.value = index;

      currentSong.value = song;
      _updatePalette(song.thumbnailM); 

      // TẢI LYRIC MỚI
      _fetchLyric(song.encodeId ?? '');

      await audioPlayer.stop(); 
      position.value = Duration.zero;
      duration.value = Duration.zero;

      final sourceMap = await musicRepository.getSongSource(song.encodeId ?? '');
      
      if (sourceMap != null && sourceMap['128'] != null) {
        await audioPlayer.setUrl(sourceMap['128']);
        
        if (loopMode.value == LoopMode.one) {
          await audioPlayer.setLoopMode(LoopMode.one);
        } else {
          await audioPlayer.setLoopMode(LoopMode.off);
        }

        audioPlayer.play();
      } else {
        Get.snackbar("Lỗi", "Không tìm thấy nguồn nhạc");
        nextSong(); 
      }
    } catch (e) {
      print("Play error: $e");
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  // --- LOGIC LYRIC ---

  Future<void> _fetchLyric(String songId) async {
    isLyricLoading.value = true;
    currentLyric.value = null; // Reset lyric cũ
    currentLyricIndex.value = 0;

    try {
      final lyric = await musicRepository.getLyric(songId);
      if (lyric != null) {
        currentLyric.value = lyric;
      }
    } catch (e) {
      print("Lyric error: $e");
    } finally {
      isLyricLoading.value = false;
    }
  }

  // Đồng bộ thời gian thực: So sánh position với startTime
  void _syncLyric(Duration currentPosition) {
    if (currentLyric.value == null || currentLyric.value!.sentences == null) return;

    final sentences = currentLyric.value!.sentences!;
    int activeIndex = -1;

    for (int i = 0; i < sentences.length; i++) {
      if (currentPosition.inMilliseconds >= sentences[i].startTime) {
        activeIndex = i;
      } else {
        break; 
      }
    }

    if (activeIndex != -1 && activeIndex != currentLyricIndex.value) {
      currentLyricIndex.value = activeIndex;
      // Lưu ý: Việc gọi hàm cuộn (_scrollToCenter) đã được chuyển sang View
      // Controller chỉ cần update index là View tự lắng nghe
    }
  }

  // Hàm này để View gọi khi cần cuộn lại ngay lập tức (sau khi thả tay)
  void syncLyricImmediately() {
    // Logic này thực tế đã nằm ở View (_scrollToCenter),
    // nhưng giữ lại hàm này nếu muốn gọi từ logic khác
  }

  // --- CÁC HÀM CONTROL KHÁC ---

  void togglePlayPause() {
    if (isPlaying.value) audioPlayer.pause(); else audioPlayer.play();
  }

  void seekTo(Duration position) => audioPlayer.seek(position);

  void nextSong() {
    if (playlist.isEmpty) return;
    int nextIndex;
    if (isShuffle.value) {
      nextIndex = Random().nextInt(playlist.length);
    } else {
      nextIndex = currentIndex.value + 1;
    }

    if (nextIndex >= playlist.length) {
      if (loopMode.value == LoopMode.all) nextIndex = 0; else return;
    }
    playSong(playlist[nextIndex]);
  }

  void previousSong() {
    if (playlist.isEmpty) return;
    if (position.value.inSeconds > 5) { seekTo(Duration.zero); return; }
    int prevIndex = currentIndex.value - 1;
    if (prevIndex < 0) prevIndex = playlist.length - 1;
    playSong(playlist[prevIndex]);
  }

  void cycleLoopMode() {
    if (loopMode.value == LoopMode.off) {
      loopMode.value = LoopMode.all;
      audioPlayer.setLoopMode(LoopMode.off);
      Get.snackbar("Chế độ", "Lặp lại danh sách", duration: const Duration(seconds: 1));
    } else if (loopMode.value == LoopMode.all) {
      loopMode.value = LoopMode.one;
      audioPlayer.setLoopMode(LoopMode.one);
      Get.snackbar("Chế độ", "Lặp lại 1 bài", duration: const Duration(seconds: 1));
    } else {
      loopMode.value = LoopMode.off;
      audioPlayer.setLoopMode(LoopMode.off);
      Get.snackbar("Chế độ", "Tắt lặp lại", duration: const Duration(seconds: 1));
    }
  }

  void toggleShuffle() {
    isShuffle.value = !isShuffle.value;
    Get.snackbar("Trộn bài", isShuffle.value ? "Bật" : "Tắt", duration: const Duration(seconds: 1));
  }

  void _handleAutoNext() {
    if (loopMode.value != LoopMode.one) nextSong();
  }

  Future<void> _updatePalette(String? imageUrl) async {
    if (imageUrl == null) { backgroundColor.value = Colors.black; return; }
    try {
      final generator = await PaletteGenerator.fromImageProvider(
        NetworkImage(imageUrl), size: const Size(100, 100)
      );
      Color? newColor = generator.mutedColor?.color ?? 
                        generator.darkMutedColor?.color ?? 
                        generator.dominantColor?.color;
      backgroundColor.value = newColor ?? Colors.black;
    } catch (_) {
      backgroundColor.value = Colors.black;
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    lyricScrollController.dispose(); 
    super.onClose();
  }
  
  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }
}