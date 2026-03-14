import 'package:flutter/material.dart';
import 'package:naijafit/presentation/Verify_screen.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_icon_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  late final AnimationController _controller;

  late final Animation<Offset> _topSlide;
  late final Animation<double> _topFade;

  late final Animation<Offset> _shieldSlide;
  late final Animation<double> _shieldFade;

  late final Animation<Offset> _emailSlide;
  late final Animation<double> _emailFade;

  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;

  late final Animation<Offset> _successIconSlide;
  late final Animation<double> _successIconFade;

  late final Animation<Offset> _successTextSlide;
  late final Animation<double> _successTextFade;

  late final Animation<Offset> _successButtonSlide;
  late final Animation<double> _successButtonFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _topSlide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.20, curve: Curves.easeOutCubic),
      ),
    );
    _topFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.20, curve: Curves.easeOut),
      ),
    );

    _shieldSlide = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.38, curve: Curves.easeOutCubic),
      ),
    );
    _shieldFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.38, curve: Curves.easeOut),
      ),
    );

    _emailSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.30, 0.60, curve: Curves.easeOutCubic),
      ),
    );
    _emailFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.30, 0.60, curve: Curves.easeOut),
      ),
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 0.90, curve: Curves.easeOutCubic),
      ),
    );
    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.50, 0.90, curve: Curves.easeOut),
      ),
    );

    _successIconSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.35, curve: Curves.easeOutCubic),
      ),
    );
    _successIconFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.30, curve: Curves.easeOut),
      ),
    );

    _successTextSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 0.60, curve: Curves.easeOutCubic),
      ),
    );
    _successTextFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 0.55, curve: Curves.easeOut),
      ),
    );

    _successButtonSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 1.00, curve: Curves.easeOutCubic),
      ),
    );
    _successButtonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.95, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await AuthService.instance.resetPassword(_emailController.text.trim());
      if (!mounted) return;

      setState(() {
        _emailSent = true;
      });

      _controller.reset();
      _controller.forward();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to send reset email: ${e.toString()}',
            style: const TextStyle(fontFamily: "Poppin"),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _animatedEntry({
    required Animation<Offset> slide,
    required Animation<double> fade,
    required Widget child,
  }) {
    return SlideTransition(
      position: slide,
      child: FadeTransition(opacity: fade, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child:
          _emailSent ? _buildSuccessView(theme) : _buildFormView(theme),
        ),
      ),
    );
  }

  Widget _buildFormView(ThemeData theme) {
    final size = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Top header row
          _animatedEntry(
            slide: _topSlide,
            fade: _topFade,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 13.5.w,
                    height: 13.5.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF6EA),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFF0A8A2A),
                        size: 18,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                const Expanded(
                  child: Text(
                    'Forget Password',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Poppin",
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                ),

                Container(
                  height: size.height * 0.08,
                  width: size.width * 0.18,
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

          SizedBox(height: 7.h),

          // Shield image
          _animatedEntry(
            slide: _shieldSlide,
            fade: _shieldFade,
            child: Center(
              child: Container(
                height: size.height * 0.21,
                width: size.width * 0.37,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/forgetpasswordimage.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 6.h),

          // Title
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Verify Your Identity',
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Poppin",
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          SizedBox(height: 1.h),

          // Subtitle
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Enter email to find your account',
              style: TextStyle(
                fontSize: 14,
                fontFamily: "Poppin",
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Email field
          _animatedEntry(
            slide: _emailSlide,
            fade: _emailFade,
            child: SizedBox(
              height: 45,
              width: double.infinity,
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: "Poppin",
                ),
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 10,
                    fontFamily: "Poppin",
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xFF0A8A2A),
                      width: 1.2,
                    ),
                  ),
                  errorStyle: const TextStyle(fontFamily: "Poppin"),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Send Code button
          _animatedEntry(
            slide: _buttonSlide,
            fade: _buttonFade,
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerifyScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF067C1F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: const BorderSide(
                      color: Color(0xFF4BA84F),
                      width: 1.2,
                    ),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(
                  'Send Code',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Poppin",
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 6.h),
        ],
      ),
    );
  }

  Widget _buildSuccessView(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 8.h),

        // Success icon
        _animatedEntry(
          slide: _successIconSlide,
          fade: _successIconFade,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: const BoxDecoration(
              color: Color(0xFFEAF6EA),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'mark_email_read',
              color: const Color(0xFF0A8A2A),
              size: 48,
            ),
          ),
        ),

        SizedBox(height: 4.h),

        // Success text
        _animatedEntry(
          slide: _successTextSlide,
          fade: _successTextFade,
          child: Column(
            children: [
              Text(
                'Check Your Email',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: "Poppin",
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.5.h),
              Text(
                'We\'ve sent password reset instructions to',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontFamily: "Poppin",
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                _emailController.text.trim(),
                style: TextStyle(
                  fontSize: 11.5.sp,
                  fontFamily: "Poppin",
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        SizedBox(height: 6.h),

        // Back to Sign In button
        _animatedEntry(
          slide: _successButtonSlide,
          fade: _successButtonFade,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 1.8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Back to Sign In',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontFamily: "Poppin",
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}