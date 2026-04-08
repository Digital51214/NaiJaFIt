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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO
              Image.asset(
                "assets/images/LOGO.png",
                height: m.height * 0.25,
                fit: BoxFit.contain,
              ),

              SizedBox(height: m.height * 0.04),

              // MAIN TEXT (Client requirement)
              Text(
                "Calorie tracking of Nigerian meals made easy",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),

              SizedBox(height: m.height * 0.06),

              // GET STARTED BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF026F1A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: m.height * 0.02),

              // SIGN IN TEXT
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to Login Screen
                },
                child: const Text(
                  "Already have an account? Sign In",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
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