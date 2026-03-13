import 'package:flutter/material.dart';
import 'package:naijafit/presentation/ai_nutrition_insights_screen/ai_nutrition_insights_screen.dart';
import 'package:naijafit/presentation/food_logging_screen/food_logging_screen.dart';
import 'package:naijafit/presentation/profile_settings_screen/profile_settings_screen.dart';

import '../../widgets/custom_bottom_bar.dart';
import './main_dashboard_screen_initial_page.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() =>
      _MainDashboardScreenState();
}

class _MainDashboardScreenState
    extends State<MainDashboardScreen> {
  int currentIndex = 0;

  // ✅ Correct List Type (Widget)
  final List<Widget> screens = const [
    MainDashboardScreenInitialPage(),
    FoodLoggingScreen(),
    AiNutritionInsightsScreen(),
    ProfileSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex], // ✅ Simple & Correct
      bottomNavigationBar: CustomBottomBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
