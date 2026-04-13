import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:naijafit/presentation/main_dashboard_screen/main_dashboard_screen.dart';
import 'package:naijafit/widgets/Backbutton.dart';

class Thankyouscreen extends StatefulWidget {
  const Thankyouscreen({super.key});

  @override
  State<Thankyouscreen> createState() => _ThankyouscreenState();
}

class _ThankyouscreenState extends State<Thankyouscreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotateController;

  static const Color _green = Color(0xFF1B7F3A);
  static const Color _greenLight = Color(0xFFE6F0E2);

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    final double ts = MediaQuery.of(context).textScaleFactor;
    final size = MediaQuery.of(context).size;

    double rf(double fs) {
      final scaled = fs * (w / 375);
      return scaled.clamp(fs * 0.85, fs * 1.20);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.05,
            vertical: h * 0.018,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: CustomBackButton(),
                  ),
                  Image.asset(
                    'assets/images/LOGO.png',
                    width: h * 0.08,
                    height: w * 0.16,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      width: w * 0.16,
                      height: w * 0.16,
                      decoration: BoxDecoration(
                        color: _green,
                        borderRadius: BorderRadius.circular(w * 0.04),
                      ),
                      child: Icon(
                        Icons.restaurant_menu_rounded,
                        color: Colors.white,
                        size: w * 0.08,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: h*0.03,),
              SizedBox(
                width: 185,
                height: 185,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // ── Shadow layer (alag container) ──────────────
                    Container(
                      width: 185,
                      height: 185,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            spreadRadius: 5,
                            offset: const Offset(0, 0),
                            color: Colors.green.withOpacity(0.6),
                          ),
                        ],
                      ),
                    ),

                    // ── Radial glow (alag container) ───────────────
                    Container(
                      width: 185,
                      height: 185,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            _green.withOpacity(0.18),
                            _green.withOpacity(0.07),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),

                    // ── Middle solid light-green ring ───────────────
                    Container(
                      width: 185,
                      height: 185,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.6),
                      ),
                    ),

                    // ── White inner circle with dots + hand ─────────
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Rotating dots ring
                          RotationTransition(
                            turns: _rotateController,
                            child: SizedBox(
                              width: w * 0.46,
                              height: w * 0.46,
                              child: CustomPaint(
                                painter: _DotRingPainter(
                                  dotCount: 24,
                                  dotRadius: w * 0.008,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),

                          // Hand icon with bounce animation
                          Icon(
                            Icons.back_hand_rounded,
                            color: _green,
                            size: w * 0.30,
                          )
                              .animate()
                              .scale(
                            begin: const Offset(0.4, 0.4),
                            end: const Offset(1, 1),
                            duration: 700.ms,
                            curve: Curves.elasticOut,
                          )
                              .fadeIn(duration: 400.ms),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 600.ms,
                curve: Curves.easeOutBack,
              ),
              SizedBox(height: h * 0.06),

              // ── Title ─────────────────────────────────────────
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: rf(21) / ts,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    height: 1.35,
                    fontFamily: "semibold",
                  ),
                  children: const [
                    TextSpan(
                      text: 'Thank You For Trusting Us –\nNow Let\'s Personalize ',
                    ),
                    TextSpan(
                      text: 'NaijaFit',
                      style: TextStyle(color: Color(0xFF1B7F3A)),
                    ),
                    TextSpan(text: '\nFor You'),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 500.ms)
                  .slideY(
                begin: 0.2,
                end: 0,
                delay: 300.ms,
                duration: 500.ms,
                curve: Curves.easeOut,
              ),

              SizedBox(height: h * 0.04),

              // ── Privacy card ──────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.045,
                  vertical: h * 0.025,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(w * 0.06),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.verified_user_rounded,
                      color: _green,
                      size: w * 0.075,
                    ),
                    SizedBox(width: w * 0.04),
                    Expanded(
                      child: Text(
                        'Your data is secure and private.\nWe never share your information.',
                        style: TextStyle(
                          fontSize: rf(14) / ts,
                          color: Colors.black45,
                          height: 1.5,
                          fontFamily: "regular",
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 500.ms)
                  .slideY(
                begin: 0.2,
                end: 0,
                delay: 500.ms,
                duration: 500.ms,
                curve: Curves.easeOut,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(w * 0.05, w*0.1, w * 0.05, h * 0.03),
                child: SizedBox(
                  width: double.infinity,
                  height: h * 0.058,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MainDashboardScreen()),
                              (Route<dynamic>route)=>false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(w * 0.1),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 2)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: rf(14) / ts,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: "extrabold",
                          ),
                        ),
                        SizedBox(width: w * 0.03),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: w * 0.055,
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 700.ms, duration: 500.ms)
                  .slideY(
                begin: 0.3,
                end: 0,
                delay: 700.ms,
                duration: 500.ms,
                curve: Curves.easeOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Dot ring painter ──────────────────────────────────────────────────────
class _DotRingPainter extends CustomPainter {
  final int dotCount;
  final double dotRadius;
  final Color color;

  const _DotRingPainter({
    required this.dotCount,
    required this.dotRadius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final center = Offset(size.width / 2, size.height / 2);
    final ringRadius = size.width / 2;

    for (int i = 0; i < dotCount; i++) {
      final angle = (2 * math.pi * i) / dotCount;
      final x = center.dx + ringRadius * 0.88 * math.cos(angle);
      final y = center.dy + ringRadius * 0.88 * math.sin(angle);
      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}