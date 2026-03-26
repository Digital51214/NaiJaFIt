import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color _darkGreen = Color(0xFF1B5E20);
  static const Color _mediumGreen = Color(0xFF2E7D32);
  static const Color _lightGreen = Color(0xFF81C784);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 6, 30, 35),
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                width: 1,
                color: Colors.green.withOpacity(0.5)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6,),
            child: GNav(
              rippleColor: Colors.white24,
              hoverColor: Colors.white10,
              haptic: true,
              curve: Curves.easeOutExpo,
              duration: const Duration(milliseconds: 400),
              activeColor: Colors.white,
              color: Colors.white,
              iconSize: 20,
              gap: 1,
              padding: const EdgeInsets.symmetric(horizontal: 1,),
              tabBorderRadius: 30,
              selectedIndex: currentIndex,
              onTabChange: onTap,
              tabs: [
                _buildTab(0, 'assets/images/home.png', 'Home'),
                _buildTab(1, 'assets/images/food.png', 'Food'),
                _buildTab(2, 'assets/images/AI.png', 'AI Coach'),
                _buildTab(3, 'assets/images/profile.png', 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GButton _buildTab(int index, String imagePath, String text) {
    final bool isSelected = currentIndex == index;

    return GButton(
      icon: Icons.circle,
      text: text,
      backgroundColor: isSelected ? _darkGreen : _lightGreen,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.transparent : Colors.green.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          imagePath,
          width: 22,
          height: 22,
          color: Colors.white,
          fit: BoxFit.contain,
        ),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}