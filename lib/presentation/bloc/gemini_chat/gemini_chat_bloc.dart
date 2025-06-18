import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/song_model.dart';
import '../../../data/repositories/gemini_repository.dart';



part 'gemini_chat_event.dart'; 
part 'gemini_chat_state.dart';

class GeminiChatBloc extends Bloc<GeminiChatEvent, GeminiChatState> {
  final GeminiRepository _geminiRepository;

  GeminiChatBloc({required GeminiRepository geminiRepository})
      : _geminiRepository = geminiRepository,
        super(GeminiChatInitial()) {
    on<SendMessage>(_onSendMessage);
  }

  void _onSendMessage(SendMessage event, Emitter<GeminiChatState> emit) async {
    final currentHistory = state is GeminiChatLoaded ? (state as GeminiChatLoaded).history : <(String, bool)>[];
    
    
    final userMessageEntry = (event.message, true); 
    emit(GeminiChatLoaded(history: [...currentHistory, userMessageEntry], isLoading: true));
    
    final response = await _geminiRepository.getChatResponse(event.message, event.currentSong);

    
    final botMessageEntry = (response, false); 
    emit(GeminiChatLoaded(history: [...currentHistory, userMessageEntry, botMessageEntry], isLoading: false));
  }
}