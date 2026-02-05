import 'package:flutter/material.dart';
import 'package:music_app/data/models/search_result.dart';

// 1. Item Nghệ sĩ (Hình tròn)
class ArtistItem extends StatelessWidget {
  final Artist artist;
  final VoidCallback onTap;

  const ArtistItem({Key? key, required this.artist, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100, // Chiều rộng cố định
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            ClipOval(
              child: Image.network(
                artist.thumbnail ?? "",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey, width: 100, height: 100),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              artist.name ?? "Nghệ sĩ",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const Text(
              "Nghệ sĩ",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}

// 2. Item Playlist (Hình vuông bo góc)
class PlaylistItemCard extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback onTap;

  const PlaylistItemCard({Key? key, required this.playlist, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                playlist.thumbnailM ?? "",
                width: 140,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey, width: 140, height: 140),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              playlist.title ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
            ),
            Text(
              playlist.artistsNames ?? "Nhiều nghệ sĩ",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}