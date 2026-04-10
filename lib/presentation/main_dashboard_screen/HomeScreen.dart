// import 'package:flutter/material.dart';
// import 'package:naijafit/presentation/Notification_screen.dart';
// import '../../core/app_export.dart';
//
// class Homescreen extends StatefulWidget {
//   const Homescreen({super.key});
//
//   @override
//   State<Homescreen> createState() => _HomescreenState();
// }
//
// class _HomescreenState extends State<Homescreen>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//
//   late final Animation<Offset> _headerSlide;
//   late final Animation<double> _headerFade;
//
//   late final Animation<Offset> _titleSlide;
//   late final Animation<double> _titleFade;
//
//   late final Animation<Offset> _imageSlide;
//   late final Animation<double> _imageFade;
//
//   late final Animation<Offset> _buttonSlide;
//   late final Animation<double> _buttonFade;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1400),
//     );
//
//     _headerSlide = Tween<Offset>(
//       begin: const Offset(0, -0.45),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.00, 0.22, curve: Curves.easeOutCubic),
//       ),
//     );
//
//     _headerFade = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.00, 0.20, curve: Curves.easeOut),
//       ),
//     );
//
//     _titleSlide = Tween<Offset>(
//       begin: const Offset(0, -0.30),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.10, 0.34, curve: Curves.easeOutCubic),
//       ),
//     );
//
//     _titleFade = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.10, 0.30, curve: Curves.easeOut),
//       ),
//     );
//
//     _imageSlide = Tween<Offset>(
//       begin: const Offset(0, 0.35),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.26, 0.65, curve: Curves.easeOutCubic),
//       ),
//     );
//
//     _imageFade = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.26, 0.60, curve: Curves.easeOut),
//       ),
//     );
//
//     _buttonSlide = Tween<Offset>(
//       begin: const Offset(0, 0.40),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.66, 1.00, curve: Curves.easeOutCubic),
//       ),
//     );
//
//     _buttonFade = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.66, 0.96, curve: Curves.easeOut),
//       ),
//     );
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         _controller.forward();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Widget _animatedEntry({
//     required Animation<Offset> slide,
//     required Animation<double> fade,
//     required Widget child,
//   }) {
//     return FadeTransition(
//       opacity: fade,
//       child: SlideTransition(
//         position: slide,
//         child: child,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     final mediaQuery = MediaQuery.of(context);
//     final size = mediaQuery.size;
//     final width = size.width;
//     final height = size.height;
//     final textScale = mediaQuery.textScaleFactor;
//
//     double responsiveFont(double fontSize) {
//       double scale = width / 375;
//       double responsiveSize = fontSize * scale;
//       return responsiveSize.clamp(fontSize * 0.85, fontSize * 1.20);
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: width * 0.05),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: height * 0.04),
//
//                       // ─── TOP HEADER ROW ───
//                       _animatedEntry(
//                         slide: _headerSlide,
//                         fade: _headerFade,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // Profile Avatar (left)
//                             CircleAvatar(
//                               radius: width * 0.058,
//                               backgroundColor:
//                               theme.colorScheme.surfaceContainerHighest,
//                               backgroundImage: const AssetImage(
//                                 'assets/images/home2.png',
//                               ),
//                               onBackgroundImageError: (_, __) {},
//                             ),
//
//                             // Center Logo
//                             Image.asset(
//                               'assets/images/LOGO.png',
//                               height: height * 0.07,
//                               fit: BoxFit.contain,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return Text(
//                                   'NaijaFit',
//                                   style: TextStyle(
//                                     fontFamily: "bold",
//                                     fontSize:
//                                     responsiveFont(18) / textScale,
//                                     fontWeight: FontWeight.bold,
//                                     color: theme.colorScheme.primary,
//                                   ),
//                                 );
//                               },
//                             ),
//
//                             // Bell Icon (right)
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         NotificationScreen(),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 width: width * 0.135,
//                                 height: width * 0.135,
//                                 decoration: const BoxDecoration(
//                                   color: Color(0xFFE8F5E9),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Icon(
//                                   Icons.notifications,
//                                   color: const Color(0xFF026F1A),
//                                   size: width * 0.058,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       SizedBox(height: height * 0.040),
//
//                       // ─── WELCOME TITLE (LEFT ALIGNED) ───
//                       _animatedEntry(
//                         slide: _titleSlide,
//                         fade: _titleFade,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Welcome to NaijaFit',
//                               style: TextStyle(
//                                 fontFamily: "semibold",
//                                 fontSize: responsiveFont(19) / textScale,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             SizedBox(height: height * 0.008),
//                             Text(
//                               'Track your favorite Nigerian meals with accurate nutrition data. No more guessing,\nno more generic food databases.',
//                               style: TextStyle(
//                                 fontFamily: "regular",
//                                 fontSize: responsiveFont(14) / textScale,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.black54,
//                                 height: 1.5,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       SizedBox(height: height * 0.02),
//
//                       // ─── FOOD IMAGE (CENTER) ───
//                       _animatedEntry(
//                         slide: _imageSlide,
//                         fade: _imageFade,
//                         child: Center(
//                           child: SizedBox(
//                             width: width * 0.85,
//                             height: height * 0.38,
//                             child: Image.asset(
//                               'assets/images/home3.png',
//                               fit: BoxFit.contain,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return Container(
//                                   decoration: BoxDecoration(
//                                     color:
//                                     theme.colorScheme.surfaceContainerHighest,
//                                     borderRadius: BorderRadius.circular(
//                                       width * 0.04,
//                                     ),
//                                   ),
//                                   child: Center(
//                                     child: Icon(
//                                       Icons.restaurant,
//                                       size: width * 0.16,
//                                       color:
//                                       theme.colorScheme.onSurfaceVariant,
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       SizedBox(height: height * 0.03),
//
//                       // ─── START BUTTON ───
//                       _animatedEntry(
//                         slide: _buttonSlide,
//                         fade: _buttonFade,
//                         child: SizedBox(
//                           width: double.infinity,
//                           height: height * 0.058,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.of(context, rootNavigator: true)
//                                   .pushNamed('/food-logging-screen');
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF026F1A),
//                               foregroundColor: Colors.white,
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                 BorderRadius.circular(width * 0.08),
//                               ),
//                               padding: EdgeInsets.symmetric(
//                                 vertical: height * 0.015,
//                                 horizontal: width * 0.04,
//                               ),
//                             ),
//                             child: Text(
//                               'Start Your Journey',
//                               style: TextStyle(
//                                 fontFamily: "bold",
//                                 fontSize: responsiveFont(11.5) / textScale,
//                                 fontWeight: FontWeight.w600,
//                                 letterSpacing: 0.3,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       SizedBox(height: height * 0.03),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }











