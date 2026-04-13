import 'package:flutter/material.dart';
import 'package:naijafit/presentation/ThankyouScreen.dart';

class Saveyourprogressscreen extends StatefulWidget {
  const Saveyourprogressscreen({super.key});

  @override
  State<Saveyourprogressscreen> createState() => _SaveyourprogressscreenState();
}

class _SaveyourprogressscreenState extends State<Saveyourprogressscreen> {
  // Static values — baad mein real data se replace kar lena
  final int todayCalories = 1840;

  static const Color _green      = Color(0xFF1B7F3A);
  static const Color _greenLight = Color(0xFFEAF3DE);

  @override
  Widget build(BuildContext context) {
    final double w  = MediaQuery.of(context).size.width;
    final double h  = MediaQuery.of(context).size.height;
    final double ts = MediaQuery.of(context).textScaleFactor;

    double rf(double fs) {
      final scaled = fs * (w / 375);
      return scaled.clamp(fs * 0.85, fs * 1.20);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.05,
                vertical:   h * 0.018,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width:  w * 0.12,
                      height: w * 0.12,
                      decoration: const BoxDecoration(
                        color: _greenLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: _green,
                        size: w * 0.07,
                      ),
                    ),
                  ),

                  // Logo
                  Image.asset(
                    'assets/images/LOGO.png',
                    width:  w * 0.16,
                    height: w * 0.16,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      width:  w * 0.16,
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
            ),

            // ── Scrollable body ───────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Hero image card ───────────────────────────────
                    Container(
                      width:  double.infinity,
                      height: h * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(w * 0.07),
                        // Gradient background same as image
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end:   Alignment.bottomCenter,
                          colors: [
                            Color(0xFFB2CCBA), // light sage green top
                            Color(0xFF3A5A42), // dark forest green bottom
                          ],
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(w * 0.07),
                        child: Stack(
                          children: [

                            // ── Running woman image ───────────────────
                            Positioned.fill(
                              child: Image.asset(
                                'assets/images/saveprogressimage.png',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const SizedBox(),
                              ),
                            ),

                            // ── Two stat cards at bottom ──────────────
                            Positioned(
                              bottom: h * 0.025,
                              left:   w * 0.04,
                              right:  w * 0.04,
                              child: Row(
                                children: [
                                  // Left card
                                  Expanded(
                                    child: _StatCard(
                                      w: w,
                                      h: h,
                                      ts: ts,
                                      rf: rf,
                                      label: 'Today',
                                      value: '$todayCalories',
                                      unit:  'kcal',
                                    ),
                                  ),
                                  SizedBox(width: w * 0.035),
                                  // Right card
                                  Expanded(
                                    child: _StatCard(
                                      w: w,
                                      h: h,
                                      ts: ts,
                                      rf: rf,
                                      label: 'Today',
                                      value: '$todayCalories',
                                      unit:  'kcal',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.03),

                    // ── Title ─────────────────────────────────────────
                    Text(
                      'Save Your Progress',
                      style: TextStyle(
                        fontSize:   rf(20) / ts,
                        fontWeight: FontWeight.w800,
                        color:      Colors.black87,
                        fontFamily: "bold",
                      ),
                    ),

                    SizedBox(height: h * 0.012),

                    // ── Subtitle ──────────────────────────────────────
                    Text(
                      'Create an account to keep your progress safe and accessible anytime, even if you switch devices.',
                      style: TextStyle(
                        fontSize:   rf(14.5) / ts,
                        color:      Colors.black45,
                        height:     1.55,
                        fontFamily: "regular",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        w * 0.05, w*0.1, w * 0.05, h * 0.035,
                      ),
                      child: SizedBox(
                        width:  double.infinity,
                        height: h * 0.058,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Thankyouscreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _green,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(w * 0.1),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 2),
                          ),
                          child: Text(
                            'Save Progress',
                            style: TextStyle(
                              fontSize:   rf(14) / ts,
                              fontWeight: FontWeight.w700,
                              color:      Colors.white,
                              fontFamily: "extrabold",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Save Progress button — pinned at bottom ───────────────

          ],
        ),
      ),
    );
  }
}

// ── Reusable stat card ────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final double w, h, ts;
  final double Function(double) rf;
  final String label, value, unit;

  const _StatCard({
    required this.w,
    required this.h,
    required this.ts,
    required this.rf,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: h*0.116,
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.04,

      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.06),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset:     const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize:   rf(12) / ts,
              color:      Colors.black54,
              fontWeight: FontWeight.w500,
              fontFamily: "regular",
            ),
          ),
          SizedBox(height: h * 0.004),
          Text(
            value,
            style: TextStyle(
              fontSize:   rf(28) / ts,
              fontWeight: FontWeight.w800,
              color:      Colors.black87,
              height:     1,
              fontFamily: "bold",
            ),
          ),
          SizedBox(height: h * 0.002),
          Text(
            unit,
            style: TextStyle(
              fontSize:   rf(11) / ts,
              fontWeight: FontWeight.w600,
              color:      const Color(0xFF1B7F3A),
              fontFamily: "semibold",
            ),
          ),
        ],
      ),
    );
  }
}