import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/accountability_card_widget.dart';
import './widgets/testimonial_carousel_widget.dart';
import './widgets/weight_loss_chart_widget.dart';

class WeightLossExpectationsScreen extends StatefulWidget {
  const WeightLossExpectationsScreen({super.key});

  @override
  State<WeightLossExpectationsScreen> createState() =>
      _WeightLossExpectationsScreenState();
}

class _WeightLossExpectationsScreenState extends State<WeightLossExpectationsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Top (upar se neeche)
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;

  late final Animation<Offset> _progressSlide;
  late final Animation<double> _progressFade;

  // Content (neeche se upar) - stagger
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;

  late final Animation<Offset> _chartSlide;
  late final Animation<double> _chartFade;

  late final Animation<Offset> _accountabilitySlide;
  late final Animation<double> _accountabilityFade;

  late final Animation<Offset> _averageSlide;
  late final Animation<double> _averageFade;

  late final Animation<Offset> _testimonialSlide;
  late final Animation<double> _testimonialFade;

  late final Animation<Offset> _citationSlide;
  late final Animation<double> _citationFade;

  // Bottom button
  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    // ✅ TOP: Header
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.18, curve: Curves.easeOutCubic),
      ),
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.18, curve: Curves.easeOut),
      ),
    );

    // ✅ TOP: Progress
    _progressSlide = Tween<Offset>(
      begin: const Offset(0, -0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.08, 0.26, curve: Curves.easeOutCubic),
      ),
    );

    _progressFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.08, 0.26, curve: Curves.easeOut),
      ),
    );

    // ✅ CONTENT: Title
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.38, curve: Curves.easeOutCubic),
      ),
    );

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.38, curve: Curves.easeOut),
      ),
    );

    // ✅ CONTENT: Chart
    _chartSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.30, 0.52, curve: Curves.easeOutCubic),
      ),
    );

    _chartFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.30, 0.52, curve: Curves.easeOut),
      ),
    );

    // ✅ CONTENT: Accountability
    _accountabilitySlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.64, curve: Curves.easeOutCubic),
      ),
    );

    _accountabilityFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.64, curve: Curves.easeOut),
      ),
    );

    // ✅ CONTENT: Average results
    _averageSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.52, 0.74, curve: Curves.easeOutCubic),
      ),
    );

    _averageFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.52, 0.74, curve: Curves.easeOut),
      ),
    );

    // ✅ CONTENT: Testimonials
    _testimonialSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.62, 0.86, curve: Curves.easeOutCubic),
      ),
    );

    _testimonialFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.62, 0.86, curve: Curves.easeOut),
      ),
    );

    // ✅ CONTENT: Citation
    _citationSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.72, 0.94, curve: Curves.easeOutCubic),
      ),
    );

    _citationFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.72, 0.94, curve: Curves.easeOut),
      ),
    );

    // ✅ BOTTOM: Button
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.80, 1.00, curve: Curves.easeOutCubic),
      ),
    );

    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.80, 1.00, curve: Curves.easeOut),
      ),
    );

    // ✅ IMPORTANT: start AFTER first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            /// ✅ NEW HEADER (Same as ProfessionalSupportScreen)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
              child: Column(
                children: [
                  // ✅ Header animate top->down
                  SlideTransition(
                    position: _headerSlide,
                    child: FadeTransition(
                      opacity: _headerFade,
                      child: _buildHeader(context, theme),
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // ✅ Progress animate top->down
                  SlideTransition(
                    position: _progressSlide,
                    child: FadeTransition(
                      opacity: _progressFade,
                      child: _buildProgressIndicator(theme),
                    ),
                  ),
                ],
              ),
            ),

            /// Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 3.h),

                    // ✅ Title section animate bottom->up
                    SlideTransition(
                      position: _titleSlide,
                      child: FadeTransition(
                        opacity: _titleFade,
                        child: _buildTitleSection(),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // ✅ Chart animate bottom->up
                    SlideTransition(
                      position: _chartSlide,
                      child: FadeTransition(
                        opacity: _chartFade,
                        child: const WeightLossChartWidget(),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // ✅ Accountability animate bottom->up
                    SlideTransition(
                      position: _accountabilitySlide,
                      child: FadeTransition(
                        opacity: _accountabilityFade,
                        child: _buildAccountabilitySection(),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // ✅ Average results animate bottom->up
                    SlideTransition(
                      position: _averageSlide,
                      child: FadeTransition(
                        opacity: _averageFade,
                        child: _buildAverageResultsSection(),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // ✅ Testimonials animate bottom->up
                    SlideTransition(
                      position: _testimonialSlide,
                      child: FadeTransition(
                        opacity: _testimonialFade,
                        child: const TestimonialCarouselWidget(),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // ✅ Citation animate bottom->up
                    SlideTransition(
                      position: _citationSlide,
                      child: FadeTransition(
                        opacity: _citationFade,
                        child: _buildDataSourceCitation(),
                      ),
                    ),

                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ),

            // ✅ Bottom button animate bottom->up
            SlideTransition(
              position: _buttonSlide,
              child: FadeTransition(
                opacity: _buttonFade,
                child: _buildBottomButton(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Same Header as Professional Screen
  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.outline, width: 1),
            ),
            child: Center(
              child: Icon(Icons.arrow_back_ios_new),
            ),
          ),
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/NaijaFit_logo-1770757519026.png',
              height: 28,
              width: 28,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 2.w),
            Text(
              'NaijaFit',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(width: 10.w),
      ],
    );
  }

  /// ✅ Progress Indicator (4/7)
  Widget _buildProgressIndicator(ThemeData theme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step 4 of 7',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '57%',
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
            value: 4 / 7,
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

  /// BELOW CONTENT REMAINS SAME (No Changes)

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What to expect with NaijaFit?',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        SizedBox(height: 1.5.h),
        Text(
          'Evidence-based results from our community of successful users. Real data, realistic expectations.',
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountabilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Accountability Features',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: AccountabilityCardWidget(
                icon: Icons.notifications_active,
                title: 'Daily Check-ins',
                description: 'Track meals & progress',
                successRate: '92% consistency',
                iconColor: const Color(0xFF4CAF50),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: AccountabilityCardWidget(
                icon: Icons.camera_alt,
                title: 'Weekly Photos',
                description: 'Visual progress tracking',
                successRate: '3x more results',
                iconColor: const Color(0xFF2196F3),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: AccountabilityCardWidget(
                icon: Icons.group,
                title: 'Community',
                description: 'Support & motivation',
                successRate: '85% active',
                iconColor: const Color(0xFFFF9800),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAverageResultsSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Text(
            '78% of users reach their weight loss goals',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Average time to goal: 12 weeks',
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSourceCitation() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        'Data based on 10,000+ NaijaFit users over 12 months (2025). Individual results may vary.',
        style: GoogleFonts.inter(fontSize: 11.sp),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true)
                .pushNamed('/professional-support-screen');
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 0.h),
            backgroundColor: const Color(0xFF4CAF50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            )
          ),
          child: Text(
            'Continue',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
