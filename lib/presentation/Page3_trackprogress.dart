import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../services/auth_service.dart';

class Page2GoalsettingPart2 extends StatefulWidget {
  final Function(bool) onNextEnabled;
  final Function(String, dynamic) onDataUpdate;
  final Function(VoidCallback) registerNextCallback;
  final Function(bool) setLoading;
  final VoidCallback navigateNext;

  const Page2GoalsettingPart2({
    super.key,
    required this.onNextEnabled,
    required this.onDataUpdate,
    required this.registerNextCallback,
    required this.setLoading,
    required this.navigateNext,
  });

  @override
  State<Page2GoalsettingPart2> createState() => _Page3TrackProgressState();
}

class _Page3TrackProgressState extends State<Page2GoalsettingPart2>
    with SingleTickerProviderStateMixin {
  bool _weeklyWeighIns = false;
  bool _dailyChart = false;
  bool _measurementTracking = false;

  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  bool get _areAllSwitchesOn =>
      _weeklyWeighIns && _dailyChart && _measurementTracking;

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
    ).drive(Tween(begin: const Offset(0, 0.06), end: Offset.zero));

    widget.registerNextCallback(_handleNext);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onNextEnabled(false);
        widget.onDataUpdate('weeklyWeighIns', _weeklyWeighIns);
        widget.onDataUpdate('dailyChart', _dailyChart);
        widget.onDataUpdate('measurementTracking', _measurementTracking);
        _anim.forward();
      }
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _checkForm() {
    widget.onNextEnabled(_areAllSwitchesOn);
  }

  Future<void> _handleNext() async {
    if (!_areAllSwitchesOn) return;

    widget.setLoading(true);

    widget.onDataUpdate('weeklyWeighIns', _weeklyWeighIns);
    widget.onDataUpdate('dailyChart', _dailyChart);
    widget.onDataUpdate('measurementTracking', _measurementTracking);

    final user = AuthService.instance.currentUser;
    if (user != null) {
      try {
        await AuthService.instance.updateUserProfile(
          userId: user.id,
        );
      } catch (e) {
        debugPrint('Page3 API error: $e');
      }
    }

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
                'Track progress',
                style: TextStyle(
                  fontSize: 19.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.25,
                ),
              ),
              SizedBox(height: 1.6.h),
              Text(
                'Choose how you want to track your\nprogress',
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6E6E6E),
                  height: 1.55,
                ),
              ),
              SizedBox(height: 3.4.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 4.3.w,
                  vertical: 2.2.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF0E7),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Column(
                  children: [
                    _trackingItem(
                      icon: Icons.hourglass_bottom_rounded,
                      title: 'Weekly Weighs-in',
                      subtitle: 'Track Your weight every week',
                      value: _weeklyWeighIns,
                      onChanged: (value) {
                        setState(() => _weeklyWeighIns = value);
                        widget.onDataUpdate('weeklyWeighIns', value);
                        _checkForm();
                      },
                    ),
                    SizedBox(height: 3.h),
                    _trackingItem(
                      icon: Icons.image_rounded,
                      title: 'Daily Chart',
                      subtitle: 'Analysis by daily charts',
                      value: _dailyChart,
                      onChanged: (value) {
                        setState(() => _dailyChart = value);
                        widget.onDataUpdate('dailyChart', value);
                        _checkForm();
                      },
                    ),
                    SizedBox(height: 3.h),
                    _trackingItem(
                      icon: Icons.image_rounded,
                      title: 'Measurement Tracking',
                      subtitle: 'Track body measurements..',
                      value: _measurementTracking,
                      onChanged: (value) {
                        setState(() => _measurementTracking = value);
                        widget.onDataUpdate('measurementTracking', value);
                        _checkForm();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _trackingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: const BoxDecoration(
            color: Color(0xFFD7E7CE),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 7.w,
            color: const Color(0xFF0B7A22),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 8.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6E6E6E),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 2.w),
        Transform.scale(
          scale: 0.95,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF0A8A1F),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade400,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}