import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/song_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final SongRepository _songRepository;

  ProfileBloc({required SongRepository songRepository})
      : _songRepository = songRepository,
        super(ProfileInitial()) {
    on<FetchHistory>(_onFetchHistory);
  }

  void _onFetchHistory(FetchHistory event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final history = await _songRepository.fetchUserHistory();
      emit(ProfileLoaded(history));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}