import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/song_model.dart';
import '../../../data/repositories/song_repository.dart';
import '../../../data/services/audio_handler.dart';
part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final AudioHandler _audioHandler;
  final SongRepository _songRepository;
  
  StreamSubscription? _playbackSubscription;
  StreamSubscription? _mediaItemSubscription;

  PlayerBloc({required AudioHandler audioHandler, required SongRepository songRepository})
      : _audioHandler = audioHandler,
        _songRepository = songRepository,
        super(const PlayerState()) {
    
    _playbackSubscription = _audioHandler.playbackState.listen((playbackState) {
      add(_PlaybackStateChanged(playbackState));
    });
    
    _mediaItemSubscription = _audioHandler.mediaItem.listen((mediaItem) {
      if (mediaItem != null) {
        add(_MediaItemChanged(mediaItem));
      }
    });

    on<PlaySong>(_onPlaySong);
    on<PauseSong>((event, emit) => _audioHandler.pause());
    on<ResumeSong>((event, emit) => _audioHandler.play());
    on<Seek>((event, emit) => _audioHandler.seek(event.position));
    on<NextSong>((event, emit) => _audioHandler.skipToNext());
    on<PreviousSong>((event, emit) => _audioHandler.skipToPrevious());

    on<_PlaybackStateChanged>(_onPlaybackStateChanged);
    on<_MediaItemChanged>(_onMediaItemChanged);
  }

  void _onPlaySong(PlaySong event, Emitter<PlayerState> emit) async {
    // This is a bit of a hack to ensure the UI gets the full playlist info
    // before the audio handler starts playing.
    emit(state.copyWith(playlist: event.playlist));

    // Cast to our custom handler to access the updatePlaylist method
    await (_audioHandler as MyAudioHandler).updatePlaylist(event.playlist);
    
    final index = event.playlist.indexOf(event.song);
    if (index != -1) {
      await _audioHandler.skipToQueueItem(index);
    }
    
    _songRepository.logSongPlay(event.song);
    await _audioHandler.play();
  }
  
  void _onPlaybackStateChanged(_PlaybackStateChanged event, Emitter<PlayerState> emit) {
    final playbackState = event.state;
    emit(state.copyWith(
      status: playbackState.playing ? PlayerStatus.playing : PlayerStatus.paused,
      currentPosition: playbackState.updatePosition,
    ));
  }
  
  void _onMediaItemChanged(_MediaItemChanged event, Emitter<PlayerState> emit) {
    // Find the corresponding Song object from our full list
    final song = state.playlist.firstWhere(
      (s) => s.id == event.mediaItem.id, 
      orElse: () => state.currentSong! // Fallback
    );

    emit(state.copyWith(
      currentSong: song,
      totalDuration: event.mediaItem.duration ?? Duration.zero,
      currentIndex: _audioHandler.queue.value.indexOf(event.mediaItem),
    ));
  }

  @override
  Future<void> close() {
    _playbackSubscription?.cancel();
    _mediaItemSubscription?.cancel();
    return super.close();
  }
}