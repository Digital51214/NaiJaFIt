import 'package:flutter/material.dart';
import 'package:naijafit/presentation/ConsistensyScreen.dart';

class DailyProgressScreen extends StatefulWidget {
  const DailyProgressScreen({super.key});

  @override
  State<DailyProgressScreen> createState() => _DailyProgressScreenState();
}

class _DailyProgressScreenState extends State<DailyProgressScreen> {
  final double averageCalories = 1840;
  final double targetCalories = 2000;
  final int daysWithinTarget = 4;
  final int totalDays = 7;

  final List<double> dailyCalories = [
    1750, 1900, 1600, 2100, 1840, 2050, 1700,
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double hp = size.height;
    final double wp = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: wp * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: hp * 0.02),

              // ── Top Bar ──
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: wp * 0.135,
                      height: wp * 0.135,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F5E0),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        color: const Color(0xFF2D6A2D),
                        size: wp * 0.065,
                      ),
                    ),
                  ),
                  SizedBox(width: wp * 0.03),
                  Text(
                    'Daily Progress',
                    style: TextStyle(
                      fontSize: wp * 0.055,
                      fontFamily: "semibold",
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Image(
                    image: const AssetImage("assets/images/LOGO.png"),
                    height: hp * 0.08,
                    width: wp * 0.18,
                  ),
                ],
              ),

              SizedBox(height: hp * 0.02),

              // ── Weekly Insight Card ──
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: wp * 0.05,
                  vertical: hp * 0.024,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(wp * 0.055),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: wp * 0.135,
                      height: wp * 0.135,
                      decoration: const BoxDecoration(
                        color: Color(0xFFC8E6C0),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.auto_awesome,
                          color: const Color(0xFF1B5E20),
                          size: wp * 0.07,
                        ),
                      ),
                    ),
                    SizedBox(width: wp * 0.04),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Insight',
                          style: TextStyle(
                            fontFamily: "medium",
                            fontSize: wp * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: hp * 0.004),
                        Text(
                          'You stayed with in your goal',
                          style: TextStyle(
                            fontSize: wp * 0.032,
                            fontFamily: "regular",
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          '$daysWithinTarget days this week',
                          style: TextStyle(
                            fontSize: wp * 0.032,
                            fontFamily: "regular",
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: hp * 0.016),

              // ── Average Calories + Days within Target ──
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: hp * 0.13,
                      padding: EdgeInsets.symmetric(
                        horizontal: wp * 0.05,
                        vertical: hp * 0.018,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(wp * 0.05),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Average Calories',
                            style: TextStyle(
                              fontSize: wp * 0.032,
                              fontFamily: "regular",
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: hp * 0.012),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${averageCalories.toInt()}',
                                  style: TextStyle(
                                    fontSize: wp * 0.07,
                                    fontFamily: "semibold",
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2D7D2D),
                                  ),
                                ),
                                TextSpan(
                                  text: ' kcal',
                                  style: TextStyle(
                                    fontSize: wp * 0.03,
                                    fontFamily: "regular",
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF2D7D2D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: wp * 0.04),
                  Expanded(
                    child: Container(
                      height: hp * 0.13,
                      padding: EdgeInsets.symmetric(
                        horizontal: wp * 0.05,
                        vertical: hp * 0.018,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(wp * 0.05),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Days within Target',
                            style: TextStyle(
                              fontSize: wp * 0.032,
                              fontFamily: "regular",
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: hp * 0.012),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '$daysWithinTarget',
                                  style: TextStyle(
                                    fontSize: wp * 0.07,
                                    fontFamily: "semibold",
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2D7D2D),
                                  ),
                                ),
                                TextSpan(
                                  text: '/',
                                  style: TextStyle(
                                    fontSize: wp * 0.06,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: ' $totalDays days',
                                  style: TextStyle(
                                    fontSize: wp * 0.038,
                                    fontFamily: "regular",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: hp * 0.022),

              // ── Calorie Intake Chart Card ──
              Container(
                width: double.infinity,
                height: hp * 0.355,
                padding: EdgeInsets.all(wp * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(wp * 0.055),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Calorie Intake',
                          style: TextStyle(
                            fontSize: wp * 0.048,
                            fontFamily: "semibold",
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        // Actual legend
                        Row(
                          children: [
                            Container(
                              width: wp * 0.025,
                              height: wp * 0.025,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2D7D2D),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: wp * 0.015),
                            Text(
                              'Actual',
                              style: TextStyle(
                                fontSize: wp * 0.03,
                                fontFamily: "regular",
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: wp * 0.04),
                        // Target legend
                        Row(
                          children: [
                            Container(
                              width: wp * 0.045,
                              height: hp * 0.003,
                              color: Colors.grey[400],
                            ),
                            SizedBox(width: wp * 0.015),
                            Text(
                              'Target\n(${targetCalories.toInt()})',
                              style: TextStyle(
                                fontSize: wp * 0.028,
                                fontFamily: "regular",
                                color: Colors.grey[600],
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: hp * 0.035),

                    // ── Static Chart ──
                    SizedBox(
                      height: hp * 0.18,
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: _CalorieChartPainter(
                          targetCalories: targetCalories,
                          pillFontSize: wp * 0.034,
                          pillHeight: hp * 0.032,
                          pillPadH: wp * 0.06,
                        ),
                      ),
                    ),

                    SizedBox(height: hp * 0.03),

                    // ── Day Labels ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _DayLabel('MON'),
                        _DayLabel('TUE'),
                        _DayLabel('WED'),
                        _DayLabel('THU'),
                        _DayLabel('FRI'),
                        _DayLabel('SAT'),
                        _DayLabel('SUN'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: hp * 0.015),

              // ── See Your Consistency ──
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConsistencyScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'SEE YOUR CONSISTENCY',
                      style: TextStyle(
                        fontSize: wp * 0.025,
                        fontFamily: "regular",
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D7D2D),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: wp * 0.02),
                    Icon(
                      Icons.arrow_forward,
                      color: const Color(0xFF2D7D2D),
                      size: wp * 0.05,
                    ),
                  ],
                ),
              ),

              SizedBox(height: hp * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Day Label Widget ──
class _DayLabel extends StatelessWidget {
  final String label;
  const _DayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    final wp = MediaQuery.of(context).size.width;
    return Text(
      label,
      style: TextStyle(
        fontSize: wp * 0.028,
        fontFamily: "regular",
        fontWeight: FontWeight.w600,
        color: Colors.grey[500],
        letterSpacing: 0.3,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// SIMPLE STATIC CHART PAINTER — fully responsive
// ══════════════════════════════════════════════════════════
class _CalorieChartPainter extends CustomPainter {
  final double targetCalories;
  final double pillFontSize;
  final double pillHeight;
  final double pillPadH;

  const _CalorieChartPainter({
    required this.targetCalories,
    required this.pillFontSize,
    required this.pillHeight,
    required this.pillPadH,
  });

  static const double padLeft   = 0.0;
  static const double padTop    = 20.0;
  static const double padBottom = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    // pill width depends on font size — measure first
    final pillTp = TextPainter(
      text: TextSpan(
        text: '${targetCalories.toInt()}',
        style: TextStyle(
          fontSize: pillFontSize,
          fontFamily: "regular",
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final double pillW   = pillTp.width + pillPadH;
    final double padRight = pillW + 4;

    final double chartW = size.width - padLeft - padRight;
    final double chartH = size.height - padTop - padBottom;
    final double lineY  = padTop + chartH * 0.5;

    // ── Green line ──
    canvas.drawLine(
      Offset(padLeft, lineY),
      Offset(padLeft + chartW, lineY),
      Paint()
        ..color = const Color(0xFF2D7D2D)
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // ── Pill ──
    final double pillLeft = padLeft + chartW;

    final pillRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        pillLeft,
        lineY - pillHeight / 2,
        pillW,
        pillHeight,
      ),
      Radius.circular(pillHeight),
    );

    canvas.drawRRect(
      pillRect,
      Paint()..color = const Color(0xFF1B5E20),
    );

    pillTp.paint(
      canvas,
      Offset(
        pillLeft + (pillW - pillTp.width) / 2,
        lineY - pillTp.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(_CalorieChartPainter old) =>
      old.targetCalories != targetCalories ||
          old.pillFontSize != pillFontSize;
}