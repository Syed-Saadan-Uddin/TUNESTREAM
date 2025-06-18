import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:audio_service/audio_service.dart';

import 'core/theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/song_repository.dart';
import 'data/repositories/playlist_repository.dart';
import 'data/repositories/gemini_repository.dart';
import 'data/services/audio_handler.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/song/song_bloc.dart';
import 'presentation/bloc/player/player_bloc.dart';
import 'presentation/bloc/playlist/playlist_bloc.dart';
import 'presentation/bloc/gemini_chat/gemini_chat_bloc.dart';
import 'presentation/bloc/theme/theme_bloc.dart';
import 'presentation/bloc/profile/profile_bloc.dart';
import 'presentation/views/login_screen.dart';
import 'presentation/views/main_navigation_screen.dart';


final getIt = GetIt.instance;

Future<void> main() async {
 
  await setupServiceLocator();
  
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(const MyApp());
}


Future<void> setupServiceLocator() async {
  getIt.registerSingleton<AudioHandler>(await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.tunestream.appdev.channel.audio',
      androidNotificationChannelName: 'TuneStream Playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepository()),
        RepositoryProvider<SongRepository>(create: (_) => SongRepository()),
        RepositoryProvider<PlaylistRepository>(create: (_) => PlaylistRepository()),
        RepositoryProvider<GeminiRepository>(create: (_) => GeminiRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
          BlocProvider<AuthBloc>(create: (context) => AuthBloc(authRepository: context.read<AuthRepository>())),
          BlocProvider<PlayerBloc>(
            create: (context) => PlayerBloc(
              audioHandler: getIt<AudioHandler>(), 
              songRepository: context.read<SongRepository>(),
            ),
          ),
          BlocProvider<SongBloc>(create: (context) => SongBloc(songRepository: context.read<SongRepository>())..add(LoadSongs())),
          BlocProvider<PlaylistBloc>(create: (context) => PlaylistBloc(playlistRepository: context.read<PlaylistRepository>())),
          BlocProvider<GeminiChatBloc>(create: (context) => GeminiChatBloc(geminiRepository: context.read<GeminiRepository>())),
          BlocProvider<ProfileBloc>(create: (context) => ProfileBloc(songRepository: context.read<SongRepository>()))
        ],
        child: BlocBuilder<ThemeBloc, ThemeMode>(
          builder: (context, themeMode) {
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                return MaterialApp(
                  title: 'TuneStream',
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeMode,
                  debugShowCheckedModeBanner: false,
                  home: _buildHomeScreen(context, authState),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHomeScreen(BuildContext context, AuthState authState) {
    if (authState.status == AuthStatus.authenticated) {
      context.read<PlaylistBloc>().add(LoadPlaylists());
      return const MainNavigationScreen();
    } else if (authState.status == AuthStatus.guest) {
      return const MainNavigationScreen();
    } else {
      return const LoginScreen();
    }
  }
}