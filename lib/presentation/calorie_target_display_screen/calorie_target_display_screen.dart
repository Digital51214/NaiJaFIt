import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../routes/app_routes.dart';
import './widgets/macro_progress_bar_widget.dart';
import './widgets/personalization_summary_widget.dart';

class CalorieTargetDisplayScreen extends StatefulWidget {
  const CalorieTargetDisplayScreen({super.key});

  @override
  State<CalorieTargetDisplayScreen> createState() =>
      _CalorieTargetDisplayScreenState();
}

class _CalorieTargetDisplayScreenState extends State<CalorieTargetDisplayScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late Animation<int> _calorieAnimation;

  // ✅ Animations (same pattern as PersonalStatsScreen)

  // Top (upar se neeche)
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;

  late final Animation<Offset> _progressSlide;
  late final Animation<double> _progressFade;

  // Content (neeche se upar) - stagger
  late final Animation<Offset> _heroSlide;
  late final Animation<double> _heroFade;

  late final Animation<Offset> _macroSlide;
  late final Animation<double> _macroFade;

  late final Animation<Offset> _summarySlide;
  late final Animation<double> _summaryFade;

  late final Animation<Offset> _messageSlide;
  late final Animation<double> _messageFade;

  int _targetCalories = 0;
  Map<String, dynamic> _macros = {};
  String _selectedGoal = '';
  int _targetWeight = 0;
  int _timelineWeeks = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    // ✅ TOP: Header
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.00, 0.18, curve: Curves.easeOutCubic),
      ),
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.00, 0.18, curve: Curves.easeOut),
      ),
    );

    // ✅ TOP: Progress
    _progressSlide = Tween<Offset>(
      begin: const Offset(0, -0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.10, 0.28, curve: Curves.easeOutCubic),
      ),
    );

    _progressFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.10, 0.28, curve: Curves.easeOut),
      ),
    );

    // ✅ CONTENT: Hero
    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.22, 0.40, curve: Curves.easeOutCubic),
      ),
    );

    _heroFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.22, 0.40, curve: Curves.easeOut),
      ),
    );

    // ✅ CONTENT: Macro
    _macroSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.32, 0.52, curve: Curves.easeOutCubic),
      ),
    );

    _macroFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.32, 0.52, curve: Curves.easeOut),
      ),
    );

    // ✅ CONTENT: Summary
    _summarySlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.42, 0.64, curve: Curves.easeOutCubic),
      ),
    );

    _summaryFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.42, 0.64, curve: Curves.easeOut),
      ),
    );

    // ✅ CONTENT: Message
    _messageSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.54, 0.78, curve: Curves.easeOutCubic),
      ),
    );

    _messageFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.54, 0.78, curve: Curves.easeOut),
      ),
    );

    // ✅ Start after first frame (same as PersonalStatsScreen)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _animationController.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};

    _targetCalories = args['dailyCalories'] as int? ?? 1800;
    _selectedGoal = args['goal'] as String? ?? 'lose_weight';
    _targetWeight = args['targetWeight'] as int? ?? 70;
    _timelineWeeks = args['timelineWeeks'] as int? ?? 8;

    _macros = _calculateMacros(_targetCalories, _selectedGoal);

    // ✅ Same controller used for calorie animation too (like before)
    _calorieAnimation = IntTween(begin: 0, end: _targetCalories).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _calculateMacros(int calories, String goal) {
    Map<String, Map<String, double>> ratios = {
      'lose_weight': {'protein': 0.30, 'carbs': 0.40, 'fats': 0.30},
      'gain_muscle': {'protein': 0.35, 'carbs': 0.45, 'fats': 0.20},
      'maintain_weight': {'protein': 0.25, 'carbs': 0.50, 'fats': 0.25},
    };

    final ratio = ratios[goal] ?? ratios['lose_weight']!;

    final proteinGrams = ((calories * ratio['protein']!) / 4).round();
    final carbsGrams = ((calories * ratio['carbs']!) / 4).round();
    final fatsGrams = ((calories * ratio['fats']!) / 9).round();

    return {
      'protein': {
        'grams': 0,
        'target': proteinGrams,
        'percentage': ratio['protein']!,
      },
      'carbs': {
        'grams': 0,
        'target': carbsGrams,
        'percentage': ratio['carbs']!,
      },
      'fats': {'grams': 0, 'target': fatsGrams, 'percentage': ratio['fats']!},
    };
  }

  void _onGetStarted() {
    Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.signIn);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Header animated (top -> down)
                    SlideTransition(
                      position: _headerSlide,
                      child: FadeTransition(
                        opacity: _headerFade,
                        child: _buildHeader(theme),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // ✅ Progress animated (top -> down)
                    SlideTransition(
                      position: _progressSlide,
                      child: FadeTransition(
                        opacity: _progressFade,
                        child: _buildProgressIndicator(theme),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // ✅ Bottom widgets animated (bottom -> up) stagger
                    SlideTransition(
                      position: _heroSlide,
                      child: FadeTransition(
                        opacity: _heroFade,
                        child: _buildHeroSection(theme),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    SlideTransition(
                      position: _macroSlide,
                      child: FadeTransition(
                        opacity: _macroFade,
                        child: _buildMacroBreakdown(theme),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    SlideTransition(
                      position: _summarySlide,
                      child: FadeTransition(
                        opacity: _summaryFade,
                        child: _buildPersonalizationSummary(theme),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    SlideTransition(
                      position: _messageSlide,
                      child: FadeTransition(
                        opacity: _messageFade,
                        child: _buildMotivationalMessage(theme),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/NaijaFit_logo.png',
            height: 32,
            width: 32,
            fit: BoxFit.contain,
            semanticLabel: 'NaijaFit logo',
          ),
          SizedBox(width: 2.w),
          Text(
            'Your Personalized Plan',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step 7 of 7',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '100%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: LinearProgressIndicator(
            value: 1.0,
            minHeight: 8,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.secondary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Your Daily Calorie Target',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          AnimatedBuilder(
            animation: _calorieAnimation,
            builder: (context, child) {
              return Text(
                _calorieAnimation.value.toStringAsFixed(0),
                style: GoogleFonts.inter(
                  fontSize: 48.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  height: 1.0,
                ),
              );
            },
          ),
          Text(
            'calories',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Personalized for your goal',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBreakdown(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.pie_chart,
                color: theme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Macro Breakdown',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          MacroProgressBarWidget(
            name: 'Protein',
            target:
            (_macros['protein'] as Map<String, dynamic>)['target'] as int,
            percentage:
            (_macros['protein'] as Map<String, dynamic>)['percentage']
            as double,
            color: theme.colorScheme.secondary,
          ),
          SizedBox(height: 2.h),
          MacroProgressBarWidget(
            name: 'Carbs',
            target: (_macros['carbs'] as Map<String, dynamic>)['target'] as int,
            percentage:
            (_macros['carbs'] as Map<String, dynamic>)['percentage']
            as double,
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          MacroProgressBarWidget(
            name: 'Fats',
            target: (_macros['fats'] as Map<String, dynamic>)['target'] as int,
            percentage:
            (_macros['fats'] as Map<String, dynamic>)['percentage']
            as double,
            color: theme.colorScheme.tertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalizationSummary(ThemeData theme) {
    return PersonalizationSummaryWidget(
      selectedGoal: _selectedGoal,
      targetWeight: _targetWeight,
      timelineWeeks: _timelineWeeks,
    );
  }

  Widget _buildMotivationalMessage(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFF97316), width: 1.5),
      ),
      child: Row(
        children: [
          Text('🍛', style: TextStyle(fontSize: 24.sp)),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Your Jollof Rice portions are calculated!',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFEA580C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 12.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: (){
                Navigator.of(context, rootNavigator: true).pushNamed(
                  AppRoutes.premiumSubscription,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 0.h),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Get Started',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 1.5.h),
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pushNamed(
                AppRoutes.premiumSubscription,
              );
            },
            child: Text(
              'Save & Continue Later',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}