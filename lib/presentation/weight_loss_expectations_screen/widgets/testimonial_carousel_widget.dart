import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

/// Testimonial carousel showing user success stories
/// Horizontal scrolling cards with user feedback and results
class TestimonialCarouselWidget extends StatelessWidget {
  const TestimonialCarouselWidget({super.key});

  final List<Map<String, String>> _testimonials = const [
    {
      'name': 'Chioma A.',
      'result': 'Lost 8kg in 14 weeks',
      'quote':
          'The daily check-ins kept me accountable. I finally reached my goal!',
      'avatar': '👩🏾',
    },
    {
      'name': 'Tunde O.',
      'result': 'Lost 6kg in 12 weeks',
      'quote':
          'Community support made all the difference. Highly recommend NaijaFit!',
      'avatar': '👨🏿',
    },
    {
      'name': 'Amina M.',
      'result': 'Lost 10kg in 16 weeks',
      'quote':
          'Progress photos showed changes I couldn\'t see in the mirror. Amazing!',
      'avatar': '👩🏽',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Success Stories',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF212121),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 22.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _testimonials.length,
            itemBuilder: (context, index) {
              final testimonial = _testimonials[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < _testimonials.length - 1 ? 3.w : 0,
                ),
                child: _buildTestimonialCard(
                  name: testimonial['name']!,
                  result: testimonial['result']!,
                  quote: testimonial['quote']!,
                  avatar: testimonial['avatar']!,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTestimonialCard({
    required String name,
    required String result,
    required String quote,
    required String avatar,
  }) {
    return Container(
      width: 70.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // User info
          Row(
            children: [
              // Avatar
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(avatar, style: TextStyle(fontSize: 6.w)),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    Text(
                      result,
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Quote
          Text(
            '"$quote"',
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF424242),
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 1.h),

          // Rating stars
          Row(
            children: List.generate(
              5,
              (index) =>
                  Icon(Icons.star, color: const Color(0xFFFFC107), size: 4.w),
            ),
          ),
        ],
      ),
    );
  }
}
