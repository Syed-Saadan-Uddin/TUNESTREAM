part of 'song_bloc.dart';

abstract class SongEvent extends Equatable {
  const SongEvent();

  @override
  List<Object> get props => [];
}

class LoadSongs extends SongEvent {}