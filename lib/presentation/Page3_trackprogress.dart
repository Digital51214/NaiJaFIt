// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import '../../services/auth_service.dart';
//
// class Page2GoalsettingPart2 extends StatefulWidget {
//   final Function(bool) onNextEnabled;
//   final Function(String, dynamic) onDataUpdate;
//   final Function(VoidCallback) registerNextCallback;
//   final Function(bool) setLoading;
//   final VoidCallback navigateNext;
//
//   const Page2GoalsettingPart2({
//     super.key,
//     required this.onNextEnabled,
//     required this.onDataUpdate,
//     required this.registerNextCallback,
//     required this.setLoading,
//     required this.navigateNext,
//   });
//
//   @override
//   State<Page2GoalsettingPart2> createState() => _Page3TrackProgressState();
// }
//
// class _Page3TrackProgressState extends State<Page2GoalsettingPart2>
//     with SingleTickerProviderStateMixin {
//   bool _weeklyWeighIns = false;
//   bool _dailyChart = false;
//   bool _measurementTracking = false;
//
//   late final AnimationController _anim;
//   late final Animation<double> _fade;
//   late final Animation<Offset> _slide;
//
//   bool get _isAnySwitchOn =>
//       _weeklyWeighIns || _dailyChart || _measurementTracking;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _anim = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//
//     _fade = CurvedAnimation(
//       parent: _anim,
//       curve: Curves.easeOut,
//     ).drive(Tween(begin: 0.0, end: 1.0));
//
//     _slide = CurvedAnimation(
//       parent: _anim,
//       curve: Curves.easeOut,
//     ).drive(Tween(begin: const Offset(0, 0.06), end: Offset.zero));
//
//     widget.registerNextCallback(_handleNext);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         widget.onNextEnabled(false);
//         widget.onDataUpdate('weeklyWeighIns', _weeklyWeighIns);
//         widget.onDataUpdate('dailyChart', _dailyChart);
//         widget.onDataUpdate('measurementTracking', _measurementTracking);
//         _anim.forward();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _anim.dispose();
//     super.dispose();
//   }
//
//   void _checkForm() {
//     widget.onNextEnabled(_isAnySwitchOn);
//   }
//
//   Future<void> _handleNext() async {
//     if (!_isAnySwitchOn) return;
//
//     widget.setLoading(true);
//
//     widget.onDataUpdate('weeklyWeighIns', _weeklyWeighIns);
//     widget.onDataUpdate('dailyChart', _dailyChart);
//     widget.onDataUpdate('measurementTracking', _measurementTracking);
//
//     try {
//       final user = AuthService.instance.currentUser;
//       if (user != null) {
//         await AuthService.instance.updateUserProfile(
//           userId: user.id,
//         );
//       }
//     } catch (e) {
//       debugPrint('Page3 API error: $e');
//     } finally {
//       widget.setLoading(false);
//     }
//
//     widget.navigateNext();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _fade,
//       child: SlideTransition(
//         position: _slide,
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 5.5.w, vertical: 1.5.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Track progress',
//                 style: TextStyle(
//                   fontSize: 17.5.sp,
//                   fontFamily: 'semibold',
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black,
//                   height: 1.25,
//                 ),
//               ),
//               SizedBox(height: 1.6.h),
//               Text(
//                 'Choose how you want to track your\nprogress',
//                 style: TextStyle(
//                   fontSize: 11.5.sp,
//                   fontFamily: 'regular',
//                   fontWeight: FontWeight.w400,
//                   color: const Color(0xFF6E6E6E),
//                   height: 1.55,
//                 ),
//               ),
//               SizedBox(height: 3.4.h),
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 4.3.w,
//                   vertical: 2.2.h,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFEAF0E7),
//                   borderRadius: BorderRadius.circular(5.w),
//                 ),
//                 child: Column(
//                   children: [
//                     _trackingItem(
//                       icon: Icons.hourglass_bottom_rounded,
//                       title: 'Weekly Weighs-in',
//                       subtitle: 'Track Your weight every week',
//                       value: _weeklyWeighIns,
//                       onChanged: (value) {
//                         setState(() => _weeklyWeighIns = value);
//                         widget.onDataUpdate('weeklyWeighIns', value);
//                         _checkForm();
//                       },
//                     ),
//                     SizedBox(height: 3.h),
//                     _trackingItem(
//                       icon: Icons.image_rounded,
//                       title: 'Daily Chart',
//                       subtitle: 'Analysis by daily charts',
//                       value: _dailyChart,
//                       onChanged: (value) {
//                         setState(() => _dailyChart = value);
//                         widget.onDataUpdate('dailyChart', value);
//                         _checkForm();
//                       },
//                     ),
//                     SizedBox(height: 3.h),
//                     _trackingItem(
//                       icon: Icons.image_rounded,
//                       title: 'Measurement Tracking',
//                       subtitle: 'Track body measurements..',
//                       value: _measurementTracking,
//                       onChanged: (value) {
//                         setState(() => _measurementTracking = value);
//                         widget.onDataUpdate('measurementTracking', value);
//                         _checkForm();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 3.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _trackingItem({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required bool value,
//     required Function(bool) onChanged,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           width: 43,
//           height: 43,
//           decoration: const BoxDecoration(
//             color: Color(0xFFD7E7CE),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(icon, size: 7.w, color: const Color(0xFF026F1A)),
//         ),
//         SizedBox(width: 4.w),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 10.sp,
//                   fontFamily: 'medium',
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: 0.5.h),
//               Text(
//                 subtitle,
//                 style: TextStyle(
//                   fontSize: 7.sp,
//                   fontFamily: 'regular',
//                   fontWeight: FontWeight.w400,
//                   color: const Color(0xFF6E6E6E),
//                   height: 1.35,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(width: 2.w),
//         Transform.scale(
//           scale: 0.95,
//           child: Switch(
//             value: value,
//             onChanged: onChanged,
//             activeColor: Colors.white,
//             activeTrackColor: const Color(0xFF026F1A),
//             inactiveThumbColor: Colors.white,
//             inactiveTrackColor: Colors.grey.shade400,
//             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           ),
//         ),
//       ],
//     );
//   }
// }










