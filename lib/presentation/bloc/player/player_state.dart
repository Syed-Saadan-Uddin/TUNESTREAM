part of 'player_bloc.dart';

enum PlayerStatus { initial, playing, paused, stopped, completed, error }

class PlayerState extends Equatable {
  final PlayerStatus status;
  final Song? currentSong;
  final Duration currentPosition;
  final Duration totalDuration;
  final List<Song> playlist;
  final int currentIndex;

  const PlayerState({
    this.status = PlayerStatus.initial,
    this.currentSong,
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.playlist = const [],
    this.currentIndex = 0,
  });

  PlayerState copyWith({
    PlayerStatus? status,
    Song? currentSong,
    Duration? currentPosition,
    Duration? totalDuration,
    List<Song>? playlist,
    int? currentIndex,
  }) {
    return PlayerState(
      status: status ?? this.status,
      currentSong: currentSong ?? this.currentSong,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      playlist: playlist ?? this.playlist,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [status, currentSong, currentPosition, totalDuration, playlist, currentIndex];
}