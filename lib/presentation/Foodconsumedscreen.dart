import 'package:flutter/material.dart';
import 'package:naijafit/presentation/main_dashboard_screen/main_dashboard_screen.dart';

class FoodConsumedScreen extends StatelessWidget {
  final String mealName;
  final String mealTime;
  final int consumedCalories;
  final int remainingCalories;
  final double protein;
  final double carbs;
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
    this.savedCalories = 120,
    this.savePercent = 0.20,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;

    // Progress: how much consumed out of total daily
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
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: w * 0.135,
                      height: w * 0.135,
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

                  // Logo
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

                    // ── Big Circle with Check ────────────
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
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.032),

                    // ── Title: You Have Consumed X Calories ──
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: w * 0.075,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          height: 1.25,
                        ),
                        children: [
                          const TextSpan(text: 'You Have Consumed '),
                          TextSpan(
                            text: '$consumedCalories',
                            style: const TextStyle(
                              color: Color(0xFF1B7F3A),
                            ),
                          ),
                          const TextSpan(text: '\nCalories'),
                        ],
                      ),
                    ),

                    SizedBox(height: h * 0.011),

                    // ── Subtitle ─────────────────────────
                    Text(
                      'You have ${_formatNumber(remainingCalories)} calories remaining',
                      style: TextStyle(
                        fontSize: w * 0.038,
                        color: Colors.black45,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: h * 0.034),

                    // ── Info Row: Meal Card + Protein/Carbs ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Meal Card
                        Container(
                          width: w * 0.40,
                          height: h * 0.165,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(w * 0.06),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1.2,
                            ),
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
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: w * 0.04),

                        // Protein + Carbs
                        Expanded(
                          child: Column(
                            children: [
                              // Protein
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.035,
                                  vertical: h * 0.022,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius:
                                  BorderRadius.circular(w * 0.1),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Protein',
                                      style: TextStyle(
                                        fontSize: w * 0.042,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1B7F3A),
                                      ),
                                    ),
                                    Text(
                                      '${protein.toStringAsFixed(0)}g',
                                      style: TextStyle(
                                        fontSize: w * 0.040,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: h * 0.014),

                              // Carbs
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.035,
                                  vertical: h * 0.022,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius:
                                  BorderRadius.circular(w * 0.1),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Carbs',
                                      style: TextStyle(
                                        fontSize: w * 0.042,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1B7F3A),
                                      ),
                                    ),
                                    Text(
                                      '${carbs.toStringAsFixed(0)}g',
                                      style: TextStyle(
                                        fontSize: w * 0.040,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                          Color(0xFF1B7F3A),
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.010),

                    // ── Progress Labels ──────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$savedCalories calorie',
                          style: TextStyle(
                            fontSize: w * 0.035,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '${(savePercent * 100).toStringAsFixed(0)}% Save',
                          style: TextStyle(
                            fontSize: w * 0.038,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1B7F3A),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.02),
                  ],
                ),
              ),
            ),

            // ── Continue Button ──────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                  w * 0.05, 0, w * 0.05, h * 0.030),
              child: SizedBox(
                width: double.infinity,
                height: h * 0.058,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to next screen
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MainDashboardScreen()),
                        (Route<dynamic>route)=>false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B7F3A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.08),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 2)
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
                          fontFamily: "extrabold"
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
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }
}