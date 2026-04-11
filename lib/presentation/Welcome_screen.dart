// import 'package:flutter/material.dart';
// import 'package:naijafit/presentation/sign_in_screen/sign_in_screen.dart';
//
// class WelcomeScreen extends StatefulWidget {
//   const WelcomeScreen({super.key});
//
//   @override
//   State<WelcomeScreen> createState() => _WelcomeScreenState();
// }
//
// class _WelcomeScreenState extends State<WelcomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F3F3),
//       body: SafeArea(
//         child: SizedBox(
//           height: size.height,
//           width: size.width,
//           child: Stack(
//             children: [
//               /// Main content
//               Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 80),
//
//                         /// Heading + right circles
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Eat Smart.\nTrack Calories.\nStay Fit.',
//                               style: TextStyle(
//                                 fontSize: 30,
//                                 fontWeight: FontWeight.w700,
//                                 fontFamily: "medium",
//                                 color: Colors.black,
//                                 height: 1.4,
//                               ),
//                             ),
//                             SizedBox(width: size.width * 0.05),
//                             Image(
//                               image: AssetImage("assets/images/circle.png"),
//                               height: 75,
//                               width: 48,
//                             ),
//                           ],
//                         ),
//
//                         const SizedBox(height: 16),
//
//                         /// Subtitle
//                         SizedBox(
//                           width: size.width * 0.82,
//                           child: Text(
//                             'Track your favorite Nigerian meals\nand stay on top of your daily calories',
//                             style: TextStyle(
//                               fontSize: 15.2,
//                               fontFamily: "extralight",
//                               color: Colors.black,
//                               height: 1.35,
//                             ),
//                           ),
//                         ),
//
//                         const SizedBox(height: 24),
//
//                         /// Circular Button
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => SignInScreen(),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             height: 51,
//                             width: 51,
//                             decoration: BoxDecoration(
//                               color: Colors.transparent,
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 width: 1,
//                                 color: Color(0xFF026F1A),
//                               ),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(2.0),
//                               child: Container(
//                                 width: 49,
//                                 height: 49,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: const Color(0xFF026F1A),
//                                 ),
//                                 child: const Center(
//                                   child: Icon(
//                                     Icons.arrow_forward,
//                                     color: Colors.white,
//                                     size: 28,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Spacer(),
//                   Image(
//                     image: AssetImage("assets/images/splashscreenimage.png"),
//                     width: double.infinity,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:naijafit/presentation/LoadingScreen.dart';
import 'package:naijafit/presentation/Onboarding_screen.dart';
import 'package:naijafit/presentation/main_dashboard_screen/main_dashboard_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double _dragPosition = 0.0;
  final double _outerWidth = 150.0;
  final double _innerWidth = 110.0;
  bool _isNavigating = false;

  double get _maxDrag => _outerWidth - _innerWidth - 5;

  void _goToOnboarding() {
    if (_isNavigating) return;
    _isNavigating = true;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainDashboardScreen()),
    ).then((_) {
      setState(() {
        _dragPosition = 0.0;
        _isNavigating = false;
      });
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition = (_dragPosition + details.delta.dx).clamp(0.0, _maxDrag);
    });
    if (_dragPosition >= _maxDrag - 1) {
      _goToOnboarding();
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_isNavigating) {
      setState(() {
        _dragPosition = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDragging = _dragPosition > 2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),

                  // Headline + Circle graphic
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Text(
                          'Eat Smart.\nTrack Calories.\nStay Fit.',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            height: 1.25,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        height: 90,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 10,
                              child: Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF026F1A),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 30,
                              left: 10,
                              child: Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF026F1A),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Track your favorite Nigerian meals\nand stay on top of your daily calories',
                    style: TextStyle(
                      fontSize: 15.5,
                      color: Color(0xFF444444),
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── Swipe Button ──
                  GestureDetector(
                    onHorizontalDragUpdate: _onDragUpdate,
                    onHorizontalDragEnd: _onDragEnd,
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: const Color(0xFF026F1A),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Green pill — moves with drag
                          Transform.translate(
                            offset: Offset(_dragPosition, 0),
                            child: Container(
                              height: 38,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF026F1A),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Center(
                                child: Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),

                          // 3 chevrons overlapped using Stack — zero spacing
                          AnimatedOpacity(
                            opacity: isDragging ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 150),
                            child: SizedBox(
                              width: 40, // fixed width — no overflow
                              height: 48,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                    left: 0,
                                    child: Icon(
                                      Icons.chevron_right,
                                      color: const Color(0xFF026F1A),
                                      size: 18, // smallest
                                    ),
                                  ),
                                  Positioned(
                                    left: 6,
                                    child: Icon(
                                      Icons.chevron_right,
                                      color: const Color(0xFF026F1A),
                                      size: 22, // medium
                                    ),
                                  ),
                                  Positioned(
                                    left: 12,
                                    child: Icon(
                                      Icons.chevron_right,
                                      color: const Color(0xFF026F1A),
                                      size: 26, // largest
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
                ],
              ),
            ),

            const Spacer(),
            Image.asset(
              "assets/images/splashscreenimage.png",
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }
}