import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:naijafit/core/app_state.dart';
import 'package:naijafit/presentation/main_dashboard_screen/main_dashboard_screen.dart';

class FoodConsumedScreen extends StatelessWidget {
  final String mealName;
  final String mealTime;
  final int consumedCalories;
  final int remainingCalories;
  final double protein;
  final double carbs;
  final double fats;
  final int savedCalories;
  final double savePercent;

  const FoodConsumedScreen({
    super.key,
    this.mealName = 'Jollof Rice',
    this.mealTime = 'Lunch Logged',
    this.consumedCalories = 450,
    this.remainingCalories = 1600,
    this.protein = 22,
    this.carbs = 58,
    this.fats = 14,
    this.savedCalories = 120,
    this.savePercent = 0.20,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;

    final int totalCalories = consumedCalories + remainingCalories;
    final double progressValue = consumedCalories / totalCalories;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.05,
                vertical: h * 0.018,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: w * 0.135,
                      height: w * 0.13,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF3DE),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.chevron_left_rounded,
                          color: const Color(0xFF2E7D32),
                          size: w * 0.075,
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/LOGO.png',
                    width: w * 0.16,
                    height: w * 0.16,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      width: w * 0.16,
                      height: w * 0.16,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B7F3A),
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

            // ── Scrollable Body ──────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Animated Check Icon ──────────────
                    Center(
                      child: Container(
                        width: w * 0.37,
                        height: w * 0.37,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE6F0E2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: w * 0.165,
                            height: w * 0.165,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1B7F3A),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: w * 0.09,
                            ),
                          )
                              .animate()
                              .scale(
                            begin: const Offset(0, 0),
                            end: const Offset(1, 1),
                            duration: 500.ms,
                            curve: Curves.elasticOut,
                          )
                              .fadeIn(duration: 300.ms),
                        ),
                      )
                          .animate()
                          .scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1, 1),
                        delay: 100.ms,
                        duration: 600.ms,
                        curve: Curves.easeOutBack,
                      )
                          .fadeIn(delay: 100.ms, duration: 400.ms),
                    ),

                    SizedBox(height: h * 0.032),

                    // ── Title ────────────────────────────
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: w * 0.07,
                          fontFamily: "medium",
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          height: 1.25,
                        ),
                        children: [
                          const TextSpan(text: 'You Have Consumed '),
                          TextSpan(
                            text: '$consumedCalories',
                            style: const TextStyle(color: Color(0xFF1B7F3A)),
                          ),
                          const TextSpan(text: '\nCalories'),
                        ],
                      ),
                    ),

                    SizedBox(height: h * 0.011),

                    Text(
                      'You have ${_formatNumber(remainingCalories)} calories remaining',
                      style: TextStyle(
                        fontSize: w * 0.038,
                        fontFamily: "regular",
                        color: Colors.black45,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: h * 0.034),

                    // ── Meal Card + Venn Diagram Row ─────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Meal name card
                        Container(
                          width: w * 0.38,
                          height: h * 0.185,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(w * 0.06),
                            border: Border.all(
                                color: Colors.grey.shade200, width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.no_food_rounded,
                                color: const Color(0xFF1B7F3A),
                                size: w * 0.09,
                              ),
                              SizedBox(height: h * 0.010),
                              Text(
                                mealName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: w * 0.058,
                                  fontFamily: "medium",
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: h * 0.006),
                              Text(
                                mealTime,
                                style: TextStyle(
                                  fontSize: w * 0.033,
                                  fontFamily: "regular",
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: w * 0.03),

                        // Venn Diagram Macros
                        Expanded(
                          child: SizedBox(
                            height: h * 0.205,
                            child: _MacroVennDiagram(
                              w: w,
                              h: h,
                              protein: protein,
                              carbs: carbs,
                              fats: fats,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.044),

                    // ── Progress Bar ─────────────────────
                    ClipRRect(
                      borderRadius: BorderRadius.circular(w * 0.05),
                      child: LinearProgressIndicator(
                        value: progressValue.clamp(0.0, 1.0),
                        minHeight: h * 0.016,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF1B7F3A)),
                      ),
                    ),

                    SizedBox(height: h * 0.010),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$savedCalories calorie',
                          style: TextStyle(
                            fontSize: w * 0.035,
                            fontFamily: "regular",
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          '${(savePercent * 100).toStringAsFixed(0)}% Save',
                          style: TextStyle(
                            fontSize: w * 0.038,
                            fontFamily: "regular",
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1B7F3A),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.06),

                    // ── Continue Button ──────────────────
                    Padding(
                      padding:
                      EdgeInsets.fromLTRB(w * 0.05, 0, w * 0.05, h * 0.030),
                      child: SizedBox(
                        width: double.infinity,
                        height: h * 0.058,
                        child: ElevatedButton(
                          onPressed: () async {
                            await AppStateProvider.of(context).setMealLogged();
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MainDashboardScreen(),
                                ),
                                    (Route<dynamic> route) => false,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B7F3A),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(w * 0.08),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: w * 0.036,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontFamily: "extrabold",
                                ),
                              ),
                              SizedBox(width: w * 0.025),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: w * 0.055,
                              ),
                            ],
                          ),
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
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }
}

// ── Venn Diagram Widget ──────────────────────────────────────────────────────

class _MacroVennDiagram extends StatelessWidget {
  final double w;
  final double h;
  final double protein;
  final double carbs;
  final double fats;

  const _MacroVennDiagram({
    required this.w,
    required this.h,
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _VennPainter(),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Carbs (top center) ────────────────────
            Positioned(
              top: h * 0.005,
              left: 0,
              right: 0,
              child: Center(
                child: _macroLabel('Carbs', '${carbs.toStringAsFixed(0)}g', w),
              ),
            ),
            // ── Protein (bottom left) ─────────────────
            Positioned(
              bottom: h * 0.005,
              left: w * 0.02,
              child: _macroLabel(
                  'Protein', '${protein.toStringAsFixed(0)}g', w),
            ),
            // ── Fats (bottom right) ───────────────────
            Positioned(
              bottom: h * 0.005,
              right: w * 0.01,
              child: _macroLabel('Fats', '${fats.toStringAsFixed(0)}g', w),
            ),
          ],
        ),
      ),
    );
  }

  Widget _macroLabel(String name, String value, double w) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: w * 0.038,
            fontFamily: "medium",
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B7F3A),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: w * 0.033,
            fontFamily: "regular",
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class _VennPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1B7F3A).withOpacity(0.13)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = const Color(0xFF1B7F3A).withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final double r = size.width * 0.36;
    final double cx = size.width / 2;
    final double cy = size.height / 2;

    // Offset the three circle centers to form a Venn diagram
    final double offset = r * 0.52;

    // Top circle (Carbs)
    final Offset topCenter = Offset(cx, cy - offset * 0.68);
    // Bottom-left circle (Protein)
    final Offset bottomLeft = Offset(cx - offset * 0.85, cy + offset * 0.52);
    // Bottom-right circle (Fats)
    final Offset bottomRight = Offset(cx + offset * 0.85, cy + offset * 0.52);

    canvas.drawCircle(topCenter, r, paint);
    canvas.drawCircle(bottomLeft, r, paint);
    canvas.drawCircle(bottomRight, r, paint);

    canvas.drawCircle(topCenter, r, strokePaint);
    canvas.drawCircle(bottomLeft, r, strokePaint);
    canvas.drawCircle(bottomRight, r, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
