import 'package:flutter/material.dart';
import 'package:naijafit/presentation/Privacy_screen.dart';
import 'package:naijafit/presentation/Terms%20and%20condition.dart';
import 'package:naijafit/presentation/sign_in_screen/sign_in_screen.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _isAgreed = true;

  late final AnimationController _controller;

  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;

  late final Animation<Offset> _nameSlide;
  late final Animation<double> _nameFade;

  late final Animation<Offset> _emailSlide;
  late final Animation<double> _emailFade;

  late final Animation<Offset> _passwordSlide;
  late final Animation<double> _passwordFade;

  late final Animation<Offset> _confirmSlide;
  late final Animation<double> _confirmFade;

  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;

  late final Animation<Offset> _signinSlide;
  late final Animation<double> _signinFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.18, curve: Curves.easeOutCubic),
      ),
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.18, curve: Curves.easeOut),
      ),
    );

    _nameSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.22, 0.40, curve: Curves.easeOutCubic),
      ),
    );

    _nameFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.22, 0.40, curve: Curves.easeOut),
      ),
    );

    _emailSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.32, 0.52, curve: Curves.easeOutCubic),
      ),
    );

    _emailFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.32, 0.52, curve: Curves.easeOut),
      ),
    );

    _passwordSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.42, 0.64, curve: Curves.easeOutCubic),
      ),
    );

    _passwordFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.42, 0.64, curve: Curves.easeOut),
      ),
    );

    _confirmSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.54, 0.78, curve: Curves.easeOutCubic),
      ),
    );

    _confirmFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.54, 0.78, curve: Curves.easeOut),
      ),
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 0.90, curve: Curves.easeOutCubic),
      ),
    );

    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 0.90, curve: Curves.easeOut),
      ),
    );

    _signinSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.78, 1.00, curve: Curves.easeOutCubic),
      ),
    );

    _signinFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.78, 1.00, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await AuthService.instance.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed(
        AppRoutes.subscriptionCheckout,
        arguments: {
          'planType': 'yearly',
          'planTitle': 'Yearly Plan',
          'price': '\$24.99',
          'period': '/year',
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sign up failed: ${e.toString()}',
            style: const TextStyle(fontFamily: "Poppin"),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showUserExistsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Account Already Exists',
          style: TextStyle(fontFamily: "Poppin"),
        ),
        content: const Text(
          'An account with this email already exists. Would you like to sign in instead?',
          style: TextStyle(fontFamily: "Poppin"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: "Poppin"),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
            },
            child: const Text(
              'Go to Sign In',
              style: TextStyle(fontFamily: "Poppin"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height - MediaQuery.of(context).padding.top,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.07),

                    SlideTransition(
                      position: _headerSlide,
                      child: FadeTransition(
                        opacity: _headerFade,
                        child: _buildTopLogo(size),
                      ),
                    ),

                    SizedBox(height: size.height * 0.05),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: SlideTransition(
                        position: _headerSlide,
                        child: FadeTransition(
                          opacity: _headerFade,
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppin",
                              color: Colors.black,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: SlideTransition(
                        position: _headerSlide,
                        child: FadeTransition(
                          opacity: _headerFade,
                          child: const Text(
                            'Enter Your Details to SignUp',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppin",
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    SlideTransition(
                      position: _nameSlide,
                      child: FadeTransition(
                        opacity: _nameFade,
                        child: _buildNameField(),
                      ),
                    ),

                    const SizedBox(height: 5),

                    SlideTransition(
                      position: _emailSlide,
                      child: FadeTransition(
                        opacity: _emailFade,
                        child: _buildEmailField(),
                      ),
                    ),

                    const SizedBox(height: 5),

                    SlideTransition(
                      position: _passwordSlide,
                      child: FadeTransition(
                        opacity: _passwordFade,
                        child: _buildPasswordField(),
                      ),
                    ),

                    const SizedBox(height: 5),

                    SlideTransition(
                      position: _confirmSlide,
                      child: FadeTransition(
                        opacity: _confirmFade,
                        child: _buildConfirmPasswordField(),
                      ),
                    ),

                    const SizedBox(height: 5),

                    SlideTransition(
                      position: _confirmSlide,
                      child: FadeTransition(
                        opacity: _confirmFade,
                        child: _buildTermsRow(),
                      ),
                    ),

                    const SizedBox(height: 25),

                    SlideTransition(
                      position: _buttonSlide,
                      child: FadeTransition(
                        opacity: _buttonFade,
                        child: _buildSignUpButton(),
                      ),
                    ),

                    SizedBox(height: size.height * 0.05),

                    SlideTransition(
                      position: _signinSlide,
                      child: FadeTransition(
                        opacity: _signinFade,
                        child: _buildSignInPrompt(),
                      ),
                    ),

                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopLogo(Size size) {
    return Center(
      child: Container(
        height: size.height * 0.2,
        width: size.width * 0.6,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage("assets/images/LOGO.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: TextFormField(
        controller: _nameController,
        keyboardType: TextInputType.name,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: "Poppin",
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: 'Username...',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 10,
            fontFamily: "Poppin",
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          errorStyle: const TextStyle(fontFamily: "Poppin"),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter your name';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: "Poppin",
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: 'Email Address...',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 10,
            fontFamily: "Poppin",
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
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
    );
  }

  Widget _buildPasswordField() {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: "Poppin",
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: 'Password...',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 10,
            fontFamily: "Poppin",
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFF0A8A2A),
              size: 22,
            ),
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          errorStyle: const TextStyle(fontFamily: "Poppin"),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter your password';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: TextFormField(
        controller: _confirmPasswordController,
        obscureText: !_isConfirmPasswordVisible,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: "Poppin",
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: 'Confirm Password...',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 10,
            fontFamily: "Poppin",
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
            icon: Icon(
              _isConfirmPasswordVisible
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: const Color(0xFF0A8A2A),
              size: 22,
            ),
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          errorStyle: const TextStyle(fontFamily: "Poppin"),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please confirm your password';
          }
          if (value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTermsRow() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isAgreed = !_isAgreed;
            });
          },
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF067C1F),
                width: 1,
              ),
              color:
              _isAgreed ? const Color(0xFF067C1F) : Colors.transparent,
            ),
            child: _isAgreed
                ? const Icon(
              Icons.check,
              size: 12,
              color: Colors.white,
            )
                : null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'I agree with all ',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: "Poppin",
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsAndConditions(),
                    ),
                  );
                },
                child: const Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: "Poppin",
                    color: Color(0xFF0A8A2A),
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF0A8A2A),
                  ),
                ),
              ),
              const Text(
                ' and ',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: "Poppin",
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyPolicy(),
                    ),
                  );
                },
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: "Poppin",
                    color: Color(0xFF0A8A2A),
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF0A8A2A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            ),
          );
          // _handleSignUp();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF067C1F),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
          minimumSize: const Size(double.infinity, 45),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: const BorderSide(
              color: Color(0xFF4BA84F),
              width: 1.5,
            ),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : const Center(
          child: Text(
            'Sign Up',
            textAlign: TextAlign.center,
            textHeightBehavior: TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Poppin",
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInPrompt() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            'Already have an account? ',
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Poppin",
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
            },
            child: const Text(
              'Sign In',
              style: TextStyle(
                fontSize: 14,
                fontFamily: "Poppin",
                color: Color(0xFF0A8A2A),
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFF0A8A2A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}