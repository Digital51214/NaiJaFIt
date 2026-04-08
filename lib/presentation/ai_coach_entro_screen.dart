// import 'package:flutter/material.dart';
// import 'package:naijafit/presentation/ai_nutrition_insights_screen/ai_nutrition_insights_screen.dart';
// import 'package:sizer/sizer.dart';
//
// class AiCoachIntroScreen extends StatefulWidget {
//   const AiCoachIntroScreen({super.key});
//
//   @override
//   State<AiCoachIntroScreen> createState() => _AiCoachIntroScreenState();
// }
//
// class _AiCoachIntroScreenState extends State<AiCoachIntroScreen>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//
//   late final Animation<Offset> _logoSlide;
//   late final Animation<double> _logoFade;
//
//   late final Animation<double> _imageScale;
//   late final Animation<double> _imageFade;
//
//   late final Animation<Offset> _textSlide;
//   late final Animation<double> _textFade;
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
//       duration: const Duration(milliseconds: 1200),
//     );
//
//     _logoSlide = Tween<Offset>(
//       begin: const Offset(0, -0.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.00, 0.30, curve: Curves.easeOutCubic),
//     ));
//     _logoFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.00, 0.30, curve: Curves.easeOut),
//     ));
//
//     _imageScale = Tween<double>(begin: 0.7, end: 1.0).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.10, 0.60, curve: Curves.easeOutBack),
//     ));
//     _imageFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.10, 0.55, curve: Curves.easeOut),
//     ));
//
//     _textSlide = Tween<Offset>(
//       begin: const Offset(0, 0.4),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.40, 0.80, curve: Curves.easeOutCubic),
//     ));
//     _textFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.40, 0.75, curve: Curves.easeOut),
//     ));
//
//     _buttonSlide = Tween<Offset>(
//       begin: const Offset(0, 0.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.65, 1.00, curve: Curves.easeOutCubic),
//     ));
//     _buttonFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.65, 1.00, curve: Curves.easeOut),
//     ));
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) _controller.forward();
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _onSayHello() {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) =>
//         const AiNutritionChatScreen(autoStartChat: true),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           final slide = Tween<Offset>(
//             begin: const Offset(1.0, 0),
//             end: Offset.zero,
//           ).animate(CurvedAnimation(
//             parent: animation,
//             curve: Curves.easeOutCubic,
//           ));
//           return SlideTransition(position: slide, child: child);
//         },
//         transitionDuration: const Duration(milliseconds: 400),
//       ),
//     );
//   }
//
//   Widget _animatedEntry({
//     required Animation<Offset> slide,
//     required Animation<double> fade,
//     required Widget child,
//   }) {
//     return FadeTransition(
//       opacity: fade,
//       child: SlideTransition(position: slide, child: child),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   FadeTransition(
//                     opacity: _logoFade,
//                     child: SlideTransition(
//                       position: _logoSlide,
//                       child: Image.asset(
//                         'assets/images/LOGO.png',
//                         width: 60,
//                         height: 60,
//                         errorBuilder: (_, __, ___) => Container(
//                           width: 50,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: theme.colorScheme.primary.withValues(alpha: 0.1),
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             Expanded(
//               child: FadeTransition(
//                 opacity: _imageFade,
//                 child: ScaleTransition(
//                   scale: _imageScale,
//                   child: Center(
//                     child: Image.asset(
//                       'assets/images/aiimge.png',
//                       width: 90.w,
//                       fit: BoxFit.contain,
//                       errorBuilder: (_, __, ___) => Container(
//                         width: 75.w,
//                         height: 40.h,
//                         decoration: BoxDecoration(
//                           color: theme.colorScheme.primary.withValues(alpha: 0.08),
//                           borderRadius: BorderRadius.circular(24),
//                         ),
//                         child: Icon(
//                           Icons.smart_toy_outlined,
//                           size: 80,
//                           color: theme.colorScheme.primary.withValues(alpha: 0.4),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             _animatedEntry(
//               slide: _textSlide,
//               fade: _textFade,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 6.w),
//                 child: Column(
//                   children: [
//                     Text(
//                       'AI Nutrition Coach',
//                       style: theme.textTheme.headlineSmall?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: theme.colorScheme.onSurface,
//                         fontFamily: "semibold",
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 1.5.h),
//                     Text(
//                       'Say hello to your AI Nutrition Coach for\nadditional insights on your favourite Nigerian\ncuisines and meals',
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
//                         height: 1.5,
//                         fontSize: 11.sp,
//                         fontFamily: "regular",
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 4.h),
//
//             _animatedEntry(
//               slide: _buttonSlide,
//               fade: _buttonFade,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 6.w),
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 5.8.h,
//                   child: ElevatedButton(
//                     onPressed: _onSayHello,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF026F1A),
//                       foregroundColor: theme.colorScheme.onPrimary,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(32),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 2),
//                       elevation: 0,
//                     ),
//                     child: Text(
//                       'Say Hello!',
//                       style: theme.textTheme.titleMedium?.copyWith(
//                         color: theme.colorScheme.onPrimary,
//                         fontSize: 12,
//                         fontFamily: "bold",
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 4.h),
//           ],
//         ),
//       ),
//     );
//   }
// }











