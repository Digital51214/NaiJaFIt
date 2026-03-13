import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

/// Bar chart widget comparing weight loss scenarios
/// Shows 5kg (85% success) vs 10kg (60% success) with visual indicators
class WeightLossChartWidget extends StatefulWidget {
  const WeightLossChartWidget({super.key});

  @override
  State<WeightLossChartWidget> createState() => _WeightLossChartWidgetState();
}

class _WeightLossChartWidgetState extends State<WeightLossChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Success Rates by Weight Loss Goal',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF212121),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Based on 12-16 week programs',
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF757575),
            ),
          ),
          SizedBox(height: 3.h),

          // Chart bars
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Column(
                children: [
                  _buildChartBar(
                    label: '5kg Loss',
                    percentage: 85,
                    animatedPercentage: (85 * _animation.value).toInt(),
                    timeline: '12-14 weeks',
                    color: const Color(0xFF4CAF50),
                    icon: Icons.trending_up,
                  ),
                  SizedBox(height: 3.h),
                  _buildChartBar(
                    label: '10kg Loss',
                    percentage: 60,
                    animatedPercentage: (60 * _animation.value).toInt(),
                    timeline: '14-16 weeks',
                    color: const Color(0xFF66BB6A),
                    icon: Icons.show_chart,
                  ),
                ],
              );
            },
          ),

          SizedBox(height: 2.h),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 3.5.w,
                color: const Color(0xFF757575),
              ),
              SizedBox(width: 1.5.w),
              Text(
                'Realistic goals = Higher success rates',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF757575),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar({
    required String label,
    required int percentage,
    required int animatedPercentage,
    required String timeline,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // User avatar icon
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: color.withAlpha(51),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 4.w),
            ),
            SizedBox(width: 2.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF212121),
                  ),
                ),
                Text(
                  timeline,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 1.5.h),

        // Bar with percentage
        Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Background bar
                  Container(
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  // Animated foreground bar
                  FractionallySizedBox(
                    widthFactor: animatedPercentage / 100,
                    child: Container(
                      height: 4.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withAlpha(204)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: color.withAlpha(77),
                            blurRadius: 8.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: animatedPercentage > 15
                            ? Text(
                                '$animatedPercentage%',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 3.w),
            // Percentage label (outside bar if bar is too small)
            if (animatedPercentage <= 15)
              Text(
                '$animatedPercentage%',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
