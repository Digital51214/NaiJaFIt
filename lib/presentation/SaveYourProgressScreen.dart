import 'package:flutter/material.dart';
import 'package:naijafit/presentation/sign_up_screen/sign_up_screen.dart';
import 'package:naijafit/widgets/Notification_permission_diologe.dart';

class Saveyourprogressscreen extends StatefulWidget {
  const Saveyourprogressscreen({super.key});

  @override
  State<Saveyourprogressscreen> createState() => _SaveyourprogressscreenState();
}

class _SaveyourprogressscreenState extends State<Saveyourprogressscreen> {
  final int todayCalories = 1840;

  static const Color _green = Color(0xFF1B7F3A);
  static const Color _greenLight = Color(0xFFEAF3DE);

  bool _notificationPopupHandled = false;

  Future<void> _showNotificationPopup() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return NotificationPermissionDialog(
          onAllow: () {
            Navigator.of(context).pop();
            setState(() {
              _notificationPopupHandled = true;
            });
          },
          onDontAllow: () {
            Navigator.of(context).pop();
            setState(() {
              _notificationPopupHandled = true;
            });
          },
        );
      },
    );
  }

  void _saveProgressAction() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  void _handleSaveProgressTap() {
    if (!_notificationPopupHandled) {
      _showNotificationPopup();
    } else {
      _saveProgressAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
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
                      width: w * 0.12,
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
                  Image.asset(
                    'assets/images/LOGO.png',
                    width: w * 0.16,
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
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: h * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(w * 0.07),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFB2CCBA),
                            Color(0xFF3A5A42),
                          ],
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(w * 0.07),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                'assets/images/saveprogressimage.png',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const SizedBox(),
                              ),
                            ),
                            Positioned(
                              bottom: h * 0.025,
                              left: w * 0.04,
                              right: w * 0.04,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _StatCard(
                                      w: w,
                                      h: h,
                                      ts: ts,
                                      rf: rf,
                                      label: 'Today',
                                      value: '$todayCalories',
                                      unit: 'kcal',
                                    ),
                                  ),
                                  SizedBox(width: w * 0.035),
                                  Expanded(
                                    child: _StatCard(
                                      w: w,
                                      h: h,
                                      ts: ts,
                                      rf: rf,
                                      label: 'Today',
                                      value: '$todayCalories',
                                      unit: 'kcal',
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

                    Text(
                      'Save Your Progress',
                      style: TextStyle(
                        fontSize: rf(20) / ts,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        fontFamily: "bold",
                      ),
                    ),

                    SizedBox(height: h * 0.012),

                    Text(
                      'Create an account to keep your progress safe and accessible anytime, even if you switch devices.',
                      style: TextStyle(
                        fontSize: rf(14.5) / ts,
                        color: Colors.black45,
                        height: 1.55,
                        fontFamily: "regular",
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        w * 0.05,
                        w * 0.1,
                        w * 0.05,
                        h * 0.035,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: h * 0.058,
                        child: ElevatedButton(
                          onPressed: _handleSaveProgressTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _green,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(w * 0.1),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 2),
                          ),
                          child: Text(
                            'Save Progress',
                            style: TextStyle(
                              fontSize: rf(14) / ts,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
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
          ],
        ),
      ),
    );
  }
}

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
      height: h * 0.116,
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
            offset: const Offset(0, 4),
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
              fontSize: rf(12) / ts,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              fontFamily: "regular",
            ),
          ),
          SizedBox(height: h * 0.004),
          Text(
            value,
            style: TextStyle(
              fontSize: rf(28) / ts,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              height: 1,
              fontFamily: "bold",
            ),
          ),
          SizedBox(height: h * 0.002),
          Text(
            unit,
            style: TextStyle(
              fontSize: rf(11) / ts,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1B7F3A),
              fontFamily: "semibold",
            ),
          ),
        ],
      ),
    );
  }
}