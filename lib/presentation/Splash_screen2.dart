// import 'package:flutter/material.dart';
// import 'package:naijafit/presentation/Welcome_screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateToHome();
//   }
//
//   Future<void> _navigateToHome() async {
//     await Future.delayed(const Duration(seconds: 4));
//     if (!mounted) return;
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const WelcomeScreen()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final m = MediaQuery.of(context).size;
//
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Center(
//               child: Image.asset(
//                 "assets/images/Splash-Container.png",
//                 height: m.height * 0.45,
//                 width: double.infinity,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             Align(
//               alignment: Alignment.center,
//               child: Image.asset(
//                 "assets/images/LOGO.png",
//                 height: m.height * 0.4,
//                 width: m.width * 1,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }












import 'package:flutter/material.dart';
import 'package:naijafit/presentation/Welcome_screen.dart';
import 'package:naijafit/presentation/sign_in_screen/sign_in_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: m.width * 0.08),
          child: Column(
            children: [
              SizedBox(height: m.height * 0.10),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/LOGO.png",
                      height: m.height * 0.32,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Calorie tracking of Nigerian meals\nmade easy",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: "extralight",
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WelcomeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF026F1A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: "bold",
                    ),
                  ),
                ),
              ),

              SizedBox(height: m.height * 0.05),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontFamily: "regular",
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: m.width * 0.02),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignInScreen(),
                        ),
                            (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontFamily: "regular",
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: Color(0xFF026F1A),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: m.height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}