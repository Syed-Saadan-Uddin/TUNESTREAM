import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/playlist/playlist_bloc.dart';
import '../bloc/song/song_bloc.dart';
import '../widgets/playlist_grid_item.dart';
import '../widgets/song_list_item.dart';
import '../widgets/for_you_view.dart';
import '../bloc/player/player_bloc.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        
        if (authState.status == AuthStatus.guest) {
          return _buildGuestPrompt(context);
        }

        
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            
            appBar: TabBar(
              indicatorColor: Theme.of(context).colorScheme.primary,
              labelColor: Theme.of(context).colorScheme.primary,
              tabs: const [
                Tab(text: 'Playlists'),
                Tab(text: 'Liked'),
                Tab(text: 'For You'),
              ],
            ),
            body: BlocBuilder<PlaylistBloc, PlaylistState>(
              builder: (context, playlistState) {
                if (playlistState is! PlaylistLoaded) {
                  
                  return const Center(child: CircularProgressIndicator());
                }

               
                return TabBarView(
                  children: [
                    _buildPlaylistsGrid(context, playlistState),
                    _buildLikedSongsList(context, playlistState),
                    const ForYouView(),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  
  Widget _buildGuestPrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ensure you have this animation file in assets/animations/
            Lottie.asset(
              'assets/animations/login_prompt.json',
              width: 200,
            ),
            const SizedBox(height: 24),
            Text(
              'Create an Account to Build Your Library',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Sign up to create playlists, like songs, and get personalized recommendations.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              onPressed: () {
                
                context.read<AuthBloc>().add(AuthSignOutRequested());
              },
              child: const Text('Sign Up or Sign In'),
            )
          ],
        ),
      ),
    );
  }

  
  Widget _buildPlaylistsGrid(BuildContext context, PlaylistLoaded state) {
    final playlists = state.playlists;
    if (playlists.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animations/empty.json', width: 200), // Add an animation
            const Text('No playlists yet.'),
            const Text('Create one by adding a song to a new playlist.'),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16).copyWith(bottom: 160),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        return PlaylistGridItem(playlist: playlists[index]);
      },
    );
  }

  Widget _buildLikedSongsList(BuildContext context, PlaylistLoaded playlistState) {
    final likedIds = playlistState.likedSongIds;
    final songState = context.read<SongBloc>().state;

    if (likedIds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Lottie.asset('assets/animations/hearts.json', width: 200), // Add an animation
             const Text('Your liked songs will appear here.'),
          ],
        ),
      );
    }

    if (songState is! SongLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final likedSongs = songState.songs.where((s) => likedIds.contains(s.id)).toList();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 160),
      itemCount: likedSongs.length,
      itemBuilder: (context, index) {
        final song = likedSongs[index];
        return SongListItem(
          song: song,
          onTap: () {
            context.read<PlayerBloc>().add(PlaySong(song, likedSongs));
          },
        );
      },
    );
  }
}