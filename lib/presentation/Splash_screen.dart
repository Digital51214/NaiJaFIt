import 'package:flutter/material.dart';
import 'package:naijafit/presentation/Welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                "assets/images/Splash-Container.png",
                height: m.height * 0.45,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/LOGO.png",
                height: m.height * 0.4,
                width: m.width * 1,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}