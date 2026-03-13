import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_level_widget.dart';
import './widgets/age_input_widget.dart';
import './widgets/gender_selection_widget.dart';
import './widgets/height_input_widget.dart';
import './widgets/weight_input_widget.dart';

/// Personal Stats Screen - Step 6 of 7 in NaijaFit onboarding flow
/// Collects user's physical metrics for personalized calorie calculations
class PersonalStatsScreen extends StatefulWidget {
  const PersonalStatsScreen({super.key});

  @override
  State<PersonalStatsScreen> createState() => _PersonalStatsScreenState();
}

class _PersonalStatsScreenState extends State<PersonalStatsScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Form field values
  int? _age;
  double? _heightCm;
  double? _heightFeet;
  double? _heightInches;
  double? _weight;
  String _activityLevel = '';
  String _gender = '';

  // Unit toggles
  bool _isHeightInCm = true;
  bool _isWeightInKg = true;

  // Validation states
  bool _isAgeValid = false;
  bool _isHeightValid = false;
  bool _isWeightValid = false;
  bool _isActivityLevelValid = false;
  bool _isGenderValid = false;

  // ✅ Animations
  late final AnimationController _controller;

  // Top (upar se neeche)
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;

  late final Animation<Offset> _progressSlide;
  late final Animation<double> _progressFade;

  // Form fields (neeche se upar) - stagger
  late final Animation<Offset> _ageSlide;
  late final Animation<double> _ageFade;

  late final Animation<Offset> _heightSlide;
  late final Animation<double> _heightFade;

  late final Animation<Offset> _weightSlide;
  late final Animation<double> _weightFade;

  late final Animation<Offset> _activitySlide;
  late final Animation<double> _activityFade;

  late final Animation<Offset> _genderSlide;
  late final Animation<double> _genderFade;

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
        curve: const Interval(0.10, 0.28, curve: Curves.easeOutCubic),
      ),
    );

    _progressFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.10, 0.28, curve: Curves.easeOut),
      ),
    );

    // ✅ FORM: Age
    _ageSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.22, 0.40, curve: Curves.easeOutCubic),
      ),
    );

    _ageFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.22, 0.40, curve: Curves.easeOut),
      ),
    );

    // ✅ FORM: Height
    _heightSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.32, 0.52, curve: Curves.easeOutCubic),
      ),
    );

    _heightFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.32, 0.52, curve: Curves.easeOut),
      ),
    );

    // ✅ FORM: Weight
    _weightSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.42, 0.64, curve: Curves.easeOutCubic),
      ),
    );

    _weightFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.42, 0.64, curve: Curves.easeOut),
      ),
    );

    // ✅ FORM: Activity
    _activitySlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.54, 0.78, curve: Curves.easeOutCubic),
      ),
    );

    _activityFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.54, 0.78, curve: Curves.easeOut),
      ),
    );

    // ✅ FORM: Gender
    _genderSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.64, 0.90, curve: Curves.easeOutCubic),
      ),
    );

    _genderFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.64, 0.90, curve: Curves.easeOut),
      ),
    );

    // ✅ Bottom button
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.78, 1.00, curve: Curves.easeOutCubic),
      ),
    );

    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.78, 1.00, curve: Curves.easeOut),
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
              // ✅ Header animate
              SlideTransition(
                position: _headerSlide,
                child: FadeTransition(
                  opacity: _headerFade,
                  child: _buildHeader(theme),
                ),
              ),
              SizedBox(height: 3.h),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Age animated
                        SlideTransition(
                          position: _ageSlide,
                          child: FadeTransition(
                            opacity: _ageFade,
                            child: AgeInputWidget(
                              onChanged: (age) {
                                setState(() {
                                  _age = age;
                                  _isAgeValid =
                                      age != null && age >= 16 && age <= 80;
                                });
                              },
                              isValid: _isAgeValid,
                            ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // ✅ Height animated
                        SlideTransition(
                          position: _heightSlide,
                          child: FadeTransition(
                            opacity: _heightFade,
                            child: HeightInputWidget(
                              isInCm: _isHeightInCm,
                              onUnitToggle: (isInCm) {
                                setState(() {
                                  _isHeightInCm = isInCm;
                                  if (isInCm && _heightFeet != null) {
                                    _heightCm = (_heightFeet! * 30.48) +
                                        ((_heightInches ?? 0) * 2.54);
                                  } else if (!isInCm && _heightCm != null) {
                                    _heightFeet =
                                        (_heightCm! / 30.48).floor().toDouble();
                                    _heightInches = ((_heightCm! % 30.48) / 2.54);
                                  }
                                });
                              },
                              onHeightChanged: (cm, feet, inches) {
                                setState(() {
                                  _heightCm = cm;
                                  _heightFeet = feet;
                                  _heightInches = inches;
                                  _isHeightValid =
                                      (cm != null && cm >= 120 && cm <= 250) ||
                                          (feet != null && feet >= 4 && feet <= 8);
                                });
                              },
                              isValid: _isHeightValid,
                            ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // ✅ Weight animated
                        SlideTransition(
                          position: _weightSlide,
                          child: FadeTransition(
                            opacity: _weightFade,
                            child: WeightInputWidget(
                              isInKg: _isWeightInKg,
                              onUnitToggle: (isInKg) {
                                setState(() {
                                  _isWeightInKg = isInKg;
                                  if (_weight != null) {
                                    _weight = isInKg
                                        ? _weight! / 2.205
                                        : _weight! * 2.205;
                                  }
                                });
                              },
                              onWeightChanged: (weight) {
                                setState(() {
                                  _weight = weight;
                                  _isWeightValid =
                                      weight != null &&
                                          ((_isWeightInKg &&
                                              weight >= 30 &&
                                              weight <= 300) ||
                                              (!_isWeightInKg &&
                                                  weight >= 66 &&
                                                  weight <= 660));
                                });
                              },
                              isValid: _isWeightValid,
                            ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // ✅ Activity animated
                        SlideTransition(
                          position: _activitySlide,
                          child: FadeTransition(
                            opacity: _activityFade,
                            child: ActivityLevelWidget(
                              selectedLevel: _activityLevel,
                              onLevelSelected: (level) {
                                setState(() {
                                  _activityLevel = level;
                                  _isActivityLevelValid = level.isNotEmpty;
                                });
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // ✅ Gender animated
                        SlideTransition(
                          position: _genderSlide,
                          child: FadeTransition(
                            opacity: _genderFade,
                            child: GenderSelectionWidget(
                              selectedGender: _gender,
                              onGenderSelected: (gender) {
                                setState(() {
                                  _gender = gender;
                                  _isGenderValid = gender.isNotEmpty;
                                });
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ),
              ),

              // ✅ Button animated
              SlideTransition(
                position: _buttonSlide,
                child: FadeTransition(
                  opacity: _buttonFade,
                  child: _buildCalculateButton(theme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Row(
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
            Expanded(
              child: Center(
                child: Text(
                  'Tell Us About Yourself',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
          ],
        ),
        SizedBox(height: 2.h),

        // ✅ Progress animated (wrapped in parent already via header animation? NO -> keep same layout)
        SlideTransition(
          position: _progressSlide,
          child: FadeTransition(
            opacity: _progressFade,
            child: _buildProgressIndicator(theme),
          ),
        ),
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
              'Step 6 of 7',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '86%',
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
            value: 6 / 7,
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

  Widget _buildCalculateButton(ThemeData theme) {
    final bool isFormComplete = _isAgeValid &&
        _isHeightValid &&
        _isWeightValid &&
        _isActivityLevelValid &&
        _isGenderValid;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.h),
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isFormComplete ? _calculateTarget : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormComplete
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          foregroundColor: theme.colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(vertical: 0.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: isFormComplete ? 2 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Calculate My Target',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'arrow_forward',
              color: theme.colorScheme.onPrimary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _calculateTarget() {
    if (_formKey.currentState?.validate() ?? false) {
      // Calculate BMR using Mifflin-St Jeor Equation
      double heightInCm = _isHeightInCm
          ? _heightCm!
          : (_heightFeet! * 30.48) + ((_heightInches ?? 0) * 2.54);
      double weightInKg = _isWeightInKg ? _weight! : _weight! / 2.205;

      double bmr;
      if (_gender.toLowerCase() == 'male') {
        bmr = (10 * weightInKg) + (6.25 * heightInCm) - (5 * _age!) + 5;
      } else {
        bmr = (10 * weightInKg) + (6.25 * heightInCm) - (5 * _age!) - 161;
      }

      // Apply activity multiplier
      double activityMultiplier = 1.2;
      switch (_activityLevel.toLowerCase()) {
        case 'sedentary':
          activityMultiplier = 1.2;
          break;
        case 'lightly active':
          activityMultiplier = 1.375;
          break;
        case 'moderately active':
          activityMultiplier = 1.55;
          break;
        case 'very active':
          activityMultiplier = 1.725;
          break;
        case 'extremely active':
          activityMultiplier = 1.9;
          break;
      }

      double dailyCalories = bmr * activityMultiplier;

      // Navigate to calorie target display screen
      Navigator.of(context, rootNavigator: true).pushNamed(
        AppRoutes.calorieTargetDisplay,
        arguments: {
          'dailyCalories': dailyCalories.round(),
          'age': _age,
          'height': heightInCm,
          'weight': weightInKg,
          'activityLevel': _activityLevel,
          'gender': _gender,
        },
      );
    }
  }
}
