import 'package:flutter/material.dart';
import 'package:naijafit/presentation/challenge_identification_screen/challenge_identification_screen.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/timeline_card_widget.dart';
import './widgets/tracking_preference_widget.dart';
import './widgets/weight_simulator_widget.dart';

class GoalSettingDetailsScreen extends StatefulWidget {
  const GoalSettingDetailsScreen({super.key});

  @override
  State<GoalSettingDetailsScreen> createState() =>
      _GoalSettingDetailsScreenState();
}

class _GoalSettingDetailsScreenState extends State<GoalSettingDetailsScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentWeightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();

  // Form field values
  double? _currentWeight;
  double? _targetWeight;
  String? _selectedTimeline;
  bool _isWeightInKg = true;

  // Progress tracking preferences
  bool _weeklyWeighIns = true;
  bool _photoProgress = false;
  bool _measurementTracking = false;

  // Validation states
  bool _isCurrentWeightValid = false;
  bool _isTargetWeightValid = false;
  bool _isTimelineValid = false;

  final List<Map<String, dynamic>> _timelineOptions = [
    {
      'weeks': 4,
      'label': '4 Weeks',
      'difficulty': 'Aggressive',
      'recommended': false,
    },
    {
      'weeks': 8,
      'label': '8 Weeks',
      'difficulty': 'Moderate',
      'recommended': true,
    },
    {
      'weeks': 12,
      'label': '12 Weeks',
      'difficulty': 'Balanced',
      'recommended': true,
    },
    {
      'weeks': 16,
      'label': '16 Weeks',
      'difficulty': 'Gradual',
      'recommended': true,
    },
  ];

  // ✅ Animations
  late final AnimationController _controller;

  late final Animation<double> _headerOpacity;
  late final Animation<Offset> _headerSlide;

  late final Animation<double> _progressOpacity;
  late final Animation<Offset> _progressSlide;

  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;

  late final Animation<double> _weightOpacity;
  late final Animation<Offset> _weightSlide;

  late final Animation<double> _timelineOpacity;
  late final Animation<Offset> _timelineSlide;

  late final Animation<double> _simulatorOpacity;
  late final Animation<Offset> _simulatorSlide;

  late final Animation<double> _trackingOpacity;
  late final Animation<Offset> _trackingSlide;

  late final Animation<double> _buttonOpacity;
  late final Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();
    _loadUserWeight();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    // Header: top -> down
    _headerOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.18, curve: Curves.easeOut),
      ),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.18, curve: Curves.easeOut),
      ),
    );

    // Staggered: bottom -> up
    _progressOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.16, 0.28, curve: Curves.easeOut),
      ),
    );
    _progressSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.16, 0.28, curve: Curves.easeOut),
      ),
    );

    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.26, 0.40, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.26, 0.40, curve: Curves.easeOut),
      ),
    );

    _weightOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.38, 0.54, curve: Curves.easeOut),
      ),
    );
    _weightSlide = Tween<Offset>(
      begin: const Offset(0, 0.22),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.38, 0.54, curve: Curves.easeOut),
      ),
    );

    _timelineOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.52, 0.68, curve: Curves.easeOut),
      ),
    );
    _timelineSlide = Tween<Offset>(
      begin: const Offset(0, 0.22),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.52, 0.68, curve: Curves.easeOut),
      ),
    );

    _simulatorOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 0.78, curve: Curves.easeOut),
      ),
    );
    _simulatorSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 0.78, curve: Curves.easeOut),
      ),
    );

    _trackingOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.76, 0.92, curve: Curves.easeOut),
      ),
    );
    _trackingSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.76, 0.92, curve: Curves.easeOut),
      ),
    );

    _buttonOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.86, 1.0, curve: Curves.easeOut),
      ),
    );
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.86, 1.0, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  Widget _fadeSlide({
    required Animation<double> opacity,
    required Animation<Offset> slide,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: opacity,
      child: SlideTransition(
        position: slide,
        child: child,
      ),
    );
  }

  void _loadUserWeight() async {
    final user = AuthService.instance.currentUser;
    if (user != null) {
      try {
        await AuthService.instance.getUserProfile(user.id);
      } catch (e) {
        debugPrint('Failed to load user profile: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _currentWeightController.dispose();
    _targetWeightController.dispose();
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
              // ✅ Header animation (top -> down)
              _fadeSlide(
                opacity: _headerOpacity,
                slide: _headerSlide,
                child: _buildHeader(theme),
              ),

              SizedBox(height: 3.h),

              // ✅ Progress animation
              _fadeSlide(
                opacity: _progressOpacity,
                slide: _progressSlide,
                child: _buildProgressIndicator(theme),
              ),

              SizedBox(height: 4.h),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Title
                        _fadeSlide(
                          opacity: _titleOpacity,
                          slide: _titleSlide,
                          child: _buildTitle(theme),
                        ),

                        SizedBox(height: 4.h),

                        // ✅ Weight section
                        _fadeSlide(
                          opacity: _weightOpacity,
                          slide: _weightSlide,
                          child: _buildWeightSection(theme),
                        ),

                        SizedBox(height: 4.h),

                        // ✅ Timeline section
                        _fadeSlide(
                          opacity: _timelineOpacity,
                          slide: _timelineSlide,
                          child: _buildTimelineSection(theme),
                        ),

                        SizedBox(height: 4.h),

                        // ✅ Simulator
                        _fadeSlide(
                          opacity: _simulatorOpacity,
                          slide: _simulatorSlide,
                          child: WeightSimulatorWidget(
                            currentWeight: _currentWeight,
                            targetWeight: _targetWeight,
                            weeks: _selectedTimeline != null
                                ? int.parse(_selectedTimeline!.split(' ')[0])
                                : null,
                            isKg: _isWeightInKg,
                          ),
                        ),

                        SizedBox(height: 4.h),

                        // ✅ Tracking
                        _fadeSlide(
                          opacity: _trackingOpacity,
                          slide: _trackingSlide,
                          child: _buildTrackingPreferences(theme),
                        ),

                        SizedBox(height: 3.h),
                      ],
                    ),
                  ),
                ),
              ),

              // ✅ Continue button (last)
              _fadeSlide(
                opacity: _buttonOpacity,
                slide: _buttonSlide,
                child: _buildContinueButton(theme),
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
            child: Center(
              child: Icon(Icons.arrow_back_ios_new),
            ),
          ),
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/NaijaFit_logo.png',
              height: 28,
              width: 28,
              fit: BoxFit.contain,
              semanticLabel: 'NaijaFit logo',
            ),
            SizedBox(width: 2.w),
            Text(
              'NaijaFit',
              style:  theme.textTheme.titleLarge?.copyWith(
                color: Colors.green,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step 2 of 7',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '29%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 2 / 7,
            minHeight: 8,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let's set your target",
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'We\'ll create a personalized plan based on your goals',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildWeightSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Weight Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            _buildUnitToggle(theme),
          ],
        ),
        SizedBox(height: 2.h),
        _buildWeightInput(
          theme,
          'Current Weight',
          _currentWeightController,
          _isCurrentWeightValid,
              (value) {
            final weight = double.tryParse(value);
            setState(() {
              _currentWeight = weight;
              _isCurrentWeightValid = _validateWeight(weight);
            });
          },
        ),
        SizedBox(height: 2.h),
        _buildWeightInput(
          theme,
          'Target Weight',
          _targetWeightController,
          _isTargetWeightValid,
              (value) {
            final weight = double.tryParse(value);
            setState(() {
              _targetWeight = weight;
              _isTargetWeightValid =
                  _validateWeight(weight) && _validateTargetWeight(weight);
            });
          },
        ),
        if (_targetWeight != null &&
            _currentWeight != null &&
            !_validateTargetWeight(_targetWeight))
          Padding(
            padding: EdgeInsets.only(top: 1.h, left: 3.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: theme.colorScheme.error,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Target weight should differ from current weight by at least 2 ${_isWeightInKg ? 'kg' : 'lbs'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildWeightInput(
      ThemeData theme,
      String label,
      TextEditingController controller,
      bool isValid,
      Function(String) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:  theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style:  theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: _isWeightInKg ? 'Enter weight in kg 30 to 300' : 'Enter weight in lbs 66 to 660',
            hintStyle: GoogleFonts.poppins(textStyle: theme.inputDecorationTheme.hintStyle,),
            suffixIcon: isValid
                ? Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'check_circle',
                color: Colors.green,
                size: 20,
              ),
            )
                : null,
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: BorderSide(
                color: Colors.green,
                width: 2,
              ),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildUnitToggle(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          _buildToggleButton('kg', _isWeightInKg, theme),
          _buildToggleButton('lbs', !_isWeightInKg, theme),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isWeightInKg = label == 'kg';
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Timeline',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Choose a realistic timeframe for your goal',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 18.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _timelineOptions.length,
            itemBuilder: (context, index) {
              final option = _timelineOptions[index];
              final isSelected = _selectedTimeline == option['label'];
              return Padding(
                padding: EdgeInsets.only(right: 3.w),
                child: TimelineCardWidget(
                  weeks: option['weeks'] as int,
                  label: option['label'] as String,
                  difficulty: option['difficulty'] as String,
                  isRecommended: option['recommended'] as bool,
                  isSelected: isSelected,
                  weeklyChange: _calculateWeeklyChange(option['weeks'] as int),
                  onTap: () {
                    setState(() {
                      _selectedTimeline = option['label'] as String;
                      _isTimelineValid = true;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingPreferences(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress Tracking',
          style:  theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Choose how you want to track your progress',
          style:  theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        TrackingPreferenceWidget(
          title: 'Weekly Weigh-ins',
          description: 'Track your weight every week',
          icon: 'scale',
          isEnabled: _weeklyWeighIns,
          onToggle: (value) {
            setState(() {
              _weeklyWeighIns = value;
            });
          },
        ),
        SizedBox(height: 1.5.h),
        TrackingPreferenceWidget(
          title: 'Photo Progress',
          description: 'Take progress photos to...',
          icon: 'camera_alt',
          isEnabled: _photoProgress,
          onToggle: (value) {
            setState(() {
              _photoProgress = value;
            });
          },
        ),
        SizedBox(height: 1.5.h),
        TrackingPreferenceWidget(
          title: 'Measurement Tracking',
          description: 'Track body measurements...',
          icon: 'straighten',
          isEnabled: _measurementTracking,
          onToggle: (value) {
            setState(() {
              _measurementTracking = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildContinueButton(ThemeData theme) {
    final bool isFormComplete =
        _isCurrentWeightValid && _isTargetWeightValid && _isTimelineValid;

    return Container(
      width: double.infinity,
      height: 48,
      padding: EdgeInsets.symmetric(),
      child: ElevatedButton(
        onPressed: isFormComplete
            ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeIdentificationScreen(),
            ),
          );
        }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormComplete
              ? Colors.green
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          foregroundColor: theme.colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(vertical: 0.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: isFormComplete ? 2 : 0,
        ),
        child: Text(
          'Continue',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  bool _validateWeight(double? weight) {
    if (weight == null) return false;
    if (_isWeightInKg) {
      return weight >= 30 && weight <= 300;
    } else {
      return weight >= 66 && weight <= 660;
    }
  }

  bool _validateTargetWeight(double? targetWeight) {
    if (targetWeight == null || _currentWeight == null) return false;
    final difference = (targetWeight - _currentWeight!).abs();
    return difference >= 2;
  }

  double? _calculateWeeklyChange(int weeks) {
    if (_currentWeight == null || _targetWeight == null) return null;
    final totalChange = _targetWeight! - _currentWeight!;
    return totalChange / weeks;
  }

  void _onContinue() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = AuthService.instance.currentUser;
      if (user != null) {
        try {
          await AuthService.instance.updateUserProfile(userId: user.id);
        } catch (e) {
          debugPrint('Failed to update weight details: $e');
        }
      }

      if (!mounted) return;

      Navigator.of(context, rootNavigator: true)
          .pushNamed('/challenge-identification-screen');
    }
  }
}