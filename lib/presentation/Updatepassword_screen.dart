import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';

import 'package:naijafit/presentation/sign_in_screen/sign_in_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;
  bool _isLoading = false;

  late final AnimationController _controller;

  late final Animation<Offset> _topSlide;
  late final Animation<double> _topFade;

  late final Animation<Offset> _lockSlide;
  late final Animation<double> _lockFade;

  late final Animation<Offset> _passwordSlide;
  late final Animation<double> _passwordFade;

  late final Animation<Offset> _confirmSlide;
  late final Animation<double> _confirmFade;

  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;

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
        curve: const Interval(0.00, 0.18, curve: Curves.easeOutCubic),
      ),
    );
    _topFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.18, curve: Curves.easeOut),
      ),
    );

    _lockSlide = Tween<Offset>(
      begin: const Offset(0, -0.10),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.38, curve: Curves.easeOutCubic),
      ),
    );
    _lockFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.38, curve: Curves.easeOut),
      ),
    );

    _passwordSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.32, 0.60, curve: Curves.easeOutCubic),
      ),
    );
    _passwordFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.32, 0.60, curve: Curves.easeOut),
      ),
    );

    _confirmSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.42, 0.72, curve: Curves.easeOutCubic),
      ),
    );
    _confirmFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.42, 0.72, curve: Curves.easeOut),
      ),
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.46),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.64, 1.00, curve: Curves.easeOutCubic),
      ),
    );
    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.64, 1.00, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password changed successfully',
            style: TextStyle(fontFamily: "Poppin"),
          ),
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to change password: ${e.toString()}',
            style: const TextStyle(fontFamily: "Poppin"),
          ),
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
  }) =>
      SlideTransition(
        position: slide,
        child: FadeTransition(opacity: fade, child: child),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Header
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
                          'Change',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Poppins",
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

                SizedBox(height: 6.h),

                // Lock image
                _animatedEntry(
                  slide: _lockSlide,
                  fade: _lockFade,
                  child: Center(
                    child: Container(
                      height: size.height * 0.22,
                      width: size.width * 0.45,
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/change_lock.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.lock_rounded,
                          color: const Color(0xFF0A8A2A),
                          size: size.height * 0.20,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 4.h),

                // Title
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),

                SizedBox(height: 1.h),

                // Subtitle
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Enter New password',
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontFamily: "Poppins",
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                // Password field
                _animatedEntry(
                  slide: _passwordSlide,
                  fade: _passwordFade,
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    decoration:
                    const BoxDecoration(color: Colors.transparent),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: "Poppins",
                      ),
                      decoration: InputDecoration(
                        hintText: 'Password...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                          fontFamily: "Poppins",
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF0A8A2A),
                          ),
                          onPressed: () {
                            setState(() =>
                            _isPasswordVisible = !_isPasswordVisible);
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xFF0A8A2A),
                            width: 1.2,
                          ),
                        ),
                        errorStyle:
                        const TextStyle(fontFamily: "Poppin"),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter password';
                        }
                        if (value.trim().length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // Confirm Password field
                _animatedEntry(
                  slide: _confirmSlide,
                  fade: _confirmFade,
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    decoration:
                    const BoxDecoration(color: Colors.transparent),
                    child: TextFormField(
                      controller: _confirmController,
                      obscureText: !_isConfirmVisible,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: "Poppins",
                      ),
                      decoration: InputDecoration(
                        hintText: 'Confirm Password...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                          fontFamily: "Poppins",
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF0A8A2A),
                          ),
                          onPressed: () {
                            setState(() =>
                            _isConfirmVisible = !_isConfirmVisible);
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xFF0A8A2A),
                            width: 1.2,
                          ),
                        ),
                        errorStyle:
                        const TextStyle(fontFamily: "Poppin"),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please confirm password';
                        }
                        if (value.trim() !=
                            _passwordController.text.trim()) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                // Change button
                _animatedEntry(
                  slide: _buttonSlide,
                  fade: _buttonFade,
                  child: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed:
                      _isLoading ? null : _handleChangePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF067C1F),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 0,
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
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                          : const Text(
                        'Change',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Poppins",
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
          ),
        ),
      ),
    );
  }
}