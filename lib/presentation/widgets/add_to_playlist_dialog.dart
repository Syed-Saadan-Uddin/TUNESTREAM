import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme.dart';
import '../../data/models/song_model.dart';
import '../bloc/playlist/playlist_bloc.dart';

class AddToPlaylistDialog extends StatelessWidget {
  final Song song;
  const AddToPlaylistDialog({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final newPlaylistController = TextEditingController();

    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        if (state is! PlaylistLoaded) return const Dialog(child: CircularProgressIndicator());

        return AlertDialog(
          backgroundColor: AppTheme.primarySurface,
          title: const Text('Add to Playlist'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                ...state.playlists.map((playlist) => ListTile(
                      title: Text(playlist.name),
                      onTap: () {
                        context.read<PlaylistBloc>().add(AddSongToPlaylist(playlist.id, song.id, song.coverUrl));
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to ${playlist.name}')));
                      },
                    )),
                const Divider(),
                
                TextField(
                  controller: newPlaylistController,
                  decoration: const InputDecoration(hintText: 'Or create new playlist'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: AppTheme.textColor)),
            ),
            TextButton(
              onPressed: () {
                if (newPlaylistController.text.isNotEmpty) {
                  
                  context.read<PlaylistBloc>().add(CreatePlaylistAndAddSong(
                        playlistName: newPlaylistController.text,
                        songToAdd: song,
                      ));
                  Navigator.of(context).pop();
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Created playlist and added song!')));
                }
              },
              child: const Text('Create', style: TextStyle(color: AppTheme.primaryAccent)),
            ),
          ],
        );
      },
    );
  }
}