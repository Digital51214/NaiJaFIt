import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Page4WeightLossExpectations extends StatefulWidget {
  final Function(bool) onNextEnabled;
  final Function(String, dynamic) onDataUpdate;

  const Page4WeightLossExpectations({
    super.key,
    required this.onNextEnabled,
    required this.onDataUpdate,
  });

  @override
  State<Page4WeightLossExpectations> createState() =>
      _Page4WeightLossExpectationsState();
}

class _Page4WeightLossExpectationsState
    extends State<Page4WeightLossExpectations>
    with SingleTickerProviderStateMixin {
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
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut)
        .drive(Tween(begin: 0.0, end: 1.0));
    _slide = CurvedAnimation(parent: _anim, curve: Curves.easeOut)
        .drive(Tween(begin: const Offset(0, 0.08), end: Offset.zero));

    widget.onNextEnabled(true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _anim.forward();
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
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
                'What to expect with NaijaFit?',
                style: TextStyle(
                  fontSize: 18.5.sp,
                  fontFamily: "Poppin",
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.25,
                ),
              ),

              SizedBox(height: 1.2.h),

              Text(
                'Evidence-based results from our\ncommunity of successful users. Real data,\nrealistic expectations',
                style: TextStyle(
                  fontSize: 11.8.sp,
                  fontFamily: "Poppin",
                  color: const Color(0xFF6E6E6E),
                  height: 1.45,
                ),
              ),

              SizedBox(height: 3.2.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 2.3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F3),
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Success Rates by Weight Goal',
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        fontFamily: "Poppin",
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 0.6.h),

                    Text(
                      'Based on 12-16 week programs',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        fontFamily: "Poppin",
                        color: const Color(0xFF6E6E6E),
                      ),
                    ),

                    SizedBox(height: 2.2.h),

                    _progressRow(
                      Icons.trending_down_rounded,
                      '5Kg Loss',
                      '12 - 14 Weeks',
                      0.74,
                    ),

                    SizedBox(height: 2.3.h),

                    _progressRow(
                      Icons.trending_up_rounded,
                      '10Kg Gain',
                      '12 - 16 Weeks',
                      0.74,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.4.h),

              _featureCard(
                Icons.notifications_none_rounded,
                'Daily Chart',
                'Track Meals and progress',
              ),

              SizedBox(height: 1.4.h),

              _featureCard(
                Icons.camera_alt_outlined,
                'Weekly',
                'Visual Progress Tracking',
              ),

              SizedBox(height: 1.4.h),

              _featureCard(
                Icons.groups_2_outlined,
                'Community',
                'Support & motivation',
              ),

              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressRow(
      IconData icon,
      String label,
      String duration,
      double progress,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF56A61F),
              size: 5.2.w,
            ),
            SizedBox(width: 2.3.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10.3.sp,
                  fontFamily: "Poppin",
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              duration,
              style: TextStyle(
                fontSize: 8.3.sp,
                fontFamily: "Poppin",
                color: const Color(0xFF7A7A7A),
              ),
            ),
          ],
        ),
        SizedBox(height: 0.8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 0.65.h,
            backgroundColor: const Color(0xFFE2E8DB),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF56A61F),
            ),
          ),
        ),
      ],
    );
  }

  Widget _featureCard(
      IconData icon,
      String title,
      String sub,
      ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.2.w, vertical: 2.1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7.w),
        border: Border.all(
          width: 1,
          color: const Color(0xFFE3E3E3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 13.w,
            height: 13.w,
            decoration: const BoxDecoration(
              color: Color(0xFFE1ECD7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF56A61F),
              size: 6.5.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.8.sp,
                    fontFamily: "Poppin",
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 0.2.h),
                Text(
                  sub,
                  style: TextStyle(
                    fontSize: 9.2.sp,
                    fontFamily: "Poppin",
                    color: const Color(0xFF8A8A8A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}