import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/playlist_model.dart';
import '../../../data/models/song_model.dart';
import '../../../data/repositories/playlist_repository.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final PlaylistRepository _playlistRepository;

  PlaylistBloc({required PlaylistRepository playlistRepository})
      : _playlistRepository = playlistRepository,
        super(PlaylistInitial()) {
    on<LoadPlaylists>(_onLoadPlaylists);
    on<CreatePlaylistAndAddSong>(_onCreatePlaylistAndAddSong);
    on<AddSongToPlaylist>(_onAddSongToPlaylist);
    on<RemoveSongFromPlaylist>(_onRemoveSongFromPlaylist); 
    on<DeletePlaylist>(_onDeletePlaylist);                 
    on<LikeSong>(_onLikeSong);
    on<UnlikeSong>(_onUnlikeSong);
  }


  void _onRemoveSongFromPlaylist(
      RemoveSongFromPlaylist event, Emitter<PlaylistState> emit) async {
    await _playlistRepository.removeSongFromPlaylist(event.playlistId, event.songId);
    add(LoadPlaylists()); // Refresh the state
  }


  void _onDeletePlaylist(DeletePlaylist event, Emitter<PlaylistState> emit) async {
    await _playlistRepository.deletePlaylist(event.playlistId);
    add(LoadPlaylists()); // Refresh the state
  }



  void _onCreatePlaylistAndAddSong(
      CreatePlaylistAndAddSong event, Emitter<PlaylistState> emit) async {
    if (state is PlaylistLoaded) {
      try {
        
        final newPlaylistId = await _playlistRepository.createPlaylist(
          event.playlistName,
          event.songToAdd.coverUrl,
        );

        
        await _playlistRepository.addSongToPlaylist(
          newPlaylistId,
          event.songToAdd.id,
          event.songToAdd.coverUrl,
        );

        
        add(LoadPlaylists());
      } catch (e) {
        print("Error creating playlist and adding song: $e");
        
      }
    }
  }

  
  void _onLoadPlaylists(LoadPlaylists event, Emitter<PlaylistState> emit) async {
    emit(PlaylistLoading());
    try {
      final playlists = await _playlistRepository.fetchUserPlaylists();
      final likedSongIds = await _playlistRepository.fetchLikedSongIds();
      emit(PlaylistLoaded(playlists: playlists, likedSongIds: likedSongIds));
    } catch (_) {
      emit(PlaylistError());
    }
  }

  void _onAddSongToPlaylist(AddSongToPlaylist event, Emitter<PlaylistState> emit) async {
    if (state is PlaylistLoaded) {
      await _playlistRepository.addSongToPlaylist(event.playlistId, event.songId, event.songCoverUrl);
      add(LoadPlaylists());
    }
  }

  void _onLikeSong(LikeSong event, Emitter<PlaylistState> emit) async {
    if (state is PlaylistLoaded) {
      final currentState = state as PlaylistLoaded;
      await _playlistRepository.likeSong(event.songId);
      final updatedLikedIds = Set<String>.from(currentState.likedSongIds)..add(event.songId);
      emit(currentState.copyWith(likedSongIds: updatedLikedIds));
    }
  }

  void _onUnlikeSong(UnlikeSong event, Emitter<PlaylistState> emit) async {
    if (state is PlaylistLoaded) {
      final currentState = state as PlaylistLoaded;
      await _playlistRepository.unlikeSong(event.songId);
      final updatedLikedIds = Set<String>.from(currentState.likedSongIds)..remove(event.songId);
      emit(currentState.copyWith(likedSongIds: updatedLikedIds));
    }
  }
}