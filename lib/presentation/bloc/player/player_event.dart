part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();
  @override
  List<Object?> get props => [];
}

class PlaySong extends PlayerEvent {
  final Song song;
  final List<Song> playlist;
  const PlaySong(this.song, this.playlist);
}

class PauseSong extends PlayerEvent {}
class ResumeSong extends PlayerEvent {}
class NextSong extends PlayerEvent {}
class PreviousSong extends PlayerEvent {}
class Seek extends PlayerEvent {
  final Duration position;
  const Seek(this.position);
}

class _PlaybackStateChanged extends PlayerEvent {
  final PlaybackState state;
  const _PlaybackStateChanged(this.state);
}

class _MediaItemChanged extends PlayerEvent {
  final MediaItem mediaItem;
  const _MediaItemChanged(this.mediaItem);
}