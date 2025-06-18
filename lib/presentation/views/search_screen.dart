import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/song/song_bloc.dart';
import '../bloc/player/player_bloc.dart';
import '../../core/theme.dart';
import '../widgets/song_list_item.dart';
import '../../data/models/song_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Song> _filteredSongs = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final songState = context.read<SongBloc>().state;
    if (songState is SongLoaded) {
      _filteredSongs = songState.songs;
    }
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final songState = context.read<SongBloc>().state;
    if (songState is SongLoaded) {
      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        setState(() => _filteredSongs = songState.songs);
      } else {
        setState(() {
          _filteredSongs = songState.songs.where((song) {
            return song.name.toLowerCase().contains(query) ||
                song.artists.join(' ').toLowerCase().contains(query) ||
                song.album.toLowerCase().contains(query);
          }).toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse our library'), elevation: 0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Songs, artists, albums...',
                hintStyle: TextStyle(
                  color: Colors.white, 
                ),
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Colors.white,
                filled: true,
                fillColor: AppTheme.primarySurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 160),
              itemCount: _filteredSongs.length,
              itemBuilder: (context, index) {
                final song = _filteredSongs[index];
                return SongListItem(
                  song: song,
                  onTap: () {
                     final songState = context.read<SongBloc>().state as SongLoaded;
                     context.read<PlayerBloc>().add(PlaySong(song, songState.songs));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}