import 'package:flutter/material.dart';
import 'package:naijafit/presentation/Notification_screen.dart';
import 'package:naijafit/presentation/SelectMealScreen.dart';
import 'package:naijafit/presentation/emptyscreen.dart';
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

  late final Animation<Offset> _contentSlide;
  late final Animation<double> _contentFade;

  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;

  // Temporary static dashboard values
  final int _dailyCalorieTarget = 2000;
  final int _caloriesConsumed = 0;
  final int _mealsLogged = 0;

  int get _remainingCalories => _dailyCalorieTarget - _caloriesConsumed;

  // Progress ratio for circular indicator (0.0 to 1.0)
  double get _progressRatio =>
      _dailyCalorieTarget == 0 ? 0 : _caloriesConsumed / _dailyCalorieTarget;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.28, curve: Curves.easeOutCubic),
      ),
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.25, curve: Curves.easeOut),
      ),
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 0.68, curve: Curves.easeOutCubic),
      ),
    );

    _contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 0.62, curve: Curves.easeOut),
      ),
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.58, 1.00, curve: Curves.easeOutCubic),
      ),
    );

    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.58, 0.95, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
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
      child: SlideTransition(
        position: slide,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final width = size.width;
    final height = size.height;
    final textScale = mediaQuery.textScaleFactor;

    double responsiveFont(double fontSize) {
      double scale = width / 375;
      double responsiveSize = fontSize * scale;
      return responsiveSize.clamp(fontSize * 0.85, fontSize * 1.20);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            children: [
              SizedBox(height: height * 0.02),

              // ── Header ──────────────────────────────────────────────
              _animatedEntry(
                slide: _headerSlide,
                fade: _headerFade,
                child: Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: width * 0.075,
                      backgroundColor:
                      theme.colorScheme.surfaceContainerHighest,
                      backgroundImage:
                      const AssetImage('assets/images/home2.png'),
                      onBackgroundImageError: (_, __) {},
                    ),
                    SizedBox(width: width * 0.04),

                    // Greeting text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning!',
                            style: TextStyle(
                              fontFamily: "bold",
                              fontSize: responsiveFont(20) / textScale,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Let's stay on your track today",
                            style: TextStyle(
                              fontFamily: "regular",
                              fontSize: responsiveFont(13) / textScale,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Notification bell
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: width * 0.135,
                        height: width * 0.135,
                        decoration: const BoxDecoration(
                          color: Color(0xFFDCEFDC),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications,
                          color: const Color(0xFF026F1A),
                          size: width * 0.058,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.03),

              // ── Scrollable content ───────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: _animatedEntry(
                    slide: _contentSlide,
                    fade: _contentFade,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Calorie ring card ──────────────────────────
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.06,
                            vertical: height * 0.04,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(width * 0.07),
                          ),
                          child: Column(
                            children: [
                              // Circular progress ring
                              SizedBox(
                                width: width * 0.52,
                                height: width * 0.52,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Background track
                                    SizedBox(
                                      width: width * 0.52,
                                      height: width * 0.52,
                                      child: CircularProgressIndicator(
                                        value: 1.0,
                                        strokeWidth: width * 0.025,
                                        backgroundColor: Colors.transparent,
                                        color: const Color(0xFF026F1A)
                                            .withOpacity(0.15),
                                        strokeCap: StrokeCap.round,
                                      ),
                                    ),
                                    // Foreground progress
                                    SizedBox(
                                      width: width * 0.52,
                                      height: width * 0.52,
                                      child: CircularProgressIndicator(
                                        value: _progressRatio,
                                        strokeWidth: width * 0.025,
                                        backgroundColor: Colors.transparent,
                                        color: const Color(0xFF026F1A),
                                        strokeCap: StrokeCap.round,
                                      ),
                                    ),
                                    // Center label
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '$_caloriesConsumed',
                                          style: TextStyle(
                                            fontFamily: "bold",
                                            fontSize:
                                            responsiveFont(42) / textScale,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black87,
                                            height: 1.1,
                                          ),
                                        ),
                                        Text(
                                          'KCAL USED',
                                          style: TextStyle(
                                            fontFamily: "regular",
                                            fontSize:
                                            responsiveFont(12) / textScale,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black45,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: height * 0.025),

                              // Remaining label
                              Text(
                                'Remaining Calories',
                                style: TextStyle(
                                  fontFamily: "regular",
                                  fontSize: responsiveFont(14) / textScale,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: height * 0.006),
                              Text(
                                '$_remainingCalories kcal',
                                style: TextStyle(
                                  fontFamily: "bold",
                                  fontSize: responsiveFont(28) / textScale,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF026F1A),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: height * 0.024),

                        // ── Meals Logged row card ───────────────────────
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Emptyscreen()));
                          },
                          child: Container(
                            height: 67,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.045,
                              vertical: height * 0.022,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(width * 0.08),
                              border: Border.all(
                                color: const Color(0xFFE8E8E8),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Icon bubble
                                Container(
                                  width: width * 0.12,
                                  height: width * 0.12,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDCEFDC),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.restaurant_menu_outlined,
                                    color: const Color(0xFF026F1A),
                                    size: width * 0.055,
                                  ),
                                ),
                                SizedBox(width: width * 0.04),
                                Expanded(
                                  child: Text(
                                    'Meals Logged',
                                    style: TextStyle(
                                      fontFamily: "semibold",
                                      fontSize:
                                      responsiveFont(15) / textScale,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.black38,
                                  size: width * 0.06,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.03),

                        // ── Add Meal button ────────────────────────────
                        _animatedEntry(
                          slide: _buttonSlide,
                          fade: _buttonFade,
                          child: SizedBox(
                            width: double.infinity,
                            height: height * 0.058,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Selectmealscreen()));
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: width * 0.055,
                              ),
                              label: Text(
                                'Add Meal',
                                style: TextStyle(
                                  fontFamily: "bold",
                                  fontSize: responsiveFont(14) / textScale,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF026F1A),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(width * 0.1),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 2)
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.04),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}