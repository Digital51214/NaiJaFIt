import 'package:flutter/material.dart';
import 'package:naijafit/presentation/RatingSubmitScreen.dart';

class ReviewBottomSheet extends StatelessWidget {
  final VoidCallback onPrimaryTap;
  final VoidCallback onMaybeLaterTap;

  const ReviewBottomSheet({
    super.key,
    required this.onPrimaryTap,
    required this.onMaybeLaterTap,
  });

  static void show(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => ReviewBottomSheet(
          onPrimaryTap: () {
            Navigator.of(sheetContext).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const RatingScreen(),
              ),
            );
          },
          onMaybeLaterTap: () => Navigator.of(sheetContext).pop(),
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final double w = mq.size.width;
    final double h = mq.size.height;
    final double ts = mq.textScaleFactor;

    double rf(double fs) {
      final scaled = fs * (w / 375);
      return scaled.clamp(fs * 0.85, fs * 1.20);
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        w * 0.055,
        h * 0.018,
        w * 0.055,
        h * 0.03,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Drag handle
              Container(
                width: w * 0.12,
                height: h * 0.005,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),

              SizedBox(height: h * 0.022),

              // Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Give us a rating",
                  style: TextStyle(
                    fontSize: rf(26) / ts,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),

              SizedBox(height: h * 0.022),

              // Rating box with laurel
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: h * 0.0,
                  horizontal: w * 0.04,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(w * 0.05),
                  border: Border.all(color: const Color(0xFFE7E7E7)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/leftside.jpg",
                        height: h * 0.11,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "4.8",
                                style: TextStyle(
                                  fontSize: rf(22) / ts,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: w * 0.02),
                              ...List.generate(
                                5,
                                    (i) => Icon(
                                  Icons.star_rounded,
                                  color: const Color(0xFFD89A61),
                                  size: w * 0.065,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.006),
                          Text(
                            "100K+ App Ratings",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: rf(13) / ts,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        "assets/images/rightside.jpg",
                        height: h * 0.12,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.036),

              // Headline
              Text(
                "NaijaFit was made for\npeople like you",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: rf(24) / ts,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),

              SizedBox(height: h * 0.022),

              // Overlapping avatars
              SizedBox(
                height: w * 0.16,
                width: w * 0.45,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 0,
                      child: _Avatar(w: w, path: "assets/images/aiprofile.png"),
                    ),
                    Positioned(
                      left: w * 0.13,
                      child: _Avatar(w: w, path: "assets/images/profile (2).png"),
                    ),
                    Positioned(
                      left: w * 0.26,
                      child: _Avatar(w: w, path: "assets/images/aiprofile.png"),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.012),

              Text(
                "5M+ NaijaFit Users",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: rf(12.5) / ts,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: h * 0.03),

              // Review card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(w * 0.045),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(w * 0.05),
                  border: Border.all(color: const Color(0xFFEAEAEA)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: w * 0.055,
                          backgroundColor: const Color(0xFFDCEFDC),
                          backgroundImage: const AssetImage(
                              "assets/images/profile (2).png"),
                          onBackgroundImageError: (_, __) {},
                        ),
                        SizedBox(width: w * 0.03),
                        Expanded(
                          child: Text(
                            "Chinedu A.",
                            style: TextStyle(
                              fontSize: rf(16) / ts,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ...List.generate(
                          5,
                              (i) => Icon(
                            Icons.star_rounded,
                            color: const Color(0xFFD89A61),
                            size: w * 0.05,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.014),
                    Text(
                      "I didn't stop eating eba — I just adjusted my portion. That alone made a difference.",
                      style: TextStyle(
                        fontSize: rf(14.5) / ts,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.032),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: h * 0.065,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RatingScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF026F1A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.12),
                    ),
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: rf(16) / ts,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: h * 0.01),

              // Maybe later
              TextButton(
                onPressed: onMaybeLaterTap,
                child: Text(
                  "Maybe later",
                  style: TextStyle(
                    fontSize: rf(14.5) / ts,
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
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

// ─── Avatar widget ─────────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  final double w;
  final String path;
  const _Avatar({required this.w, required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w * 0.17,
      height: w * 0.17,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        color: const Color(0xFFDCEFDC),
        image: DecorationImage(
          image: AssetImage(path),
          fit: BoxFit.cover,
          onError: (_, __) {},
        ),
      ),
    );
  }
}

// ─── Laurel icon ───────────────────────────────────────────────────
class _LaurelIcon extends StatelessWidget {
  final double w;
  final bool flip;
  const _LaurelIcon({required this.w, required this.flip});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: flip ? -1 : 1,
      child: CustomPaint(
        size: Size(w * 0.07, w * 0.09),
        painter: _LaurelPainter(),
      ),
    );
  }
}

class _LaurelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD89A61)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.8, size.height * 0.95);
    path.cubicTo(
      size.width * 0.1, size.height * 0.85,
      size.width * 0.0, size.height * 0.5,
      size.width * 0.3, size.height * 0.1,
    );
    canvas.drawPath(path, paint);

    for (int i = 0; i < 4; i++) {
      final t = 0.15 + i * 0.22;
      final x = _cubicT(0.8, 0.1, 0.0, 0.3, t) * size.width;
      final y = _cubicT(0.95, 0.85, 0.5, 0.1, t) * size.height;
      canvas.drawCircle(
        Offset(x, y),
        size.width * 0.13,
        Paint()
          ..color = const Color(0xFFD89A61)
          ..style = PaintingStyle.fill,
      );
    }
  }

  double _cubicT(double p0, double p1, double p2, double p3, double t) {
    return (1 - t) * (1 - t) * (1 - t) * p0 +
        3 * (1 - t) * (1 - t) * t * p1 +
        3 * (1 - t) * t * t * p2 +
        t * t * t * p3;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}