import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/models/playlist_model.dart';
import '../views/playlist_detail_screen.dart'; // Import the new screen

class PlaylistGridItem extends StatelessWidget {
  final Playlist playlist;
  const PlaylistGridItem({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GestureDetector(
      
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => PlaylistDetailScreen(playlistId: playlist.id),
        ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: AppTheme.neumorphicDecoration(
                borderRadius: 12,
                brightness: brightness,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: playlist.coverUrl != null && playlist.coverUrl!.isNotEmpty
                    ? Image.network(
                        playlist.coverUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.music_note, size: 50);
                        },
                      )
                    : Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: const Center(
                          child: Icon(Icons.music_note, size: 50),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(playlist.name, style: Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text('${playlist.songIds.length} songs', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}