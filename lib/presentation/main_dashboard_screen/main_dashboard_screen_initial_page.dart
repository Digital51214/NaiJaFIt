import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';

class MainDashboardScreenInitialPage extends StatefulWidget {
  const MainDashboardScreenInitialPage({super.key});

  @override
  State<MainDashboardScreenInitialPage> createState() =>
      _MainDashboardScreenInitialPageState();
}

class _MainDashboardScreenInitialPageState
    extends State<MainDashboardScreenInitialPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Top (upar se neeche)
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _logoFade;

  late final Animation<Offset> _welcomeSlide;
  late final Animation<double> _welcomeFade;

  // Bottom (neeche se upar) stagger
  late final Animation<Offset> _imageSlide;
  late final Animation<double> _imageFade;

  late final Animation<Offset> _feature1Slide;
  late final Animation<double> _feature1Fade;

  late final Animation<Offset> _feature2Slide;
  late final Animation<double> _feature2Fade;

  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // ✅ Top widgets from TOP
    _logoSlide = Tween<Offset>(
      begin: const Offset(0, -0.45),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.22, curve: Curves.easeOutCubic),
      ),
    );
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.20, curve: Curves.easeOut),
      ),
    );

    _welcomeSlide = Tween<Offset>(
      begin: const Offset(0, -0.30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.10, 0.34, curve: Curves.easeOutCubic),
      ),
    );
    _welcomeFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.10, 0.30, curve: Curves.easeOut),
      ),
    );

    // ✅ Bottom widgets from BOTTOM (one-by-one)
    _imageSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.26, 0.50, curve: Curves.easeOutCubic),
      ),
    );
    _imageFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.26, 0.46, curve: Curves.easeOut),
      ),
    );

    _feature1Slide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.64, curve: Curves.easeOutCubic),
      ),
    );
    _feature1Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.60, curve: Curves.easeOut),
      ),
    );

    _feature2Slide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.52, 0.78, curve: Curves.easeOutCubic),
      ),
    );
    _feature2Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.52, 0.74, curve: Curves.easeOut),
      ),
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 1.00, curve: Curves.easeOutCubic),
      ),
    );
    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 0.96, curve: Curves.easeOut),
      ),
    );

    // ✅ start AFTER first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animatedEntry({
    required Animation<Offset> slide,
    required Animation<double> fade,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ✅ Logo/Header (TOP)
                SizedBox(height: 2.h),
                _animatedEntry(
                  slide: _logoSlide,
                  fade: _logoFade,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/NaijaFit_logo-1770757519026.png',
                        height: 8.h,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            'NaijaFit',
                            style: GoogleFonts.inter(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 1.h),
                      const SizedBox(),
                    ],
                  ),
                ),

                SizedBox(height: 4.h),

                // ✅ Welcome Message Text Box (TOP)
                _animatedEntry(
                  slide: _welcomeSlide,
                  fade: _welcomeFade,
                  child: Container(
                    width: 90.w,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Welcome to NaijaFit!',
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "Finally, a calorie tracking and nutritional support app for our Naija cuisines.\n\nTrack your favorite Nigerian meals with accurate nutrition data. No more guessing, no more generic food databases.\n",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            height: 1.5,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // ✅ Nigerian Meal Image (BOTTOM)
                _animatedEntry(
                  slide: _imageSlide,
                  fade: _imageFade,
                  child: Container(
                    width: 90.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                        'assets/images/Edika_Ikong-1770831928947.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Center(
                              child: Icon(
                                Icons.restaurant,
                                size: 48,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 2.5.h),

                // ✅ Feature 1 (BOTTOM)
                _animatedEntry(
                  slide: _feature1Slide,
                  fade: _feature1Fade,
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.restaurant_menu,
                    title: 'Comprehensive Nigerian Meal Database',
                    description:
                    'Access thousands of authentic Nigerian dishes with accurate nutritional information',
                  ),
                ),

                SizedBox(height: 2.h),

                // ✅ Feature 2 (BOTTOM)
                _animatedEntry(
                  slide: _feature2Slide,
                  fade: _feature2Fade,
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.person_outline,
                    title: 'Personalized Nutrition Guidance for Nigerian Cuisine',
                    description:
                    'Get tailored meal plans and nutrition advice designed specifically for Nigerian food culture',
                  ),
                ),

                SizedBox(height: 5.h),

                // ✅ Button (BOTTOM)
                _animatedEntry(
                  slide: _buttonSlide,
                  fade: _buttonFade,
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed('/food-logging-screen');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 0.h),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Start Your Journey',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String description,
      }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}