import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme.dart';
import '../bloc/player/player_bloc.dart';
import '../bloc/playlist/playlist_bloc.dart';
import '../widgets/gemini_chat_view.dart';
import '../widgets/neumorphic_button.dart';
import '../widgets/add_to_playlist_dialog.dart'; 
import '../widgets/marquee_text.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final brightness = Theme.of(context).brightness;

    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state.currentSong == null) {
          return const SizedBox.shrink();
        }

        final song = state.currentSong!;
        
        String formatDuration(Duration d) {
          final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
          final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
          return "$minutes:$seconds";
        }

        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  song.coverUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(color: Colors.black.withOpacity(0.5)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.1),
                    Container(
                      decoration: AppTheme.neumorphicDecoration(
                        borderRadius: 20,
                        brightness: Brightness.dark,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          song.coverUrl,
                          height: screenHeight * 0.35,
                          width: screenHeight * 0.35,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MarqueeWidget(
                                 duration: const Duration(seconds: 14),
                                child: Text(
                                  song.name,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.visible, 
                                  softWrap: false, 
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                song.artists.join(', '),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        NeumorphicButton(
                          size: 50,
                          onTap: () {
                            
                            showDialog(
                              context: context,
                              
                              builder: (_) => AddToPlaylistDialog(song: song),
                            );
                          },
                          child: const Icon(
                            Icons.playlist_add,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12), 
                        BlocBuilder<PlaylistBloc, PlaylistState>(
                          builder: (context, playlistState) {
                             bool isLiked = false;
                            if (playlistState is PlaylistLoaded) {
                              isLiked = playlistState.likedSongIds.contains(song.id);
                            }
                            return NeumorphicButton(
                              size: 50,
                              onTap: () {
                                if (isLiked) {
                                  context.read<PlaylistBloc>().add(UnlikeSong(song.id));
                                } else {
                                  context.read<PlaylistBloc>().add(LikeSong(song.id));
                                }
                              },
                              child: Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border,
                                color: isLiked ? AppTheme.primaryAccent : Colors.white,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    const Spacer(),
                    Slider(
                      value: state.currentPosition.inMilliseconds.toDouble().clamp(0.0, state.totalDuration.inMilliseconds.toDouble()),
                      max: state.totalDuration.inMilliseconds.toDouble(),
                      onChanged: (value) {
                         context.read<PlayerBloc>().add(Seek(Duration(milliseconds: value.toInt())));
                      },
                      activeColor: AppTheme.primaryAccent,
                      inactiveColor: Colors.white.withOpacity(0.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatDuration(state.currentPosition), style: const TextStyle(color: Colors.white)),
                          Text(formatDuration(state.totalDuration), style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NeumorphicButton(
                          onTap: () => context.read<PlayerBloc>().add(PreviousSong()),
                          child: const Icon(Icons.skip_previous_rounded, size: 35, color: AppTheme.primaryAccent),
                        ),
                        NeumorphicButton(
                          size: 70,
                          onTap: () {
                            if (state.status == PlayerStatus.playing) {
                              context.read<PlayerBloc>().add(PauseSong());
                            } else {
                              context.read<PlayerBloc>().add(ResumeSong());
                            }
                          },
                          child: Icon(
                            state.status == PlayerStatus.playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 50,
                            color: AppTheme.primaryAccent,
                          ),
                        ),
                        NeumorphicButton(
                          onTap: () => context.read<PlayerBloc>().add(NextSong()),
                          child: const Icon(Icons.skip_next_rounded, size: 35, color: AppTheme.primaryAccent),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Positioned(
                top: 50,
                left: 10,
                child: NeumorphicButton(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.keyboard_arrow_down_rounded, size: 30, color: AppTheme.primaryAccent),
                )
              ),
              Positioned(
                top: 50,
                right: 10,
                child: NeumorphicButton(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const GeminiChatView(),
                    );
                  },
                  child: const Icon(Icons.chat_bubble_outline_rounded, size: 24, color: AppTheme.primaryAccent),
                )
              ),
            ],
          ),
        );
      },
    );
  }
}