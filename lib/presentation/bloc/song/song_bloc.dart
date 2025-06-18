import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/song_model.dart';
import '../../../data/repositories/song_repository.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final SongRepository _songRepository;

  SongBloc({required SongRepository songRepository})
      : _songRepository = songRepository,
        super(SongInitial()) {
    on<LoadSongs>(_onLoadSongs);
  }

  void _onLoadSongs(LoadSongs event, Emitter<SongState> emit) async {
    emit(SongLoading());
    try {
      final songs = await _songRepository.fetchAllSongs();
      
      emit(SongLoaded(songs));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }
}