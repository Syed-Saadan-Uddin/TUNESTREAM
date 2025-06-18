import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/profile/profile_bloc.dart';


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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        songRepository: context.read(),
      )..add(FetchHistory()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile & History')),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState.status != AuthStatus.authenticated) {
              return _buildGuestPrompt(context);
            }
            final user = authState.user!;
            final name = user.displayName ?? user.email ?? 'Aura User';
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          _getInitials(name),
                          style: const TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          name,
                          style: Theme.of(context).textTheme.headlineSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                       IconButton(
                        tooltip: "Sign Out",
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthSignOutRequested());
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Listening History', style: Theme.of(context).textTheme.titleLarge),
                ),
                Expanded(
                  child: BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, profileState) {
                      if (profileState is ProfileLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (profileState is ProfileLoaded) {
                        if (profileState.history.isEmpty) {
                           return const Center(child: Text('No listening history yet.'));
                        }
                        return ListView.builder(
                          itemCount: profileState.history.length,
                          itemBuilder: (context, index) {
                            final item = profileState.history[index];
                            return ListTile(
                              leading: item['coverUrl'] != null 
                                ? Image.network(item['coverUrl'], width: 50, height: 50, fit: BoxFit.cover)
                                : const SizedBox(width: 50, height: 50, child: Icon(Icons.music_note)),
                              title: Text(item['name'] ?? 'Unknown Song'),
                              subtitle: Text((item['artists'] as List<dynamic>).join(', ')),
                            );
                          },
                        );
                      }
                      return const Center(child: Text('Could not load history.'));
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  
  Widget _buildGuestPrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/login_prompt.json',
              width: 200,
            ),
            const SizedBox(height: 24),
            Text(
              'Create an Account to See Your Profile',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            Text(
              'Sign up to track your listening history and get a personalized experience.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              onPressed: () {
                context.read<AuthBloc>().add(AuthSignOutRequested());
                if (Navigator.of(context).canPop()) {
                   Navigator.of(context).pop();
                }
              },
              child: const Text('Sign Up or Sign In'),
            )
          ],
        ),
      ),
    );
  }
}