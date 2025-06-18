part of 'gemini_chat_bloc.dart';

abstract class GeminiChatState extends Equatable {
  const GeminiChatState();

  @override
  List<Object> get props => [];
}

class GeminiChatInitial extends GeminiChatState {}

class GeminiChatLoaded extends GeminiChatState {

  final List<(String, bool)> history;
  final bool isLoading;

  const GeminiChatLoaded({
    required this.history,
    this.isLoading = false,
  });

  @override
  List<Object> get props => [history, isLoading];
}