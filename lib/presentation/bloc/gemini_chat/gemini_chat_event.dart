part of 'gemini_chat_bloc.dart';

abstract class GeminiChatEvent extends Equatable {
  const GeminiChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessage extends GeminiChatEvent {
  final String message;
  final Song? currentSong;

  const SendMessage(this.message, this.currentSong);

  @override
  List<Object?> get props => [message, currentSong];
}