// home_page_footer.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import 'Tab/home_page_tab.dart'; // Import to use HomePageTab enum

class HomePageFooter extends StatelessWidget {
  final HomePageTab currentTab;
  final Function(HomePageTab) onTabChanged;

  const HomePageFooter({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: 88,
          decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9).withOpacity(0.7),
              border: Border(
                  top: BorderSide(
                      color: Colors.white.withOpacity(0.2), width: 1.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home Icon
              _buildIcon(
                icon: Icons.home_filled,
                isSelected: currentTab == HomePageTab.home,
                onTap: () => onTabChanged(HomePageTab.home),
              ),
              // Favorite Icon
              _buildIcon(
                icon: Icons.favorite,
                isSelected: currentTab == HomePageTab.favorite,
                onTap: () => onTabChanged(HomePageTab.favorite),
              ),
              // Cart Icon
              _buildIcon(
                icon: Icons.shopping_bag,
                isSelected: currentTab == HomePageTab.cart,
                onTap: () => onTabChanged(HomePageTab.cart),
              ),
              // Notifications Icon
              _buildIcon(
                icon: Icons.notifications,
                isSelected: currentTab == HomePageTab.notifications,
                onTap: () => onTabChanged(HomePageTab.notifications),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon({
    required IconData icon,
    required bool isSelected,
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Icon(
        icon,
        color: isSelected ? const Color(0xFFC67C4E) : const Color(0xFF8D8D8D),
        size: 28,
      ),
    );
  }
}
