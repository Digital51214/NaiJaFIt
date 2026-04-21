import 'package:flutter/material.dart';
import 'package:naijafit/presentation/sign_up_screen/sign_up_screen.dart';

class NotificationPermissionDialog extends StatelessWidget {
  final VoidCallback onAllow;
  final VoidCallback onDontAllow;

  const NotificationPermissionDialog({
    super.key,
    required this.onAllow,
    required this.onDontAllow,
  });

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    final double ts = MediaQuery.of(context).textScaleFactor;

    double rf(double fs) {
      final scaled = fs * (w / 375);
      return scaled.clamp(fs * 0.85, fs * 1.20);
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: w * 0.08),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(w * 0.05),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.05,
                vertical: h * 0.022,
              ),
              child: Column(
                children: [
                  Text(
                    'NaiJaFit would like to send you\nNotifications',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: rf(15.5) / ts,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 1.35,
                      fontFamily: "bold",
                    ),
                  ),
                  SizedBox(height: h * 0.008),
                  Text(
                    'Stay updated with fitness reminders, progress alerts, and helpful daily motivation from NaiJaFit.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: rf(11.8) / ts,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      height: 1.35,
                      fontFamily: "regular",
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 1,
              width: double.infinity,
              color: Colors.black.withOpacity(0.10),
            ),

            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: onDontAllow,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(w * 0.05),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: h * 0.018),
                        child: Text(
                          "Don’t Allow",
                          style: TextStyle(
                            fontSize: rf(14.5) / ts,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2D2D2D),
                            fontFamily: "regular",
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: 1,
                    color: Colors.black.withOpacity(0.10),
                  ),

                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.pushAndRemoveUntil(context ,MaterialPageRoute(builder: (context)=>SignUpScreen()),
                            (Route<dynamic>route)=>false);
                      },
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(w * 0.05),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: h * 0.018),
                        decoration: const BoxDecoration(
                          color: Color(0xFF026F1A),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(18),
                          ),
                        ),
                        child: Text(
                          "Allow",
                          style: TextStyle(
                            fontSize: rf(14.5) / ts,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: "regular",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}