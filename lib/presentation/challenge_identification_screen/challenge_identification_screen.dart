import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/challenge_card_widget.dart';

/// Challenge Identification Screen - Step 3/7 of onboarding
class ChallengeIdentificationScreen extends StatefulWidget {
  const ChallengeIdentificationScreen({super.key});

  @override
  State<ChallengeIdentificationScreen> createState() =>
      _ChallengeIdentificationScreenState();
}

class _ChallengeIdentificationScreenState
    extends State<ChallengeIdentificationScreen>
    with SingleTickerProviderStateMixin {
  int? _selectedChallengeIndex;
  bool _isLoading = false;

  late final AnimationController _controller;

  // Top (upar se neeche)
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;

  late final Animation<Offset> _progressSlide;
  late final Animation<double> _progressFade;

  // Bottom (neeche se upar) - stagger
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;

  late final Animation<Offset> _listSlide;
  late final Animation<double> _listFade;

  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;

  final List<Map<String, dynamic>> _challenges = [
    {
      "id": 1,
      "title": "Poor portion control",
      "icon": "restaurant_menu",
      "description": "Struggle with serving sizes",
    },
    {
      "id": 2,
      "title": "Unhealthy eating",
      "icon": "fastfood",
      "description": "Frequent junk or processed food",
    },
    {
      "id": 3,
      "title": "Low physical activity",
      "icon": "directions_run",
      "description": "Minimal daily exercise",
    },
    {
      "id": 4,
      "title": "Busy work schedule",
      "icon": "work",
      "description": "Schedule affects meal planning",
    },
    {
      "id": 5,
      "title": "Lack of consistency",
      "icon": "event_busy",
      "description": "Hard to maintain habits",
    },
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // ✅ TOP widgets: upar se neeche (stagger)
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.35, curve: Curves.easeOutCubic),
      ),
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.35, curve: Curves.easeOut),
      ),
    );

    _progressSlide = Tween<Offset>(
      begin: const Offset(0, -0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.50, curve: Curves.easeOutCubic),
      ),
    );

    _progressFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.50, curve: Curves.easeOut),
      ),
    );

    // ✅ BOTTOM widgets: neeche se upar (stagger)
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
      ),
    );

    _listSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _listFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 0.85, curve: Curves.easeOut),
      ),
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.70, 1.00, curve: Curves.easeOutCubic),
      ),
    );

    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.70, 1.00, curve: Curves.easeOut),
      ),
    );

    // ✅ IMPORTANT FIX: start animation AFTER first frame render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChallengeSelection(int index) {
    setState(() {
      _selectedChallengeIndex = index;
    });
  }

  Future<void> _handleContinue() async {
    if (_selectedChallengeIndex == null) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/weight-loss-expectations-screen');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          child: Column(
            children: [
              // ✅ Header: top->down
              SlideTransition(
                position: _headerSlide,
                child: FadeTransition(
                  opacity: _headerFade,
                  child: _buildHeader(theme),
                ),
              ),

              SizedBox(height: 3.h),

              /// ✅ Progress: top->down
              SlideTransition(
                position: _progressSlide,
                child: FadeTransition(
                  opacity: _progressFade,
                  child: _buildProgressIndicator(theme),
                ),
              ),

              SizedBox(height: 4.h),

              /// ✅ Title: bottom->up
              SlideTransition(
                position: _titleSlide,
                child: FadeTransition(
                  opacity: _titleFade,
                  child: _buildTitle(theme),
                ),
              ),

              SizedBox(height: 3.h),

              /// ✅ List: bottom->up
              Expanded(
                child: SlideTransition(
                  position: _listSlide,
                  child: FadeTransition(
                    opacity: _listFade,
                    child: _buildChallengesList(),
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              /// ✅ Button: bottom->up
              SlideTransition(
                position: _buttonSlide,
                child: FadeTransition(
                  opacity: _buttonFade,
                  child: _buildContinueButton(theme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
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
            child: const Center(
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

  /// ✅ NEW PROFESSIONAL PROGRESS (3/7)
  Widget _buildProgressIndicator(ThemeData theme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step 3 of 7',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '43%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 3 / 7,
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

  Widget _buildTitle(ThemeData theme) {
    return Column(
      children: [
        Text(
          'What\'s the biggest challenge you have in reaching your goals?',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        Text(
          'Select the challenge that resonates most with you',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildChallengesList() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: _challenges.length,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        final challenge = _challenges[index];
        final isSelected = _selectedChallengeIndex == index;

        return ChallengeCardWidget(
          title: challenge["title"] as String,
          icon: challenge["icon"] as String,
          description: challenge["description"] as String,
          isSelected: isSelected,
          onTap: () => _handleChallengeSelection(index),
        );
      },
    );
  }

  Widget _buildContinueButton(ThemeData theme) {
    final isEnabled = _selectedChallengeIndex != null;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isEnabled && !_isLoading ? _handleContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          padding: EdgeInsets.symmetric(vertical: 0.h),
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: isEnabled ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isLoading
            ? SizedBox(
          width: 5.w,
          height: 5.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.onPrimary,
            ),
          ),
        )
            : Text(
          'Continue',
          style: GoogleFonts.inter(textStyle: theme.textTheme.labelLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,)
          ),
        ),
      ),
    );
  }
}
