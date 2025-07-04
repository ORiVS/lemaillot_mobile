import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_icons.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool hasUnreadNotifications;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.hasUnreadNotifications = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            _buildNavItem(icon: AppIcons.home, index: 0),
            _buildNavItem(icon: AppIcons.notifications, index: 1),
            _buildNavItem(icon: LucideIcons.fileText, index: 2),
            _buildNavItem(icon: AppIcons.profile, index: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    bool showBadge = (index == 1 && hasUnreadNotifications);

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            icon,
            color: selectedIndex == index ? Colors.black : Colors.grey,
          ),
          if (showBadge)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

}
