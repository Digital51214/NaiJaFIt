import 'package:flutter/material.dart';
import 'package:naijafit/presentation/Planfreetrailscreen.dart';
import 'package:naijafit/widgets/custom_backbutton.dart';
import 'package:sizer/sizer.dart';

class WhatNigeriansAreSayingScreen extends StatefulWidget {
  const WhatNigeriansAreSayingScreen({super.key});

  @override
  State<WhatNigeriansAreSayingScreen> createState() =>
      _WhatNigeriansAreSayingScreenState();
}

class _WhatNigeriansAreSayingScreenState
    extends State<WhatNigeriansAreSayingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Chinedu A. (Lagos)',
      'rating': 5,
      'review':
      "I didn't realize how much eba I was actually eating until I used this app. Just reducing the portion alone made a big difference. I've lost 3kg without changing my food",
    },
    {
      'name': 'Amina S. (Abuja)',
      'rating': 5,
      'review':
      "I like that it doesn't tell me to stop eating Nigerian food. It just shows me how to eat it properly. That's what has been missing",
    },
    {
      'name': 'Tunde O. (Ibadan)',
      'rating': 5,
      'review':
      "Most apps don't even have amala or ewedu. This one actually understands our food. That's why I stuck with it.",
    },
  ];

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

  void _onContinue() {
    // Change this route name to whatever your next screen route is
    Navigator.of(context, rootNavigator: true).pushNamed('/next-screen');
  }

  Widget _buildStars(int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        return Icon(
          Icons.star_rounded,
          color: const Color(0xFFFFC107),
          size: 5.w,
        );
      }),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + Name + Stars Row
          Row(
            children: [
              // Avatar circle
              Container(
                width: 11.w,
                height: 11.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF2E7D32),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image(image: AssetImage("assets/images/Ellipse 86.png"),
                    fit: BoxFit.cover,height: double.infinity,width: double.infinity,)
                ),
              ),

              SizedBox(width: 3.w),

              // Name
              Expanded(
                child: Text(
                  review['name'],
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: "Poppin",
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Stars
              _buildStars(review['rating']),
            ],
          ),

          SizedBox(height: 1.5.h),

          // Review text
          Text(
            review['review'],
            style: TextStyle(
              fontSize: 10.sp,
              fontFamily: "Poppin",
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          SizedBox(height: 5,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header: Back Button + Logo ──
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 4.h, 5.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(onTap:(){
                    Navigator.pop(context);
                  }),

                  // Logo — replace 'assets/images/LOGO.png' with your image path
                  Image.asset(
                    'assets/images/LOGO.png',
                    height: 60,
                    width: 60,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // ── Scrollable Content ──
            Expanded(
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontFamily: "Poppin",
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              height: 1.3,
                            ),
                            children: const [
                              TextSpan(text: 'What '),
                              TextSpan(
                                text: 'Nigerians',
                                style: TextStyle(
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                              TextSpan(text: ' Are\nSaying'),
                            ],
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Review Cards
                        ..._reviews.map((r) => _buildReviewCard(r)).toList(),

                        SizedBox(height: 1.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Continue Button ──
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PlanFreeTrialScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: "Poppin",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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