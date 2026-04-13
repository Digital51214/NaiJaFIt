import 'package:flutter/material.dart';
import 'package:naijafit/core/app_state.dart';
import 'package:naijafit/presentation/HomeScreen2.dart';
import 'package:naijafit/presentation/WeightProgressScreen.dart';
import 'package:naijafit/presentation/ai_coach_entro_screen.dart';
import 'package:naijafit/presentation/main_dashboard_screen/HomeScreen.dart';
import 'package:naijafit/presentation/profile_settings_screen/profile_settings_screen.dart';
import '../../widgets/custom_bottom_bar.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Read global state — rebuilds automatically when setMealLogged() is called
    final appState = AppStateProvider.of(context);
    final bool mealLogged = appState.hasMealBeenLogged;

    // Home tab shows HomeScreen (new user, all zeros) OR HomeScreen2 (returning user)
    final List<Widget> screens = [
      mealLogged ? const Homescreen2() : const Homescreen(),
      const WeightProgressScreen(),
      const AiCoachIntroScreen(),
      const ProfileSettingsScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: CustomBottomBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}
