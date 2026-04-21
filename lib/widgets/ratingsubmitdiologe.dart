import 'package:flutter/material.dart';

class ReviewSuccessDialog extends StatelessWidget {
  const ReviewSuccessDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) => const ReviewSuccessDialog(),
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

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: w * 0.07),
      child: Container(
        padding: EdgeInsets.all(w * 0.07),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(w * 0.07),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 30,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              width: w * 0.22,
              height: w * 0.22,
              decoration: BoxDecoration(
                color: const Color(0xFF026F1A).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: w * 0.16,
                  height: w * 0.16,
                  decoration: const BoxDecoration(
                    color: Color(0xFF026F1A),
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

            SizedBox(height: h * 0.024),

            Text(
              "Thank You! 🎉",
              style: TextStyle(
                fontSize: rf(22) / ts,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),

            SizedBox(height: h * 0.012),

            Text(
              "Your review has been submitted successfully. We appreciate your feedback!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: rf(13.5) / ts,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            SizedBox(height: h * 0.016),

            // Stars display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                    (i) => Icon(
                  Icons.star_rounded,
                  color: const Color(0xFF026F1A),
                  size: w * 0.07,
                ),
              ),
            ),

            SizedBox(height: h * 0.028),

            // Go to Home button
            SizedBox(
              width: double.infinity,
              height: h * 0.062,
              child: ElevatedButton(
                onPressed: () {
                  // Dismiss dialog + rating screen, go to home
                  Navigator.of(context)
                    ..pop() // dialog
                    ..pop(); // rating screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF026F1A),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(w * 0.12),
                  ),
                ),
                child: Text(
                  "Back to Home",
                  style: TextStyle(
                    fontSize: rf(15) / ts,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: h * 0.01),

            TextButton(
              onPressed: () {
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
              child: Text(
                "Maybe later",
                style: TextStyle(
                  fontSize: rf(13.5) / ts,
                  fontWeight: FontWeight.w600,
                  color: Colors.black38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}