import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/profile/profile_cubit.dart';
import '../../../blocs/profile/profile_state.dart';
import 'edit_profil_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final user = state.user;
              final profile = state.profile;

              return Column(
                children: [
                  const SizedBox(height: 24),
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: profile.profilePicture != null
                        ? NetworkImage(profile.profilePicture!)
                        : const AssetImage('assets/images/avatar_placeholder.png')
                    as ImageProvider,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${user.firstName} ${user.lastName}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                              Text(user.email, style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 2),
                              Text(user.phoneNumber, style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProfileScreen(
                                  user: user,
                                  profile: profile,
                                ),
                              ),
                            );
                            if (result == true) {
                              context.read<ProfileCubit>().loadProfile(); // recharge après modification
                            }
                          },
                          child: const Text("Modifier"),
                        )

                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...[
                    "Address",
                    "Wishlist",
                    "Payment",
                    "Help",
                    "Support"
                  ].map(
                        (title) => ListTile(
                      title: Text(title),
                      trailing: const Icon(Icons.chevron_right),
                      tileColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      onTap: () {
                        // TODO: action pour chaque section
                      },
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // Déconnexion : appeler cubit.logout() + navigation
                    },
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined), label: ''),
        ],
      ),
    );
  }
}
