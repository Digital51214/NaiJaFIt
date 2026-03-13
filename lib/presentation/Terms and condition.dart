import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;

  late final Animation<Offset> _introSlide;
  late final Animation<double> _introFade;

  late final Animation<Offset> _bodySlide;
  late final Animation<double> _bodyFade;

  late final Animation<Offset> _moreSlide;
  late final Animation<double> _moreFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.20, curve: Curves.easeOutCubic),
      ),
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.20, curve: Curves.easeOut),
      ),
    );

    _introSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    _introFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.45, curve: Curves.easeOut),
      ),
    );

    _bodySlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _bodyFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
      ),
    );

    _moreSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.00, curve: Curves.easeOutCubic),
      ),
    );

    _moreFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.00, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildParagraph(String text, double screenWidth) {
    return Text(
      text,
      style: TextStyle(
        fontSize: screenWidth * 0.043,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF2B2B2B),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.045),

              // Header: Back button, Title, Logo
              SlideTransition(
                position: _headerSlide,
                child: FadeTransition(
                  opacity: _headerFade,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 13.5.w,
                          height: 13.5.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFFDDE5DB),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Color(0xFF0A8A2A),
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: screenWidth * 0.04),

                      const Expanded(
                        child: Text(
                          'Terms & Conditions',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.black,
                            height: 1.2,
                          ),
                        ),
                      ),

                      // Right logo
                      Container(
                        height: screenHeight * 0.08,
                        width: screenWidth * 0.18,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: AssetImage("assets/images/LOGO.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SlideTransition(
                        position: _introSlide,
                        child: FadeTransition(
                          opacity: _introFade,
                          child: _buildParagraph(
                            "Welcome to NaijaFit. These Terms & Conditions govern your use of our application and services. By accessing or using NaijaFit, you agree to be bound by these terms. If you do not agree with any part of these terms, you must not use our services.",
                            screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildParagraph(
                            "User Accounts\n"
                                "When you create an account with NaijaFit, you agree to provide accurate and complete information. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You must notify us immediately of any unauthorized use of your account.\n\n"
                                "Acceptable Use\n"
                                "You agree not to misuse the service or help anyone else do so. This includes, but is not limited to, not posting illegal content, not attempting to probe, scan or test the vulnerability of any system or network, and not engaging in activity that would facilitate survival of malware.",
                            screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      SlideTransition(
                        position: _bodySlide,
                        child: FadeTransition(
                          opacity: _bodyFade,
                          child: _buildParagraph(
                            "Intellectual Property\n"
                                "All content, features, and functionality of the app (including but not limited to text, images, graphics, logos, and software) are the property of NaijaFit or its licensors and are protected by copyright, trademark, and other intellectual property laws.\n\n"
                                "Limitation of Liability\n"
                                "To the fullest extent permitted by law, NaijaFit and its affiliates will not be liable for any indirect, incidental, special, consequential or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly.",
                            screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      SlideTransition(
                        position: _moreSlide,
                        child: FadeTransition(
                          opacity: _moreFade,
                          child: _buildParagraph(
                            "Changes to These Terms\n"
                                "We may revise these Terms & Conditions at any time. When we do, we will update the date at the top of the terms. By continuing to use the app after those changes become effective, you agree to be bound by the revised terms.\n\n"
                                "Contact Us\n"
                                "If you have questions about these Terms & Conditions, please contact us through the support channels available in the app.",
                            screenWidth,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),
                    ],
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