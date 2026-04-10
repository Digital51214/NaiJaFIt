import 'package:flutter/material.dart';
import 'package:naijafit/presentation/Nagarionsays_screen.dart';
import 'dart:async';
import 'package:naijafit/presentation/sign_in_screen/sign_in_screen.dart';

class Loadingscreen extends StatefulWidget {
  const Loadingscreen({super.key});

  @override
  State<Loadingscreen> createState() => _LoadingscreenState();
}

class _LoadingscreenState extends State<Loadingscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  List<int> _stepStatus = [1, 2, 2];

  @override
  void initState() {
    super.initState();

    // Infinite rotating animation
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // 2s: step 0 done, step 1 active
    Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _stepStatus = [0, 1, 2]);
    });

    // 4s: step 1 done, step 2 active
    Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _stepStatus = [0, 0, 1]);
    });

    // 6s: all done → navigate to SignInScreen
    Timer(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() => _stepStatus = [0, 0, 0]);
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => WhatNigeriansAreSayingScreen()),
                  (Route<dynamic> route) => false,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  Widget _buildStepTile(String label, int status) {
    final bool isDone = status == 0;
    final bool isActive = status == 1;
    final bool isInactive = status == 2;

    Widget leading;
    if (isDone) {
      leading = Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF026F1A), width: 2),
        ),
        child: const Icon(Icons.check, color: Color(0xFF026F1A), size: 16),
      );
    } else if (isActive) {
      leading = Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF026F1A),
        ),
      );
    } else {
      leading = Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFBDD9C0),
        ),
      );
    }

    return Container(
      height: 51,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isInactive ? FontWeight.w400 : FontWeight.w700,
                color: isInactive ? const Color(0xFFAAAAAA) : Colors.black,
                fontFamily: "regular",
              ),
            ),
          ),
          Text(
            isDone ? 'Done' : isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: "regular",
              color: isInactive
                  ? const Color(0xFFAAAAAA)
                  : const Color(0xFF026F1A),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.03),

              // ── Top Row: Title + Logo ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Creating Your Plan',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "bold",
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  Image.asset(
                    'assets/images/LOGO.png',
                    width: size.width * 0.15,
                    height: size.width * 0.15,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

              SizedBox(height: size.height * 0.05),

              // ── Spinning Border + Lightning Icon ──
              Center(
                child: SizedBox(
                  width: size.width * 0.45,
                  height: size.width * 0.45,
                  child: AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Grey full circle track
                          SizedBox(
                            width: size.width * 0.5,
                            height: size.width * 0.5,
                            child: const CircularProgressIndicator(
                              value: 1.0,
                              strokeWidth: 8,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFDDDDDD)),
                            ),
                          ),

                          // Rotating green arc — spins continuously
                          Transform.rotate(
                            angle: _progressController.value * 2 * 3.14159,
                            child: SizedBox(
                              width: size.width * 0.5,
                              height: size.width * 0.5,
                              child: const CircularProgressIndicator(
                                value: 0.25, // arc length ~quarter circle
                                strokeWidth: 8,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF026F1A)),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                          ),

                          // Light green filled circle with bolt icon
                          Container(
                            width: size.width * 0.42,
                            height: size.width * 0.42,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFDCEFDC),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.bolt,
                                color: const Color(0xFF026F1A),
                                size: size.width * 0.18,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.06),

              // ── Step Tiles ──
              _buildStepTile('Calculating Calories', _stepStatus[0]),
              _buildStepTile('Analyzing protein needs..', _stepStatus[1]),
              _buildStepTile('Setting your goals', _stepStatus[2]),

              SizedBox(height: size.height * 0.025),

              // ── Info Card ──
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(size.width * 0.05),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4EA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Naija Fit- Nutration',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "semibold",
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF026F1A),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Updating your plan to include high protein and pounded yam metrics.No compromise on taste.',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: "regular",
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}