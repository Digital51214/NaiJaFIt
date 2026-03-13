import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../services/auth_service.dart';

/// Professional Support Screen - Step 5 of 7 in NaijaFit onboarding flow
/// Asks users if they work with a diet coach or nutritionist
/// Helps NaijaFit complement rather than replace professional guidance
class ProfessionalSupportScreen extends StatefulWidget {
  const ProfessionalSupportScreen({super.key});

  @override
  State<ProfessionalSupportScreen> createState() =>
      _ProfessionalSupportScreenState();
}

class _ProfessionalSupportScreenState extends State<ProfessionalSupportScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedOption;
  bool _isLoading = false;

  late final AnimationController _controller;

  // Top (upar se neeche)
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;

  late final Animation<Offset> _progressSlide;
  late final Animation<double> _progressFade;

  // Middle (neeche se upar) - stagger
  late final Animation<Offset> _iconSlide;
  late final Animation<double> _iconFade;

  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;

  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _subtitleFade;

  late final Animation<Offset> _yesSlide;
  late final Animation<double> _yesFade;

  late final Animation<Offset> _noSlide;
  late final Animation<double> _noFade;

  // Bottom buttons (neeche se upar)
  late final Animation<Offset> _continueSlide;
  late final Animation<double> _continueFade;

  late final Animation<Offset> _skipSlide;
  late final Animation<double> _skipFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // ✅ TOP: header
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.22, curve: Curves.easeOutCubic),
      ),
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.22, curve: Curves.easeOut),
      ),
    );

    // ✅ TOP: progress
    _progressSlide = Tween<Offset>(
      begin: const Offset(0, -0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.10, 0.32, curve: Curves.easeOutCubic),
      ),
    );

    _progressFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.10, 0.32, curve: Curves.easeOut),
      ),
    );

    // ✅ MIDDLE: icon
    _iconSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    _iconFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.45, curve: Curves.easeOut),
      ),
    );

    // ✅ MIDDLE: title
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.55, curve: Curves.easeOut),
      ),
    );

    // ✅ MIDDLE: subtitle
    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.28),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.42, 0.62, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.42, 0.62, curve: Curves.easeOut),
      ),
    );

    // ✅ MIDDLE: yes option
    _yesSlide = Tween<Offset>(
      begin: const Offset(0, 0.30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.52, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _yesFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.52, 0.75, curve: Curves.easeOut),
      ),
    );

    // ✅ MIDDLE: no option
    _noSlide = Tween<Offset>(
      begin: const Offset(0, 0.30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.62, 0.88, curve: Curves.easeOutCubic),
      ),
    );

    _noFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.62, 0.88, curve: Curves.easeOut),
      ),
    );

    // ✅ BOTTOM: continue
    _continueSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.72, 0.95, curve: Curves.easeOutCubic),
      ),
    );

    _continueFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.72, 0.95, curve: Curves.easeOut),
      ),
    );

    // ✅ BOTTOM: skip
    _skipSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.80, 1.00, curve: Curves.easeOutCubic),
      ),
    );

    _skipFade = Tween<double>(begin: 0, end: 1).animate(
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

  void _handleOptionSelection(String option) {
    setState(() {
      _selectedOption = option;
    });
  }

  Future<void> _handleContinue() async {
    if (_selectedOption == null) return;

    setState(() {
      _isLoading = true;
    });

    // Update user profile with professional support preference
    final user = AuthService.instance.currentUser;
    if (user != null) {
      try {
        await AuthService.instance.updateUserProfile(userId: user.id);
      } catch (e) {
        debugPrint('Failed to update professional support preference: $e');
      }
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/personal-stats-screen');
  }

  void _handleSkip() {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/personal-stats-screen');
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ✅ Header animated (top->down)
                    SlideTransition(
                      position: _headerSlide,
                      child: FadeTransition(
                        opacity: _headerFade,
                        child: _buildHeader(theme),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // ✅ Progress animated (top->down)
                    SlideTransition(
                      position: _progressSlide,
                      child: FadeTransition(
                        opacity: _progressFade,
                        child: _buildProgressIndicator(theme),
                      ),
                    ),

                    SizedBox(height: 5.h),

                    // ✅ Icon animated (bottom->up)
                    SlideTransition(
                      position: _iconSlide,
                      child: FadeTransition(
                        opacity: _iconFade,
                        child: _buildIcon(theme),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // ✅ Title animated (bottom->up)
                    SlideTransition(
                      position: _titleSlide,
                      child: FadeTransition(
                        opacity: _titleFade,
                        child: _buildTitle(theme),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // ✅ Subtitle animated (bottom->up)
                    SlideTransition(
                      position: _subtitleSlide,
                      child: FadeTransition(
                        opacity: _subtitleFade,
                        child: _buildSubtitle(theme),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // ✅ Yes option animated (bottom->up)
                    SlideTransition(
                      position: _yesSlide,
                      child: FadeTransition(
                        opacity: _yesFade,
                        child: _buildYesOption(theme),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // ✅ No option animated (bottom->up)
                    SlideTransition(
                      position: _noSlide,
                      child: FadeTransition(
                        opacity: _noFade,
                        child: _buildNoOption(theme),
                      ),
                    ),

                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ),

            // Bottom buttons area
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
              child: Column(
                children: [
                  // ✅ Continue animated (bottom->up)
                  SlideTransition(
                    position: _continueSlide,
                    child: FadeTransition(
                      opacity: _continueFade,
                      child: _buildContinueButton(theme),
                    ),
                  ),
                  SizedBox(height: 1.h),

                  // ✅ Skip animated (bottom->up)
                  SlideTransition(
                    position: _skipSlide,
                    child: FadeTransition(
                      opacity: _skipFade,
                      child: _buildSkipButton(theme),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
              semanticLabel: 'NaijaFit logo',
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

  Widget _buildProgressIndicator(ThemeData theme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step 5 of 7',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '71%',
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
            value: 5 / 7,
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

  Widget _buildIcon(ThemeData theme) {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'health_and_safety',
          color: theme.colorScheme.onPrimary,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      'Do you currently work with a diet coach or nutritionist?',
      textAlign: TextAlign.center,
      style: theme.textTheme.headlineSmall?.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w700,
        height: 1,
      ),
    );
  }

  Widget _buildSubtitle(ThemeData theme) {
    return Text(
      'This helps NaijaFit complement rather than replace professional guidance',
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        height: 1.5,
      ),
    );
  }

  Widget _buildYesOption(ThemeData theme) {
    final isSelected = _selectedOption == 'yes';

    return InkWell(
      onTap: () => _handleOptionSelection('yes'),
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'person_check',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yes',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'I work with a professional',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'NaijaFit will complement your existing professional guidance',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 11.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'check',
                    color: theme.colorScheme.onPrimary,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoOption(ThemeData theme) {
    final isSelected = _selectedOption == 'no';

    return InkWell(
      onTap: () => _handleOptionSelection('no'),
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'person',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    "I don't currently work with anyone",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'NaijaFit will provide comprehensive nutrition guidance',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 11.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'check',
                    color: theme.colorScheme.onPrimary,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(ThemeData theme) {
    final isEnabled = _selectedOption != null;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isEnabled && !_isLoading ? _handleContinue : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 0.h),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
          disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.onPrimary,
            ),
          ),
        )
            : Text(
          'Continue',
          style: theme.textTheme.titleMedium?.copyWith(
            color: isEnabled
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton(ThemeData theme) {
    return TextButton(
      onPressed: _handleSkip,
      child: Text(
        'Skip for now',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
