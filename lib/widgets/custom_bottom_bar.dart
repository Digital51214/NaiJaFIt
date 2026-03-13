import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor:
          Colors.white,
          unselectedItemColor:
          Colors.white60,
          selectedLabelStyle:
          theme.bottomNavigationBarTheme.selectedLabelStyle,
          unselectedLabelStyle:
          theme.bottomNavigationBarTheme.unselectedLabelStyle,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.dashboard_outlined, false),
              activeIcon: _buildIcon(Icons.dashboard, true),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.restaurant_menu_outlined, false),
              activeIcon: _buildIcon(Icons.restaurant_menu, true),
              label: 'Food Log',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.psychology_outlined, false),
              activeIcon: _buildIcon(Icons.psychology, true),
              label: 'AI Insights',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.person_outline, false),
              activeIcon: _buildIcon(Icons.person, true),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, bool isActive) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Icon(icon, size: 24),
    );
  }
}
