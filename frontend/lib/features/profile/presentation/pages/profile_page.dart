import 'package:dio/dio.dart';
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

  Future<void> _editProfile(UserProfile user) async {
    final emailController = TextEditingController(text: user.email);
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    bool isSaving = false;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> save() async {
              final email = emailController.text.trim();
              final currentPassword = currentPasswordController.text;
              final newPassword = newPasswordController.text;
              final confirmPassword = confirmPasswordController.text;
              if (email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email cannot be empty.')),
                );
                return;
              }
              if (newPassword.isNotEmpty) {
                if (currentPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Enter your current password to change it.',
                      ),
                    ),
                  );
                  return;
                }
                if (newPassword != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('New passwords do not match.'),
                    ),
                  );
                  return;
                }
              }
              setDialogState(() {
                isSaving = true;
              });
              try {
                final updatedUser = await profileRepository.updateProfile(
                  email: email,
                  currentPassword: currentPassword,
                  newPassword: newPassword,
                );
                if (!mounted || !dialogContext.mounted) return;
                setState(() {
                  profile = Future.value(updatedUser);
                });
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
                );
              } on DioException catch (e) {
                if (!mounted) return;
                final data = e.response?.data;
                String message = 'Unable to update profile.';
                if (data is Map<String, dynamic>) {
                  if (data['current_password'] is List) {
                    message = data['current_password'][0].toString();
                  } else if (data['email'] is List) {
                    message = data['email'][0].toString();
                  } else if (data['new_password'] is List) {
                    message = data['new_password'][0].toString();
                  }
                }
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message)));
              } finally {
                if (dialogContext.mounted) {
                  setDialogState(() {
                    isSaving = false;
                  });
                }
              }
            }

            return AlertDialog(
              title: const Text('Edit Account'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: currentPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Current Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'New Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm New Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: isSaving ? null : save,
                  child: isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Profile',
      child: FutureBuilder<UserProfile>(
        future: profile,
        builder: (context, snapshot) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (snapshot.connectionState == ConnectionState.waiting) ...[
                const SizedBox(height: 80),
                const Center(child: CircularProgressIndicator()),
              ] else if (snapshot.hasError) ...[
                const SizedBox(height: 40),
                const Center(child: Text('Unable to load profile')),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Your session may have expired.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ] else if (!snapshot.hasData) ...[
                const SizedBox(height: 40),
                const Center(child: Text('Unable to load profile')),
              ] else ...[
                const SizedBox(height: 24),
                Center(
                  child: CircleAvatar(
                    radius: 42,
                    child: Text(
                      snapshot.data!.username.isNotEmpty
                          ? snapshot.data!.username[0].toUpperCase()
                          : '?',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    snapshot.data!.username,
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
                        subtitle: Text(snapshot.data!.username),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.email_outlined),
                        title: const Text('Email'),
                        subtitle: Text(snapshot.data!.email),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _editProfile(snapshot.data!),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Account'),
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
