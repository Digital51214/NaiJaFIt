import 'package:flutter/material.dart';
import '../presentation/splash_screen.dart';
import '../presentation/food_logging_screen/food_logging_screen.dart';
import '../presentation/challenge_identification_screen/challenge_identification_screen.dart';
import '../presentation/main_dashboard_screen/main_dashboard_screen.dart';
import '../presentation/personal_stats_screen/personal_stats_screen.dart';
import '../presentation/premium_subscription_screen/premium_subscription_screen.dart';
import '../presentation/goal_selection_screen/goal_selection_screen.dart';
import '../presentation/sign_in_screen/sign_in_screen.dart';
import '../presentation/sign_up_screen/sign_up_screen.dart';
import '../presentation/forgot_password_screen/forgot_password_screen.dart';
import '../presentation/subscription_checkout_screen/subscription_checkout_screen.dart';
import '../presentation/goal_setting_details_screen/goal_setting_details_screen.dart';
import '../presentation/weight_loss_expectations_screen/weight_loss_expectations_screen.dart';
import '../presentation/calorie_target_display_screen/calorie_target_display_screen.dart';
import '../presentation/profile_settings_screen/profile_settings_screen.dart';
import '../presentation/ai_nutrition_insights_screen/ai_nutrition_insights_screen.dart';
import '../presentation/professional_support_screen/professional_support_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String signIn = '/sign-in-screen';
  static const String signUp = '/sign-up-screen';
  static const String forgotPassword = '/forgot-password-screen';
  static const String foodLogging = '/food-logging-screen';
  static const String challengeIdentification =
      '/challenge-identification-screen';
  static const String mainDashboard = '/main-dashboard-screen';
  static const String splash = '/splash-screen';
  static const String personalStats = '/personal-stats-screen';
  static const String premiumSubscription = '/premium-subscription-screen';
  static const String goalSelection = '/goal-selection-screen';
  static const String subscriptionCheckout = '/subscription-checkout-screen';
  static const String goalSettingDetails = '/goal-setting-details-screen';
  static const String weightLossExpectations =
      '/weight-loss-expectations-screen';
  static const String professionalSupport = '/professional-support-screen';
  static const String calorieTargetDisplay = '/calorie-target-display-screen';
  static const String profileSettings = '/profile-settings-screen';
  static const String aiNutritionInsights = '/ai-nutrition-insights-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SignInScreen(),
    signIn: (context) => const SignInScreen(),
    signUp: (context) => const SignUpScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    foodLogging: (context) => const FoodLoggingScreen(),
    challengeIdentification: (context) => const ChallengeIdentificationScreen(),
    mainDashboard: (context) => const MainDashboardScreen(),
    personalStats: (context) => const PersonalStatsScreen(),
    premiumSubscription: (context) => const PremiumSubscriptionScreen(),
    goalSelection: (context) => const OnboardingScreen(),
    subscriptionCheckout: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      return SubscriptionCheckoutScreen(
        planType: args?['planType'] as String? ?? 'monthly',
        planTitle: args?['planTitle'] as String? ?? 'Monthly Plan',
        price: args?['price'] as String? ?? '\$2.29',
        period: args?['period'] as String? ?? '/month',
      );
    },
    goalSettingDetails: (context) => const GoalSettingDetailsScreen(),
    weightLossExpectations: (context) => const WeightLossExpectationsScreen(),
    professionalSupport: (context) => const ProfessionalSupportScreen(),
    calorieTargetDisplay: (context) => const CalorieTargetDisplayScreen(),
    profileSettings: (context) => const ProfileSettingsScreen(),
    aiNutritionInsights: (context) => const AiNutritionInsightsScreen(),
    splash: (context) => const SplashScreen(),
    // TODO: Add your other routes here
  };
}
