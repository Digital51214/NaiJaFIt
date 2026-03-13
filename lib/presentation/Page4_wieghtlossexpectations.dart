import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

/// Page 4 — Weight Loss Expectations (no selection needed, always enabled)
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
  late final Animation<double>  _fade;
  late final Animation<Offset>  _slide;

  @override
  void initState() {
    super.initState();
    _anim  = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade  = CurvedAnimation(parent: _anim, curve: Curves.easeOut).drive(Tween(begin: 0.0, end: 1.0));
    _slide = CurvedAnimation(parent: _anim, curve: Curves.easeOut)
        .drive(Tween(begin: const Offset(0, 0.08), end: Offset.zero));

    // This page always allows Next
    widget.onNextEnabled(true);
    WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _anim.forward(); });
  }

  @override
  void dispose() { _anim.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What to expect with NaijaFit?',
                  style: GoogleFonts.poppins(
                      fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.black)),
              SizedBox(height: 1.h),
              Text(
                'Evidence-based results from our community of successful users. Real data, realistic expectations',
                style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 3.h),

              // Success Rates Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 5.w,right: 4.w,left: 4.w,bottom: 7.w),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2,),
                    Text('Success Rates by Weight Loss Goal',
                        style: GoogleFonts.poppins(
                            fontSize: 11.5.sp, fontWeight: FontWeight.w700, color: Colors.black87)),
                    SizedBox(height: 1.h),
                    Text('Based on 12-16 week programs',
                        style: GoogleFonts.poppins(fontSize: 10.sp, color: Colors.grey[600])),
                    SizedBox(height: 2.h),
                    _progressRow(Icons.trending_down, '5Kg Loss',  '12 - 14 Weeks', 0.82),
                    SizedBox(height: 2.h),
                    _progressRow(Icons.trending_up,   '10Kg Loss', '12 - 16 Weeks', 0.68),
                  ],
                ),
              ),
              SizedBox(height: 4.h),

              // Feature cards
              SizedBox(
                height: 115, // card ki height ke mutabiq adjust ho jayega
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [

                    SizedBox(
                      width: 39.w,
                      height: 38.w,
                      child: _featureCard(
                        Icons.bar_chart,
                        'Daily Chart',
                        'Track Meals and progress',
                        Colors.white,
                        Color(0xFF2E7D32),
                      ),
                    ),

                    SizedBox(width: 3.w),

                    SizedBox(
                      width: 39.w,
                      height: 38.w,
                      child: _featureCard(
                        Icons.camera_alt_outlined,
                        'Weekly',
                        'Visual progress tracking',
                        Colors.white.withOpacity(0.2),
                        const Color(0xFF2E7D32),
                      ),
                    ),

                    SizedBox(width: 3.w),

                    SizedBox(
                      width: 39.w,
                      height: 38.w,
                      child: _featureCard(
                        Icons.group_outlined,
                        'Community',
                        'Support & motivation',
                        Colors.white,
                        const Color(0xFF2E7D32),
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
  }

  Widget _progressRow(IconData icon, String label, String duration, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF2E7D32), size: 6.w),
            SizedBox(width: 2.w),
            Expanded(child: Text(label, style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.w600))),
            Text(duration, style: GoogleFonts.poppins(fontSize: 8.2.sp, color: Colors.grey[600])),
          ],
        ),
        SizedBox(height: 0.8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
          ),
        ),
      ],
    );
  }

  Widget _featureCard(IconData icon, String title, String sub, Color bg, Color iconColor) {
    return Container(
      height: 145,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12),border: Border.all(
        width: 1,
        color: Colors.grey.withOpacity(0.5),
      ),),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 13.w, height: 13.w,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 7.w),
          ),
          SizedBox(height: 1.h),
          Text(title,
              style: GoogleFonts.poppins(fontSize: 11.5.sp, fontWeight: FontWeight.w700, color: Colors.black87)),
          SizedBox(height: 0.3.h),
          Text(sub,
              style: GoogleFonts.poppins(fontSize: 8, color: Colors.grey[600]),
              maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
