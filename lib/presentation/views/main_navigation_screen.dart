import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/theme/theme_bloc.dart';
import '../widgets/mini_player.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'library_screen.dart';
import 'profile_screen.dart';


String _getInitials(String name) {
  List<String> names = name.split(" ");
  String initials = "";
  if (names.isNotEmpty && names[0].isNotEmpty) {
    initials += names[0][0];
    if (names.length > 1 && names.last.isNotEmpty) {
      initials += names[names.length - 1][0];
    }
  } else if (name.isNotEmpty) {
    initials = name[0];
  }
  return initials.toUpperCase();
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  
  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    
    final status = await Permission.notification.status;
    
    
    if (status.isDenied) {
      
      await Permission.notification.request();
    } 
    
    
    else if (status.isPermanentlyDenied) {
      
      print("Notification permission permanently denied. Guide user to settings.");
      
    }
  }

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenTitles = ['Discover', 'Search', 'Your Library'];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Lottie.asset(
              'assets/animations/music_waves.json',
              height: 30,
              width: 30,
            ),
            const SizedBox(width: 8),
            Text(screenTitles[_selectedIndex]),
          ],
        ),
        elevation: 0,
        actions: [
          BlocBuilder<ThemeBloc, ThemeMode>(
            builder: (context, themeMode) {
              return IconButton(
                icon: Icon(
                  themeMode == ThemeMode.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined
                ),
                onPressed: () {
                  context.read<ThemeBloc>().add(ThemeToggled());
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state.status == AuthStatus.authenticated) {
                  final user = state.user!;
                  final name = user.displayName ?? user.email ?? 'A';
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(_getInitials(name)),
                    ),
                  );
                } else {
                  
                  return TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthSignOutRequested());
                    },
                    child: Text(
                      'Sign In', 
                      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _widgetOptions.elementAt(_selectedIndex),
          const Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: MiniPlayer(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music_rounded), label: 'Library'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: false,
      ),
    );
  }
}