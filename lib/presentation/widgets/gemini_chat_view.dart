import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme.dart';
import '../bloc/gemini_chat/gemini_chat_bloc.dart';
import '../bloc/player/player_bloc.dart';

class GeminiChatView extends StatefulWidget {
  const GeminiChatView({super.key});

  @override
  State<GeminiChatView> createState() => _GeminiChatViewState();
}

class _GeminiChatViewState extends State<GeminiChatView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    final playerState = context.read<PlayerBloc>().state;
    context.read<GeminiChatBloc>().add(SendMessage(_controller.text, playerState.currentSong));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (_, controller) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: AppTheme.primarySurface.withOpacity(0.8),
              child: Column(
                children: [
                  Expanded(
                    child: BlocConsumer<GeminiChatBloc, GeminiChatState>(
                      listener: (context, state) {
                        if (state is GeminiChatLoaded) {
                          // Scroll to bottom after a new message
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          });
                        }
                      },
                      builder: (context, state) {
                        if (state is GeminiChatInitial) {
                          return const Center(child: Text('Ask me anything about this song...'));
                        }
                        if (state is GeminiChatLoaded) {
                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: state.history.length,
                            itemBuilder: (context, index) {
                              final (text, isUser) = state.history[index];
                              return _buildChatMessage(text, isUser);
                            },
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                  _buildMessageInput(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatMessage(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primaryAccent : AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                filled: true,
                fillColor: AppTheme.backgroundColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppTheme.primaryAccent,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}