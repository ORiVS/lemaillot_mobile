import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../blocs/profile/profile_cubit.dart';
import '../../../blocs/profile/profile_state.dart';
import '../../blocs/orders/order_bloc.dart';
import '../../repositories/order_repository.dart';
import '../home_screen.dart';
import '../orders/order_list_screen.dart';
import '../wishlist_screen.dart';
import 'edit_profil_screen.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3;

  void _onTabTapped(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        break;
      case 1:
      // TODO: Naviguer vers NotificationsScreen quand il sera prêt
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => OrderBloc(OrderRepository()),
              child: OrderListScreen(),
            ),
          ),
        );
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        : const AssetImage('assets/images/avatar_placeholder.png') as ImageProvider,
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
                              context.read<ProfileCubit>().loadProfile();
                            }
                          },
                          child: const Text(
                            "Modifier",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(height: 8),
                  _buildMenuItem("Favoris", LucideIcons.heart, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WishlistScreen()),
                    );
                  }),
                  const SizedBox(height: 8),
                  _buildMenuItem("Paiements", LucideIcons.creditCard),
                  const SizedBox(height: 8),
                  _buildMenuItem("Aide", LucideIcons.helpCircle),
                  const SizedBox(height: 8),
                  _buildMenuItem("Support", LucideIcons.headphones),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Se déconnecter ?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Vous allez être redirigé vers l\'accueil. Êtes-vous sûr de vouloir vous déconnecter ?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                          'Non',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          context.read<AuthBloc>().add(LogoutRequested());
                                          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                                        },
                                        child: const Text(
                                          'Oui',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text(
                      "Se déconnecter",
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _onTabTapped(0),
                child: Icon(LucideIcons.home, color: _selectedIndex == 0 ? Colors.black : Colors.grey),
              ),
              GestureDetector(
                onTap: () => _onTabTapped(1),
                child: Icon(LucideIcons.bell, color: _selectedIndex == 1 ? Colors.black : Colors.grey),
              ),
              GestureDetector(
                onTap: () => _onTabTapped(2),
                child: Icon(LucideIcons.fileText, color: _selectedIndex == 2 ? Colors.black : Colors.grey),
              ),
              GestureDetector(
                onTap: () => _onTabTapped(3),
                child: Icon(LucideIcons.user, color: _selectedIndex == 3 ? Colors.black : Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, [VoidCallback? onTap]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        title: Text(title),
        leading: Icon(icon),
        trailing: const Icon(Icons.chevron_right),
        tileColor: Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        onTap: onTap,
      ),
    );
  }
}
