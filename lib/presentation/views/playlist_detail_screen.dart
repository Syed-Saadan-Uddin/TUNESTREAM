import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme.dart';
import '../../data/models/playlist_model.dart';
import '../bloc/player/player_bloc.dart';
import '../bloc/playlist/playlist_bloc.dart';
import '../bloc/song/song_bloc.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final String playlistId;
  const PlaylistDetailScreen({super.key, required this.playlistId});

  void _showDeleteConfirmationDialog(BuildContext context, Playlist playlist) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Playlist'),
        content: Text('Are you sure you want to delete the playlist "${playlist.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              context.read<PlaylistBloc>().add(DeletePlaylist(playlist.id));
              Navigator.of(ctx).pop(); 
              Navigator.of(context).pop(); 
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, playlistState) {
        if (playlistState is! PlaylistLoaded) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        
        final playlist = playlistState.playlists.firstWhere(
          (p) => p.id == playlistId,
          orElse: () => const Playlist(id: '', name: 'Not Found', songIds: []),
        );

        if (playlist.id.isEmpty) {
          
          return const Scaffold(body: Center(child: Text('Playlist not found.')));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(playlist.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_forever_outlined),
                tooltip: 'Delete Playlist',
                onPressed: () => _showDeleteConfirmationDialog(context, playlist),
              ),
            ],
          ),
          
          body: BlocBuilder<SongBloc, SongState>(
            builder: (context, songState) {
              if (songState is! SongLoaded) {
                return const Center(child: CircularProgressIndicator());
              }

              
              final playlistSongs = songState.songs
                  .where((song) => playlist.songIds.contains(song.id))
                  .toList();

              if (playlistSongs.isEmpty) {
                return const Center(
                  child: Text('This playlist is empty.', style: TextStyle(fontSize: 18)),
                );
              }

              return ListView.builder(
                itemCount: playlistSongs.length,
                itemBuilder: (context, index) {
                  final song = playlistSongs[index];
                  return ListTile(
                    leading: Image.network(song.coverUrl, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(song.name),
                    subtitle: Text(song.artists.join(', ')),
                    onTap: () {
                      context.read<PlayerBloc>().add(PlaySong(song, playlistSongs));
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: AppTheme.primaryAccent),
                      tooltip: 'Remove from playlist',
                      onPressed: () {
                        // Dispatch the event to remove the song
                        context.read<PlaylistBloc>().add(RemoveSongFromPlaylist(
                          playlistId: playlist.id,
                          songId: song.id,
                        ));
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}