import 'package:flutter/material.dart';
import 'package:naijafit/presentation/Notification_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;

  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;

  late final Animation<Offset> _imageSlide;
  late final Animation<double> _imageFade;

  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.45),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.00, 0.22, curve: Curves.easeOutCubic),
    ));
    _headerFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.00, 0.20, curve: Curves.easeOut),
    ));

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, -0.30),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.10, 0.34, curve: Curves.easeOutCubic),
    ));
    _titleFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.10, 0.30, curve: Curves.easeOut),
    ));

    _imageSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.26, 0.65, curve: Curves.easeOutCubic),
    ));
    _imageFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.26, 0.60, curve: Curves.easeOut),
    ));

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.66, 1.00, curve: Curves.easeOutCubic),
    ));
    _buttonFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.66, 0.96, curve: Curves.easeOut),
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animatedEntry({
    required Animation<Offset> slide,
    required Animation<double> fade,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.h),

                      // ─── TOP HEADER ROW ───
                      _animatedEntry(
                        slide: _headerSlide,
                        fade: _headerFade,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Profile Avatar (left)
                            CircleAvatar(
                              radius: 22,
                              backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                              backgroundImage: const AssetImage(
                                'assets/images/home2.png',
                              ),
                              onBackgroundImageError: (_, __) {},
                            ),

                            // Center Logo
                            Image.asset(
                              'assets/images/LOGO.png',
                              height: 7.h,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Text(
                                  'NaijaFit',
                                  style: GoogleFonts.inter(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                );
                              },
                            ),

                            // Bell Icon (right)
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationScreen()));
                              },
                              child: Container(
                                width: 13.5.w,
                                height: 13.5.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.notifications_outlined,
                                  color: theme.colorScheme.primary,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 3.5.h),

                      // ─── WELCOME TITLE (LEFT ALIGNED) ───
                      _animatedEntry(
                        slide: _titleSlide,
                        fade: _titleFade,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome to NaijaFit',
                              style: GoogleFonts.inter(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 0.8.h),
                            Text(
                              'Track your favorite Nigerian meals with accurate nutrition data. No more guessing,\nno more generic food databases.',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // ─── FOOD IMAGE (CENTER) ───
                      _animatedEntry(
                        slide: _imageSlide,
                        fade: _imageFade,
                        child: Center(
                          child: SizedBox(
                            width: 85.w,
                            height: 38.h,
                            child: Image.asset(
                              'assets/images/home3.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: theme
                                        .colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.restaurant,
                                      size: 64,
                                      color:
                                      theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // ─── START BUTTON ───
                      _animatedEntry(
                        slide: _buttonSlide,
                        fade: _buttonFade,
                        child: SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamed('/food-logging-screen');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              )
                            ),
                            child: Text(
                              'Start Your Journey',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
