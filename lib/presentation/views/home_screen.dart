import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/song/song_bloc.dart';
import '../widgets/song_list_item.dart';
import '../widgets/genre_chip.dart';
import '../../data/models/song_model.dart';
import '../bloc/player/player_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedGenre;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongBloc, SongState>(
      builder: (context, state) {
        if (state is SongLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SongLoaded) {
          final uniqueGenres = ['All', ...state.songs.map((s) => s.genre).toSet()];
          
          final filteredSongs = _selectedGenre == null || _selectedGenre == 'All'
              ? state.songs
              : state.songs.where((s) => s.genre == _selectedGenre).toList();

          return ListView(
            padding: const EdgeInsets.only(bottom: 160), 
            children: [
              _buildSectionHeader(context, "By Genre"),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: uniqueGenres.length,
                  itemBuilder: (context, index) {
                    final genre = uniqueGenres[index];
                    return GenreChip(
                      genre: genre,
                      isSelected: _selectedGenre == genre || (_selectedGenre == null && genre == 'All'),
                      onTap: () {
                        setState(() {
                          _selectedGenre = genre;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionHeader(context, _selectedGenre ?? 'All Songs'),
              ...filteredSongs.map((song) => SongListItem(
                    song: song,
                    onTap: () => context.read<PlayerBloc>().add(PlaySong(song, filteredSongs)),
                  )),
            ],
          );
        }
        return const Center(child: Text('Failed to load songs.'));
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}