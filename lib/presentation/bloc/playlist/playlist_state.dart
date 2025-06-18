part of 'playlist_bloc.dart';

abstract class PlaylistState extends Equatable {
  const PlaylistState();

  @override
  List<Object> get props => [];
}

class PlaylistInitial extends PlaylistState {}

class PlaylistLoading extends PlaylistState {}

class PlaylistLoaded extends PlaylistState {
  final List<Playlist> playlists;
  final Set<String> likedSongIds;

  const PlaylistLoaded({
    this.playlists = const [],
    this.likedSongIds = const {},
  });

  PlaylistLoaded copyWith({
    List<Playlist>? playlists,
    Set<String>? likedSongIds,
  }) {
    return PlaylistLoaded(
      playlists: playlists ?? this.playlists,
      likedSongIds: likedSongIds ?? this.likedSongIds,
    );
  }

  @override
  List<Object> get props => [playlists, likedSongIds];
}

class PlaylistError extends PlaylistState {}