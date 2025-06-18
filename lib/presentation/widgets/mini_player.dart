import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme.dart';
import '../bloc/player/player_bloc.dart';
import '../views/player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state.status == PlayerStatus.initial || state.currentSong == null) {
          return const SizedBox.shrink();
        }

        final song = state.currentSong!;
        final progress = (state.currentPosition.inMilliseconds / state.totalDuration.inMilliseconds.clamp(1, double.infinity));

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PlayerScreen()),
            );
          },
          child: Container(
            height: 70,
            margin: const EdgeInsets.all(8),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primarySurface.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const Spacer(),
                        LinearProgressIndicator(
                          value: progress.isNaN ? 0 : progress,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryAccent),
                          minHeight: 3,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(song.coverUrl, width: 50, height: 50),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  song.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  song.artists.join(', '),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textColor.withOpacity(0.6)
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (state.status == PlayerStatus.playing) {
                                context.read<PlayerBloc>().add(PauseSong());
                              } else {
                                context.read<PlayerBloc>().add(ResumeSong());
                              }
                            },
                            icon: Icon(
                              state.status == PlayerStatus.playing
                                  ? Icons.pause_circle_filled_rounded
                                  : Icons.play_circle_filled_rounded,
                              color: AppTheme.textColor,
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}