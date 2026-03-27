import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../routes/app_routes.dart';

class SubscriptionTrialScreen extends StatefulWidget {
  const SubscriptionTrialScreen({super.key});

  @override
  State<SubscriptionTrialScreen> createState() => _SubscriptionTrialScreenState();
}

class _SubscriptionTrialScreenState extends State<SubscriptionTrialScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Top (upar se neeche)
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;

  // Bottom (neeche se upar) - stagger
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;

  late final Animation<Offset> _badgeSlide;
  late final Animation<double> _badgeFade;

  late final Animation<Offset> _planSlide;
  late final Animation<double> _planFade;

  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // ✅ Header animation: upar se neeche
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.35, curve: Curves.easeOutCubic),
      ),
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.35, curve: Curves.easeOut),
      ),
    );

    // ✅ Title animation: neeche se upar
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
      ),
    );

    // ✅ Badge animation: neeche se upar
    _badgeSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 0.80, curve: Curves.easeOutCubic),
      ),
    );

    _badgeFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 0.80, curve: Curves.easeOut),
      ),
    );

    // ✅ Plan animation: neeche se upar
    _planSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 0.90, curve: Curves.easeOutCubic),
      ),
    );

    _planFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 0.90, curve: Curves.easeOut),
      ),
    );

    // ✅ Button animation: neeche se upar
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.70, 1.00, curve: Curves.easeOutCubic),
      ),
    );

    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.70, 1.00, curve: Curves.easeOut),
      ),
    );

    // Start animation after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: top->down
              SlideTransition(
                position: _headerSlide,
                child: FadeTransition(
                  opacity: _headerFade,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: theme.colorScheme.outline, width: 1),
                            ),
                            child: const Center(
                              child: Icon(Icons.arrow_back_ios_new),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title: bottom->up
              SlideTransition(
                position: _titleSlide,
                child: FadeTransition(
                  opacity: _titleFade,
                  child: Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 26,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(text: "Start your 7-day ", style: TextStyle(color: Colors.black)),
                          TextSpan(text: "FREE", style: TextStyle(color: Color(0xFFB000F5))),
                          TextSpan(text: "\n     trial to continue", style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Badges: bottom->up
              SlideTransition(
                position: _badgeSlide,
                child: FadeTransition(
                  opacity: _badgeFade,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12,right: 12),
                    child: Row(
                      children: [
                        Expanded(child: _badge("App of the day")),
                        const SizedBox(width: 8),
                        Expanded(child: _badge("4M+ Users")),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Review Card: bottom->up
              SlideTransition(
                position: _planSlide,
                child: FadeTransition(
                  opacity: _planFade,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0,right: 12),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0,right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Best app ever!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                Text("Mar 15\nPieter Levels", textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 12,                          fontFamily: "Poppins",
                                )),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text("★★★★★", style: TextStyle(color: Colors.amber)),
                            SizedBox(height: 5),
                            Text(
                              "Lorem ipsum dolor sit amet. Sit quas dignissimos eum mollitia ratione eum omnis eaque sit esse corporis.",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Selected Plan With Ribbon
              GestureDetector(
                onTap: () {
                  setState(() {
                    var selectedPlan = 0;
                  });
                },
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.only(top: 3,left: 1,right: 1,bottom: 1),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                       child: Column(
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(top: 3.0,bottom: 3),
                             child: Text("7_DAY Free Trial",style: TextStyle(
                               fontWeight: FontWeight.bold,
                               fontSize: 15,
                               fontFamily: "Poppins",

                             ),
                             textAlign: TextAlign.center,),
                           ),
                           Container(
                             height: 65,
                             width: double.infinity,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.only(
                                   bottomLeft: Radius.circular(12),bottomRight: Radius.circular(12)),
                               color: Colors.white,
                             ),
                             child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0,left: 8,right: 12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Yearly",
                                            style: TextStyle(color: Colors.black,                          fontFamily: "Poppins",
                                                fontSize: 18, fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Billed / year",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        "\$1.73/week",
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                           )
                         ],
                       ), 
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: const [
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           "Yearly",
                      //           style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                      //         ),
                      //         Text(
                      //           "Billed / year",
                      //           style: TextStyle(color: Colors.black),
                      //         ),
                      //       ],
                      //     ),
                      //     Text(
                      //       "\$1.73/week",
                      //       style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      //     ),
                      //   ],
                      // ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Second Plan: bottom->up
              GestureDetector(
                onTap: () {
                  setState(() {
                    var selectedPlan = 1;
                  });
                },
                child: SlideTransition(
                  position: _planSlide,
                  child: FadeTransition(
                    opacity: _planFade,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Yearly",
                            style: TextStyle(color: Colors.black, fontSize: 18,                          fontFamily: "Poppins",
                            ),
                          ),
                          Text(
                            "/week",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // No Payment: bottom->up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.check, color: Colors.black, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "No payment due now",
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Button: bottom->up
              SlideTransition(
                position: _buttonSlide,
                child: FadeTransition(
                  opacity: _buttonFade,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pushNamed(
                        AppRoutes.mainDashboard,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 0.h),
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "Start my 7-day free trial",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              const Center(
                child: Text(
                  "7 days free, then per year (\$7.50/mo)",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: AssetImage("assets/images/pati_images.png"),fit: BoxFit.cover)
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 55,right: 55),
          child: Text(
            text,
            style: const TextStyle(                          fontFamily: "Poppins",
                color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}