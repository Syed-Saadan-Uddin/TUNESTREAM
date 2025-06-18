import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/song_model.dart';
import '../../data/repositories/song_repository.dart';
import '../bloc/player/player_bloc.dart';
import '../bloc/song/song_bloc.dart';
import 'song_list_item.dart';

class ForYouView extends StatefulWidget {
  const ForYouView({super.key});

  @override
  State<ForYouView> createState() => _ForYouViewState();
}

class _ForYouViewState extends State<ForYouView> {
  late Future<List<Song>> _trendingSongsFuture;

  @override
  void initState() {
    super.initState();
    _trendingSongsFuture = context.read<SongRepository>().fetchTrendingSongs();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 160),
      children: [
        _buildSectionHeader(context, "Trending Now"),
        
        FutureBuilder<List<Song>>(
          future: _trendingSongsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No trending songs yet.'));
            }
            final songs = snapshot.data!;
            return Column(
              children: songs.map((song) => SongListItem(
                song: song,
                onTap: () => context.read<PlayerBloc>().add(PlaySong(song, songs)),
              )).toList(),
            );
          },
        ),
        
        const SizedBox(height: 20),

        
        _buildSectionHeader(context, "Because You're Listening To..."),
        BlocBuilder<PlayerBloc, PlayerState>(
          builder: (context, playerState) {
            // If no song is playing, show a prompt.
            if (playerState.currentSong == null) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Play a song to get recommendations!'),
                ),
              );
            }

            final currentGenre = playerState.currentSong!.genre;
            final currentSongId = playerState.currentSong!.id;

            
            return BlocBuilder<SongBloc, SongState>(
              builder: (context, songState) {
                if (songState is! SongLoaded) {
                  return const SizedBox.shrink();
                }

                
                final recommendedSongs = songState.songs.where((song) {
                  return song.genre == currentGenre && song.id != currentSongId;
                }).toList();

                if (recommendedSongs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No other songs found in this genre.'),
                    ),
                  );
                }

                
                return Column(
                  children: recommendedSongs.map((song) => SongListItem(
                    song: song,
                    onTap: () => context.read<PlayerBloc>().add(PlaySong(song, recommendedSongs)),
                  )).toList(),
                );
              },
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}