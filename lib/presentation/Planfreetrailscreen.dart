import 'package:flutter/material.dart';
import 'package:naijafit/presentation/Reminder_screen.dart';
import 'package:naijafit/widgets/custom_backbutton.dart';
import 'package:sizer/sizer.dart';

class PlanFreeTrialScreen extends StatefulWidget {
  const PlanFreeTrialScreen({super.key});

  @override
  State<PlanFreeTrialScreen> createState() => _PlanFreeTrialScreenState();
}

class _PlanFreeTrialScreenState extends State<PlanFreeTrialScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut)
        .drive(Tween(begin: 0.0, end: 1.0));
    _slide = CurvedAnimation(parent: _anim, curve: Curves.easeOut)
        .drive(Tween(begin: const Offset(0, 0.08), end: Offset.zero));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _anim.forward();
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _onTryForFree() {
    // Change this route to your next screen
    Navigator.of(context, rootNavigator: true).pushNamed('/next-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: Back Button + Logo ──
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 4.h, 5.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  CustomBackButton(onTap: (){
                    Navigator.of(context).pop();
                  }),

                  // Logo — replace path when ready
                  Image.asset(
                    'assets/images/LOGO.png',
                    height: 60,
                    width: 60,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // ── Title ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 21.sp,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        height: 1.35,
                      ),
                      children: const [
                        TextSpan(text: 'We want you to try '),
                        TextSpan(
                          text: 'Naijafit',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        TextSpan(text: '\nfor free'),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 3.h),

            // ── Center Image ──
            // Replace 'assets/images/plan_hero.png' with your food/app image
            Expanded(
              child: FadeTransition(
                opacity: _fade,
                child: Center(
                  child: Image.asset(
                    'assets/images/plan_image.png',
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
            ),

            // ── Try for Free Button ──
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
              child: SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ReminderScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 50),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Try for free!',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}