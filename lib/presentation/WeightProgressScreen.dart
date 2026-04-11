import 'package:flutter/material.dart';
import 'package:naijafit/presentation/DailyProgressScreen.dart';

class WeightProgressScreen extends StatefulWidget {
  const WeightProgressScreen({super.key});

  @override
  State<WeightProgressScreen> createState() => _WeightProgressScreenState();
}

class _WeightProgressScreenState extends State<WeightProgressScreen> {
  final List<double> weeklyWeights = [83.5, 81.0, 81.8, 76.5, 73.5, 72.0];
  final double currentWeight = 80.0;
  final double targetWeight = 70.0;
  final double totalLost = 4.5;
  final double weeklyLost = 1.5;
  final double startWeight = 84.5;

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
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Color(0xFF2D6A2D),
                        size: 26,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Text(
                    'Weight Progress',
                    style: TextStyle(
                      fontSize: wp * 0.055,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Image(
                    image: const AssetImage("assets/images/LOGO.png"),
                    height: size.height * 0.08,
                    width: size.width * 0.18,
                  ),
                ],
              ),

              SizedBox(height: hp * 0.02),

              // ── Weekly Insight Card ──
              Container(
                height: 118,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: wp * 0.05,
                  vertical: hp * 0.026,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weekly Insight',
                            style: TextStyle(
                              fontSize: wp * 0.034,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D7D2D),
                            ),
                          ),
                          SizedBox(height: hp * 0.004),
                          Text(
                            'You lost ${weeklyLost}kg this week',
                            style: TextStyle(
                              fontSize: wp * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: hp * 0.004),
                          Text(
                            'Consistency is your superpower! keep it up.',
                            style: TextStyle(
                              fontSize: wp * 0.027,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: wp * 0.13,
                      height: wp * 0.13,
                      decoration: const BoxDecoration(
                        color: Color(0xFFC8E6C0),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image(
                          image: const AssetImage("assets/images/loss.png"),
                          height: 15,
                          width: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: hp * 0.018),

              // ── Weekly Trend Header ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weekly Trend',
                    style: TextStyle(
                      fontSize: wp * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'PERFORMANCE',
                    style: TextStyle(
                      fontSize: wp * 0.027,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D7D2D),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),

              SizedBox(height: hp * 0.015),

              // ── Chart Card ──
              Container(
                width: double.infinity,
                height: hp * 0.25,
                padding: EdgeInsets.symmetric(
                  horizontal: wp * 0.04,
                  vertical: hp * 0.015,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: _WeightChart(
                  weights: weeklyWeights,
                  initialIndex: 3,
                ),
              ),

              SizedBox(height: hp * 0.02),

              // ── Current / Target Cards ──
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: size.height * 0.175,
                      padding: EdgeInsets.symmetric(
                        horizontal: wp * 0.05,
                        vertical: hp * 0.022,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CURRENT',
                            style: TextStyle(
                              fontSize: wp * 0.03,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: hp * 0.008),
                          Text(
                            '${currentWeight.toInt()} kg',
                            style: TextStyle(
                              fontSize: wp * 0.07,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: hp * 0.004),
                          Text(
                            '-${totalLost}kg total',
                            style: TextStyle(
                              fontSize: wp * 0.035,
                              color: const Color(0xFF2D7D2D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: wp * 0.04),
                  Expanded(
                    child: Container(
                      height: size.height * 0.175,
                      padding: EdgeInsets.symmetric(
                        horizontal: wp * 0.05,
                        vertical: hp * 0.022,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'TARGET',
                            style: TextStyle(
                              fontSize: wp * 0.03,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: hp * 0.008),
                          Text(
                            '${targetWeight.toInt()} kg',
                            style: TextStyle(
                              fontSize: wp * 0.07,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFF5A623),
                            ),
                          ),
                          SizedBox(height: hp * 0.009),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: 0.35,
                              minHeight: hp * 0.012,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFFF5A623),
                              ),
                            ),
                          ),
                          SizedBox(height: hp * 0.008),
                          Text(
                            '35 % Achieved',
                            style: TextStyle(
                              fontSize: wp * 0.03,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: hp * 0.015),

              // ── Daily Progress Link ──
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DailyProgressScreen()));
                },
                child: Row(
                  children: [
                    Text(
                      'SEE YOUR DAILY PROGRESS',
                      style: TextStyle(
                        fontSize: wp * 0.025,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D7D2D),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: wp * 0.02),
                    const Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF2D7D2D),
                      size: 20,
                    ),
                  ],
                ),
              ),

              SizedBox(height: hp * 0.025),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// CHART WIDGET — circle moves horizontally along the line
// ══════════════════════════════════════════════════════════
class _WeightChart extends StatefulWidget {
  final List<double> weights;
  final int initialIndex;

  const _WeightChart({
    required this.weights,
    required this.initialIndex,
  });

  @override
  State<_WeightChart> createState() => _WeightChartState();
}

class _WeightChartState extends State<_WeightChart> {
  static const double _minY = 70.0;
  static const double _maxY = 85.0;
  static const double _padLeft = 42.0;
  static const double _padRight = 12.0;
  static const double _padTop = 8.0;
  static const double _padBottom = 8.0;
  static const double _labelRowH = 20.0;

  // Current dot X position as fraction 0.0 → 1.0 across chart width
  // 0.0 = Week 1, 1.0 = Week 6
  late double _dotFraction;

  // Derived: interpolated Y on the line at _dotFraction
  double _interpolatedWeight(double fraction) {
    final double idx = fraction * (widget.weights.length - 1);
    final int lo = idx.floor().clamp(0, widget.weights.length - 2);
    final int hi = (lo + 1).clamp(0, widget.weights.length - 1);
    final double t = idx - lo;
    return widget.weights[lo] * (1 - t) + widget.weights[hi] * t;
  }

  // Shadow opacity depends on weight value:
  // higher weight (top of chart) → heavier shadow
  double _shadowOpacity(double weight) {
    final norm = (weight - _minY) / (_maxY - _minY); // 0=bottom, 1=top
    return 0.05 + norm * 0.30;
  }

  double _chartW(double totalW) => totalW - _padLeft - _padRight;
  double _chartH(double totalH) => totalH - _labelRowH - _padTop - _padBottom;

  @override
  void initState() {
    super.initState();
    _dotFraction = widget.initialIndex / (widget.weights.length - 1);
  }

  void _handleDragUpdate(DragUpdateDetails d, double chartW) {
    if (chartW <= 0) return;
    final delta = d.delta.dx / chartW;
    setState(() {
      _dotFraction = (_dotFraction + delta).clamp(0.0, 1.0);
    });
  }

  // Snap to nearest week index on drag end
  void _handleDragEnd(DragEndDetails d) {
    final nearest = (_dotFraction * (widget.weights.length - 1)).round();
    setState(() {
      _dotFraction = nearest / (widget.weights.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final labels = ['Week 1', 'Week 2', 'Week 3', 'Week 4', 'Week 5', 'Week 6'];

    return LayoutBuilder(builder: (context, constraints) {
      final totalH = constraints.maxHeight;
      final totalW = constraints.maxWidth;
      final cW = _chartW(totalW);
      final cH = _chartH(totalH);

      // Nearest index for label highlight
      final nearestIndex = (_dotFraction * (widget.weights.length - 1)).round();

      return GestureDetector(
        onHorizontalDragUpdate: (d) => _handleDragUpdate(d, cW),
        onHorizontalDragEnd: _handleDragEnd,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Expanded(
              child: CustomPaint(
                size: Size.infinite,
                painter: _LineChartPainter(
                  weights: widget.weights,
                  dotFraction: _dotFraction,
                  minY: _minY,
                  maxY: _maxY,
                  shadowOpacityFn: _shadowOpacity,
                  interpolatedWeightFn: _interpolatedWeight,
                ),
              ),
            ),
            const SizedBox(height: 6),
            // X-axis labels — highlighted week follows dot
            Padding(
              padding: const EdgeInsets.only(left: 35.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(labels.length, (i) {
                  final isHL = i == nearestIndex;
                  return Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: isHL ? FontWeight.bold : FontWeight.normal,
                      color: isHL
                          ? const Color(0xFF2D7D2D)
                          : Colors.grey[600],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ══════════════════════════════════════════════════════════
// PAINTER
// ══════════════════════════════════════════════════════════
class _LineChartPainter extends CustomPainter {
  final List<double> weights;
  final double dotFraction;   // 0.0 = leftmost, 1.0 = rightmost
  final double minY;
  final double maxY;
  final double Function(double weight) shadowOpacityFn;
  final double Function(double fraction) interpolatedWeightFn;

  const _LineChartPainter({
    required this.weights,
    required this.dotFraction,
    required this.minY,
    required this.maxY,
    required this.shadowOpacityFn,
    required this.interpolatedWeightFn,
  });

  static const double padLeft   = 42.0;
  static const double padRight  = 12.0;
  static const double padTop    = 8.0;
  static const double padBottom = 8.0;

  double _yForWeight(double w, double chartH) =>
      padTop + chartH * (1 - (w - minY) / (maxY - minY));

  @override
  void paint(Canvas canvas, Size size) {
    final double chartW = size.width - padLeft - padRight;
    final double chartH = size.height - padTop - padBottom;

    // ── Y-axis gridlines & labels ──
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    for (final yVal in [85.0, 80.0, 75.0, 70.0]) {
      final y = _yForWeight(yVal, chartH);
      canvas.drawLine(
        Offset(padLeft, y),
        Offset(size.width - padRight, y),
        gridPaint,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: '${yVal.toInt()} kg',
          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // ── Compute all line points ──
    final points = <Offset>[];
    for (int i = 0; i < weights.length; i++) {
      final x = padLeft + (i / (weights.length - 1)) * chartW;
      final y = _yForWeight(weights[i], chartH);
      points.add(Offset(x, y));
    }

    // ── Dot position: X from fraction, Y interpolated on line ──
    final dotX = padLeft + dotFraction * chartW;
    final dotWeight = interpolatedWeightFn(dotFraction);
    final dotY = _yForWeight(dotWeight, chartH);

    // ── Shadow opacity driven by dot's current weight position ──
    final double shadowOpacity = shadowOpacityFn(dotWeight);

    // ── Fill area under line ──
    final fillPath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.lineTo(points.last.dx, padTop + chartH);
    fillPath.lineTo(points.first.dx, padTop + chartH);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..color = const Color(0xFF2D7D2D).withOpacity(shadowOpacity)
        ..style = PaintingStyle.fill,
    );

    // ── Green line ──
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      linePath.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = const Color(0xFF2D7D2D)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    // ── Dashed vertical line from dot down to x-axis ──
    final dashPaint = Paint()
      ..color = const Color(0xFF2D7D2D).withOpacity(0.30)
      ..strokeWidth = 1.2;
    double dy = dotY + 14;
    while (dy < padTop + chartH) {
      final end = (dy + 4).clamp(0.0, padTop + chartH);
      canvas.drawLine(Offset(dotX, dy), Offset(dotX, end), dashPaint);
      dy += 7;
    }

    // ── Outer glow ring ──
    canvas.drawCircle(
      Offset(dotX, dotY),
      14,
      Paint()..color = const Color(0xFF2D7D2D).withOpacity(0.15),
    );

    // ── White ring ──
    canvas.drawCircle(
      Offset(dotX, dotY),
      9,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    // ── Green dot ──
    canvas.drawCircle(
      Offset(dotX, dotY),
      7,
      Paint()
        ..color = const Color(0xFF2D7D2D)
        ..style = PaintingStyle.fill,
    );

    // ── Weight label pill above dot ──
    final labelText = '${dotWeight.toStringAsFixed(1)} kg';
    final labelTp = TextPainter(
      text: TextSpan(
        text: labelText,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D7D2D),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Keep pill inside canvas bounds
    double pillCX = dotX;
    final halfPillW = (labelTp.width + 10) / 2;
    if (pillCX - halfPillW < padLeft) pillCX = padLeft + halfPillW;
    if (pillCX + halfPillW > size.width - padRight) {
      pillCX = size.width - padRight - halfPillW;
    }

    final pillRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(pillCX, dotY - 20),
        width: labelTp.width + 10,
        height: labelTp.height + 6,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(pillRect, Paint()..color = const Color(0xFFDFF0D8));
    labelTp.paint(
      canvas,
      Offset(pillCX - labelTp.width / 2, dotY - 20 - labelTp.height / 2),
    );
  }

  @override
  bool shouldRepaint(_LineChartPainter old) => old.dotFraction != dotFraction;
}