import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
  State<Page2GoalsettingPart2> createState() => _Page2GoalsettingPart2State();
}

class _Page2GoalsettingPart2State extends State<Page2GoalsettingPart2>
    with SingleTickerProviderStateMixin {
  bool _weeklyWeightTracker = false;
  bool _dailyProgressChart = false;
  bool _consistencyTracking = false;

  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  bool get _isAnySwitchOn =>
      _weeklyWeightTracker || _dailyProgressChart || _consistencyTracking;

  @override
  void initState() {
    super.initState();

    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _fade = CurvedAnimation(
      parent: _anim,
      curve: Curves.easeOut,
    ).drive(Tween(begin: 0.0, end: 1.0));

    _slide = CurvedAnimation(
      parent: _anim,
      curve: Curves.easeOut,
    ).drive(Tween(begin: const Offset(0, 0.05), end: Offset.zero));

    widget.registerNextCallback(_handleNext);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      widget.onNextEnabled(false);

      widget.onDataUpdate('weeklyWeightTracker', _weeklyWeightTracker);
      widget.onDataUpdate('dailyProgressChart', _dailyProgressChart);
      widget.onDataUpdate('consistencyTracking', _consistencyTracking);

      _anim.forward();
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _checkForm() {
    widget.onNextEnabled(_isAnySwitchOn);
  }

  void _handleNext() {
    if (!_isAnySwitchOn) return;

    widget.setLoading(true);

    widget.onDataUpdate('weeklyWeightTracker', _weeklyWeightTracker);
    widget.onDataUpdate('dailyProgressChart', _dailyProgressChart);
    widget.onDataUpdate('consistencyTracking', _consistencyTracking);

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
                  fontSize: 17.5.sp,
                  fontFamily: 'semibold',
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.25,
                ),
              ),
              SizedBox(height: 1.6.h),
              Text(
                'Choose how you want to track your weight goal journey',
                style: TextStyle(
                  fontSize: 11.5.sp,
                  fontFamily: 'regular',
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6E6E6E),
                  height: 1.55,
                ),
              ),
              SizedBox(height: 3.2.h),
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
                      icon: Icons.monitor_weight_rounded,
                      title: 'Weekly Weight Tracker',
                      subtitle:
                      'Get reminded weekly to enter your weight and monitor changes over time',
                      value: _weeklyWeightTracker,
                      onChanged: (value) {
                        setState(() => _weeklyWeightTracker = value);
                        widget.onDataUpdate('weeklyWeightTracker', value);
                        _checkForm();
                      },
                    ),
                    SizedBox(height: 2.6.h),
                    _trackingItem(
                      icon: Icons.insert_chart_outlined_rounded,
                      title: 'Daily Progress Chart',
                      subtitle:
                      'See your daily calorie progress and visual updates as you log meals',
                      value: _dailyProgressChart,
                      onChanged: (value) {
                        setState(() => _dailyProgressChart = value);
                        widget.onDataUpdate('dailyProgressChart', value);
                        _checkForm();
                      },
                    ),
                    SizedBox(height: 2.6.h),
                    _trackingItem(
                      icon: Icons.local_fire_department_outlined,
                      title: 'Consistency Tracking',
                      subtitle: 'Track daily food logged',
                      value: _consistencyTracking,
                      onChanged: (value) {
                        setState(() => _consistencyTracking = value);
                        widget.onDataUpdate('consistencyTracking', value);
                        _checkForm();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.4.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.8.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAF7),
                  borderRadius: BorderRadius.circular(4.w),
                  border: Border.all(
                    color: const Color(0xFFD7E7CE),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.notifications_active_outlined,
                      color: const Color(0xFF026F1A),
                      size: 5.5.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'You can choose one or more tracking options. Weekly weight reminders and daily progress updates can help keep you on track.',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontFamily: 'regular',
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF4F4F4F),
                          height: 1.45,
                        ),
                      ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            color: Color(0xFFD7E7CE),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 6.2.w,
            color: const Color(0xFF026F1A),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 0.3.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10.3.sp,
                    fontFamily: 'medium',
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 0.55.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 8.3.sp,
                    fontFamily: 'regular',
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6E6E6E),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Padding(
          padding: EdgeInsets.only(top: 0.2.h),
          child: Transform.scale(
            scale: 0.95,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF026F1A),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade400,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
      ],
    );
  }
}