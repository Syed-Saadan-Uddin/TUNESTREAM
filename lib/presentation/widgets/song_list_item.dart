import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme.dart';
import '../../data/models/song_model.dart';
import '../bloc/playlist/playlist_bloc.dart';
import 'add_to_playlist_dialog.dart';
import '../../core/theme.dart';

class SongListItem extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;

  const SongListItem({super.key, required this.song, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                song.coverUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    song.artists.join(', '),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          //color: AppTheme.textColor.withOpacity(0.7),
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            _buildMoreOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreOptions(BuildContext context) {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        bool isLiked = false;
        if (state is PlaylistLoaded) {
          isLiked = state.likedSongIds.contains(song.id);
        }

        return PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppTheme.lightPrimaryAccent),
          onSelected: (value) {
            if (value == 'like') {
              if (isLiked) {
                context.read<PlaylistBloc>().add(UnlikeSong(song.id));
              } else {
                context.read<PlaylistBloc>().add(LikeSong(song.id));
              }
            } else if (value == 'playlist') {
              showDialog(
                context: context,
                builder: (_) => AddToPlaylistDialog(song: song),
              );
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'like',
              child: Row(
                children: [
                  Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: AppTheme.primaryAccent),
                  const SizedBox(width: 8),
                  Text(isLiked ? 'Unlike' : 'Like'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'playlist',
              child: Row(
                children: [
                  Icon(Icons.playlist_add, color: AppTheme.textColor),
                  SizedBox(width: 8),
                  Text('Add to Playlist'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}