import 'package:get/get.dart';
import 'package:music_app/modules/dashboard/binding/dashboard_binding.dart';
import 'package:music_app/modules/dashboard/view/dashboard_view.dart';
import 'package:music_app/modules/playlist/binding/playlist_binding.dart';
import 'package:music_app/modules/playlist/view/playlist_view.dart';
import 'package:music_app/modules/song/binding/song_binding.dart';
import 'package:music_app/modules/song/view/song_view.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.DASHBOARD;

  static final routes = [
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),),
      GetPage(
      name: Routes.SONG,
      page: () => const SongView(),
      binding: SongBinding(), 
    ),
    GetPage(
  name: Routes.PLAYLIST_DETAIL,
  page: () => const PlaylistView(),
  binding: PlaylistBinding(),
),
  ];
  
}