import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Page8ActivityLevel extends StatefulWidget {
  final Function(bool) onNextEnabled;
  final Function(String, dynamic) onDataUpdate;
  final Function(VoidCallback) registerNextCallback;
  final Function(bool) setLoading;
  final VoidCallback navigateNext;

  /// Pass onboarding data so we can calculate calorie here using actual collected data
  final Map<String, dynamic> onboardingData;

  const Page8ActivityLevel({
    super.key,
    required this.onNextEnabled,
    required this.onDataUpdate,
    required this.registerNextCallback,
    required this.setLoading,
    required this.navigateNext,
    required this.onboardingData,
  });

  @override
  State<Page8ActivityLevel> createState() => _Page8ActivityLevelState();
}

class _Page8ActivityLevelState extends State<Page8ActivityLevel>
    with SingleTickerProviderStateMixin {
  String? _selectedActivity;

  final List<Map<String, String>> _activityLevels = [
    {
      'id': 'sedentary',
      'title': 'Sedentary',
      'subtitle': 'Little or no exercise',
    },
    {
      'id': 'lightly_active',
      'title': 'Light active',
      'subtitle': 'Light exercise 1-3 days/week',
    },
    {
      'id': 'moderately_active',
      'title': 'Moderately Active',
      'subtitle': 'Moderate exercise 3-5 days/week',
    },
    {
      'id': 'very_active',
      'title': 'Very Active',
      'subtitle': 'Hard exercise 6-7 days/week',
    },
    {
      'id': 'extremely_active',
      'title': 'Extremely Active',
      'subtitle': 'Very hard exercise & physical job',
    },
  ];

  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fade = CurvedAnimation(
      parent: _anim,
      curve: Curves.easeOut,
    ).drive(Tween(begin: 0.0, end: 1.0));

    _slide = CurvedAnimation(
      parent: _anim,
      curve: Curves.easeOut,
    ).drive(Tween(begin: const Offset(0, 0.08), end: Offset.zero));

    widget.registerNextCallback(_handleNext);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onNextEnabled(false);
        _anim.forward();
      }
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _selectActivity(String id) {
    setState(() => _selectedActivity = id);
    widget.onDataUpdate('activityLevel', id);
    widget.onNextEnabled(true);
  }

  /// ✅ CORRECT BMR Calculation using Mifflin-St Jeor Equation
  /// Uses actual collected data: weight (kg), height (cm), age, gender, activityLevel
  int _calculateDailyCalories(String activityId) {
    final data = widget.onboardingData;

    // Weight in KG (already stored as KG in Page2)
    final double weightKg = (data['currentWeight'] as num?)?.toDouble() ?? 70.0;

    // Height in CM (already stored as CM in Page7)
    final double heightCm = (data['height'] as num?)?.toDouble() ?? 170.0;

    // Age
    final int age = (data['age'] as int?) ?? 25;

    // Gender
    final String gender = (data['gender'] as String?) ?? 'male';

    // BMR using Mifflin-St Jeor
    double bmr;
    if (gender == 'male') {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }

    // Activity multiplier
    double multiplier;
    switch (activityId) {
      case 'lightly_active':
        multiplier = 1.375;
        break;
      case 'moderately_active':
        multiplier = 1.55;
        break;
      case 'very_active':
        multiplier = 1.725;
        break;
      case 'extremely_active':
        multiplier = 1.9;
        break;
      case 'sedentary':
      default:
        multiplier = 1.2;
        break;
    }

    // Goal-based adjustment
    final String fitnessGoal =
        (data['fitnessGoal'] as String?) ?? 'maintain_weight';

    double tdee = bmr * multiplier;
    double targetCalories = tdee;

    if (fitnessGoal == 'lose_weight') {
      targetCalories = tdee - 500;
    } else if (fitnessGoal == 'gain_weight') {
      targetCalories = tdee + 300;
    }

    // Minimum floor to keep it safe
    if (targetCalories < 1200) targetCalories = 1200;

    return targetCalories.round();
  }

  Future<void> _handleNext() async {
    if (_selectedActivity == null) return;

    widget.setLoading(true);

    // Calculate calories with full data
    final int dailyCalories = _calculateDailyCalories(_selectedActivity!);

    widget.onDataUpdate('activityLevel', _selectedActivity);
    widget.onDataUpdate('dailyCalories', dailyCalories);

    widget.setLoading(false);
    widget.navigateNext();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.5.w, vertical: 1.5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Activity Level',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontFamily: "semibold",
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.25,
                ),
              ),

              SizedBox(height: 1.2.h),

              Text(
                'Please choose your activity level',
                style: TextStyle(
                  fontSize: 11.5.sp,
                  fontFamily: "regular",
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6E6E6E),
                  height: 1.4,
                ),
              ),

              SizedBox(height: 3.5.h),

              ...List.generate(_activityLevels.length, (index) {
                final item = _activityLevels[index];
                final bool isSelected = _selectedActivity == item['id'];

                return Padding(
                  padding: EdgeInsets.only(bottom: 1.4.h),
                  child: GestureDetector(
                    onTap: () => _selectActivity(item['id']!),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      width: double.infinity,
                      // ✅ FIXED: Removed fixed height:66, using constraints so content
                      // can breathe on all screen sizes without overflow/overlap
                      constraints: BoxConstraints(minHeight: 7.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.6.h, // ✅ FIXED: was 2.h which caused overflow on small screens
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.w),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF56B327)
                              : const Color(0xFFE1E1E1),
                          width: isSelected ? 1.5 : 1.1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Radio circle
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 5.5.w,   // ✅ FIXED: was 6.w, slightly smaller for balance
                            height: 5.5.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? const Color(0xFF2E7D32)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF2E7D32)
                                    : Colors.black,
                                width: 1.5,
                              ),
                            ),
                            child: isSelected
                                ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 1.8.h, // ✅ FIXED: responsive icon size
                            )
                                : null,
                          ),

                          SizedBox(width: 4.w), // ✅ FIXED: was 5.w

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min, // ✅ FIXED: wrap content tightly
                              children: [
                                Text(
                                  item['title']!,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: "medium",
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    height: 1.2, // ✅ FIXED: was 1 (too tight)
                                  ),
                                ),
                                SizedBox(height: 0.5.h), // ✅ FIXED: was 0.8.h
                                Text(
                                  item['subtitle']!,
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontFamily: "light",
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF8B8B8B),
                                    height: 1.2, // ✅ FIXED: was 1 (too tight, caused clipping)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}