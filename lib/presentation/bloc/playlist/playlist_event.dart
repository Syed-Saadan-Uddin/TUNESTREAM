part of 'playlist_bloc.dart';

abstract class PlaylistEvent extends Equatable {
  const PlaylistEvent();
  @override
  List<Object?> get props => [];
}

class LoadPlaylists extends PlaylistEvent {}

class CreatePlaylistAndAddSong extends PlaylistEvent {
  final String playlistName;
  final Song songToAdd;
  const CreatePlaylistAndAddSong({required this.playlistName, required this.songToAdd});
  @override
  List<Object?> get props => [playlistName, songToAdd];
}

class AddSongToPlaylist extends PlaylistEvent {
  final String playlistId;
  final String songId;
  final String songCoverUrl;
  const AddSongToPlaylist(this.playlistId, this.songId, this.songCoverUrl);
}


class RemoveSongFromPlaylist extends PlaylistEvent {
  final String playlistId;
  final String songId;
  const RemoveSongFromPlaylist({required this.playlistId, required this.songId});
  @override
  List<Object?> get props => [playlistId, songId];
}


class DeletePlaylist extends PlaylistEvent {
  final String playlistId;
  const DeletePlaylist(this.playlistId);
  @override
  List<Object?> get props => [playlistId];
}

class LikeSong extends PlaylistEvent {
  final String songId;
  const LikeSong(this.songId);
}

class UnlikeSong extends PlaylistEvent {
  final String songId;
  const UnlikeSong(this.songId);
}