import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AiCoachIntroScreen extends StatefulWidget {
  const AiCoachIntroScreen({super.key});

  @override
  State<AiCoachIntroScreen> createState() => _AiCoachIntroScreenState();
}

class _AiCoachIntroScreenState extends State<AiCoachIntroScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<Offset> _logoSlide;
  late final Animation<double> _logoFade;

  late final Animation<double> _imageScale;
  late final Animation<double> _imageFade;

  late final Animation<Offset> _textSlide;
  late final Animation<double> _textFade;

  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoSlide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.30, curve: Curves.easeOutCubic),
      ),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.30, curve: Curves.easeOut),
      ),
    );

    _imageScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.10, 0.60, curve: Curves.easeOutBack),
      ),
    );

    _imageFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.10, 0.55, curve: Curves.easeOut),
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.80, curve: Curves.easeOutCubic),
      ),
    );

    _textFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.75, curve: Curves.easeOut),
      ),
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.65, 1.00, curve: Curves.easeOutCubic),
      ),
    );

    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.65, 1.00, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onUnlockAiCoach() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 3.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12.w,
                  height: 0.6.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(height: 2.h),
                Container(
                  width: 18.w,
                  height: 18.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F4EA),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    size: 34,
                    color: Color(0xFF026F1A),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'AI Nutrition Coach is a premium feature',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: "bold",
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Unlock the full features of NaijaFit to chat with your AI Nutrition Coach and get additional insights on your favourite Nigerian meals.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: "regular",
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.68),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 2.5.h),
                SizedBox(
                  width: double.infinity,
                  height: 5.8.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      // TODO: Replace with your actual paywall / Plan Screen 1 route
                      // Navigator.pushNamed(context, AppRoutes.planScreenOne);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Redirect user to Plan Screen 1 / Paywall',
                            style: TextStyle(fontFamily: "semibold"),
                          ),
                          backgroundColor: const Color(0xFF026F1A),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF026F1A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 2),
                      elevation: 0,
                    ),
                    child: Text(
                      'Unlock Premium',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: "bold",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Maybe later',
                    style: TextStyle(
                      fontFamily: "medium",
                      fontSize: 11.sp,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FadeTransition(
                    opacity: _logoFade,
                    child: SlideTransition(
                      position: _logoSlide,
                      child: Image.asset(
                        'assets/images/LOGO.png',
                        width: 60,
                        height: 60,
                        errorBuilder: (_, __, ___) => Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: FadeTransition(
                opacity: _imageFade,
                child: ScaleTransition(
                  scale: _imageScale,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/aiimge.png',
                          width: 90.w,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            width: 75.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Icon(
                              Icons.smart_toy_outlined,
                              size: 80,
                              color: theme.colorScheme.primary.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2.h,
                          right: 10.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.5.w,
                              vertical: 0.8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.lock_outline,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 1.5.w),
                                Text(
                                  'Premium',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontFamily: "bold",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            _animatedEntry(
              slide: _textSlide,
              fade: _textFade,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  children: [
                    Text(
                      'AI Nutrition Coach',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                        fontFamily: "semibold",
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 1.5.h),
                    Text(
                      'Unlock your AI Nutrition Coach for additional insights on your favourite Nigerian cuisines and meals.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        height: 1.5,
                        fontSize: 11.sp,
                        fontFamily: "regular",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 4.h),

            _animatedEntry(
              slide: _buttonSlide,
              fade: _buttonFade,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 5.8.h,
                  child: ElevatedButton(
                    onPressed: _onUnlockAiCoach,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF026F1A),
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      elevation: 0,
                    ),
                    child: Text(
                      'Unlock AI Coach',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 12,
                        fontFamily: "bold",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}