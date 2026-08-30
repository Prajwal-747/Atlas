import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_page_scaffold.dart';
import 'package:frontend/features/profile/data/repositories/api_profile_repository.dart';
import 'package:frontend/features/profile/domain/entities/user_profile.dart';
import 'package:frontend/core/network/token_storage.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiProfileRepository profileRepository = ApiProfileRepository();
  late Future<UserProfile> profile;
  final TokenStorage tokenStorage = TokenStorage();
  bool isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    profile = profileRepository.getProfile();
  }

  Future<void> _logout() async {
    setState(() {
      isLoggingOut = true;
    });
    await tokenStorage.clear();
    if (!mounted) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Profile',
      child: FutureBuilder<UserProfile>(
        future: profile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Unable to load profile'));
          }
          final user = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 24),
              Center(
                child: CircleAvatar(
                  radius: 42,
                  child: Text(
                    user.username.isNotEmpty
                        ? user.username[0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  user.username,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 32),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Username'),
                      subtitle: Text(user.username),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: const Text('Email'),
                      subtitle: Text(user.email),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: isLoggingOut ? null : _logout,
                icon: const Icon(Icons.logout),
                label: isLoggingOut
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Logout'),
              ),
            ],
          );
        },
      ),
    );
  }
}
