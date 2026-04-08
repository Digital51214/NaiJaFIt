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
import 'package:naijafit/presentation/sign_in_screen/sign_in_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void _goToOnboarding() {
    // TODO: Replace SignInScreen with your first onboarding screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Eat Smart.\nTrack Calories.\nStay Fit.',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            fontFamily: "medium",
                            color: Colors.black,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(width: size.width * 0.05),
                        const Image(
                          image: AssetImage("assets/images/circle.png"),
                          height: 75,
                          width: 48,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: size.width * 0.82,
                      child: Text(
                        'Track your favorite Nigerian meals\nand stay on top of your daily calories',
                        style: TextStyle(
                          fontSize: 15.2,
                          fontFamily: "extralight",
                          color: Colors.black,
                          height: 1.35,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: _goToOnboarding,
                        child: Container(
                          height: 51,
                          width: 51,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1,
                              color: const Color(0xFF026F1A),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              width: 49,
                              height: 49,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF026F1A),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: _goToOnboarding,
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF026F1A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Image(
                image: AssetImage("assets/images/splashscreenimage.png"),
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}