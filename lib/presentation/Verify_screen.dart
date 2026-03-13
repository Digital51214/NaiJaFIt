import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naijafit/presentation/Updatepassword_screen.dart';
import 'package:sizer/sizer.dart';
class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // OTP controllers & focus nodes (6 boxes)
  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;

  // Animations
  late final AnimationController _controller;

  late final Animation<Offset> _topSlide;
  late final Animation<double> _topFade;

  late final Animation<Offset> _shieldSlide;
  late final Animation<double> _shieldFade;

  late final Animation<Offset> _otpSlide;
  late final Animation<double> _otpFade;

  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;

  @override
  void initState() {
    super.initState();

    // init animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _topSlide = Tween<Offset>(begin: const Offset(0, -0.35), end: Offset.zero)
        .animate(
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

    _shieldSlide =
        Tween<Offset>(begin: const Offset(0, -0.10), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.15, 0.40, curve: Curves.easeOutCubic),
          ),
        );
    _shieldFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.40, curve: Curves.easeOut),
      ),
    );

    _otpSlide =
        Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.38, 0.70, curve: Curves.easeOutCubic),
          ),
        );
    _otpFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.38, 0.70, curve: Curves.easeOut),
      ),
    );

    _buttonSlide =
        Tween<Offset>(begin: const Offset(0, 0.45), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.60, 1.00, curve: Curves.easeOutCubic),
          ),
        );
    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 1.00, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });

    // NOTE: removed automatic requestFocus here so keyboard won't open automatically.
    // Users can tap any OTP box to focus and type.
  }

  @override
  void dispose() {
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var n in _otpFocusNodes) {
      n.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    // keep only last char if pasted multiple
    String text = value;
    if (text.length > 1) {
      text = text.substring(text.length - 1);
      _otpControllers[index].text = text;
    }

    // move focus / unfocus accordingly
    if (text.isNotEmpty) {
      if (index + 1 < _otpFocusNodes.length) {
        _otpFocusNodes[index + 1].requestFocus();
      } else {
        _otpFocusNodes[index].unfocus();
      }
    } else {
      if (index - 1 >= 0) {
        _otpFocusNodes[index - 1].requestFocus();
      }
    }

    // place cursor at end (defensive)
    _otpControllers[index].selection = TextSelection.fromPosition(
        TextPosition(offset: _otpControllers[index].text.length));

    // trigger AnimatedSwitcher to animate new character
    setState(() {});
  }

  String get _enteredOtp =>
      _otpControllers.map((c) => c.text.trim()).join();

  Future<void> _handleVerify() async {
    // simple validation: all 6 boxes filled
    if (_enteredOtp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit code')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // NOTE: No API changes — keep this as UI-only placeholder.
      // If you have verification API, call it here.
      await Future.delayed(const Duration(seconds: 1));

      // For now, show success and navigate to ChangePasswordScreen:
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code verified')),
      );

      // -------------------------
      // <-- THIS IS THE NEW NAVIGATION:
      // After successful verify, go to ChangePasswordScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ChangePasswordScreen(),
        ),
      );
      // -------------------------

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification failed: ${e.toString()}')),
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

  Widget _buildOtpBox(int index, double boxSize) {
    // We use a Stack to keep the editable TextFormField (with transparent text)
    // and an AnimatedSwitcher overlay that shows the visible digit with animation.
    return SizedBox(
      width: boxSize,
      height: boxSize*1.3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Invisible text inside real TextFormField so keyboard + caret remain functional.
          TextFormField(
            controller: _otpControllers[index],
            focusNode: _otpFocusNodes[index],
            autofocus: false, // explicitly false so keyboard won't open automatically
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: TextStyle(
              // hide the raw character to avoid double text; caret will still show.
              color: Colors.transparent,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
            cursorColor: const Color(0xFF0A8A2A),
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                BorderSide(color: Colors.grey.shade300, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: Color(0xFF0A8A2A), width: 1.4),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (val) => _onOtpChanged(val, index),
          ),

          // Visible animated digit
          // AnimatedSwitcher switches when its child Key changes (we use the current text as key)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              // scale + fade for a professional feel
              return ScaleTransition(scale: animation, child: FadeTransition(opacity: animation, child: child));
            },
            child: _otpControllers[index].text.isNotEmpty
                ? Text(
              _otpControllers[index].text,
              key: ValueKey<String>(_otpControllers[index].text),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            )
            // empty placeholder keeps size consistent
                : SizedBox(
              key: const ValueKey<String>('empty'),
              width: boxSize * 0.01,
              height: boxSize * 0.01,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // OTP box size responsive
    final double boxSize = size.width * 0.12; // about 12% of width

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            children: [
              // Top header: back circle, title, small logo
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
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF6EA),
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
                        'Verify',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          height: 1.1,
                        ),
                      ),
                    ),

                    // small logo at top-right
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

              // Shield / center image
              _animatedEntry(
                slide: _shieldSlide,
                fade: _shieldFade,
                child: Center(
                  child: Container(
                    height: size.height * 0.22,
                    width: size.width * 0.45,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image:
                        AssetImage("assets/images/forgetpasswordimage.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 5.h),

              // Title + subtitle
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter Code',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),

              SizedBox(height: 1.h),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter code to verify your Identity',
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // OTP boxes (animated)
              _animatedEntry(
                slide: _otpSlide,
                fade: _otpFade,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (i) {
                    return _buildOtpBox(i, boxSize);
                  }),
                ),
              ),

              SizedBox(height: 2.h),

              // Verify button (animated)
              _animatedEntry(
                slide: _buttonSlide,
                fade: _buttonFade,
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleVerify,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF067C1F),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                        side: const BorderSide(
                          color: Color(0xFF4BA84F),
                          width: 1.2,
                        ),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text(
                      'Verify',
                      style: TextStyle(
                        fontSize: 14,
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
    );
  }
}