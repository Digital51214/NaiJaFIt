// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:naijafit/presentation/Updatepassword_screen.dart';
// import 'package:sizer/sizer.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class VerifyScreen extends StatefulWidget {
//   final String email; // ✅ email pass karo forgot password se
//
//   const VerifyScreen({super.key, required this.email});
//
//   @override
//   State<VerifyScreen> createState() => _VerifyScreenState();
// }
//
// class _VerifyScreenState extends State<VerifyScreen>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//
//   final List<TextEditingController> _otpControllers =
//   List.generate(6, (_) => TextEditingController());
//   final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
//
//   bool _isLoading = false;
//
//   late final AnimationController _controller;
//
//   late final Animation<Offset> _topSlide;
//   late final Animation<double> _topFade;
//
//   late final Animation<Offset> _shieldSlide;
//   late final Animation<double> _shieldFade;
//
//   late final Animation<Offset> _otpSlide;
//   late final Animation<double> _otpFade;
//
//   late final Animation<Offset> _buttonSlide;
//   late final Animation<double> _buttonFade;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//
//     _topSlide = Tween<Offset>(
//       begin: const Offset(0, -0.35),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.00, 0.20, curve: Curves.easeOutCubic),
//       ),
//     );
//     _topFade = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.00, 0.20, curve: Curves.easeOut),
//       ),
//     );
//
//     _shieldSlide = Tween<Offset>(
//       begin: const Offset(0, -0.10),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.15, 0.40, curve: Curves.easeOutCubic),
//       ),
//     );
//     _shieldFade = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.15, 0.40, curve: Curves.easeOut),
//       ),
//     );
//
//     _otpSlide = Tween<Offset>(
//       begin: const Offset(0, 0.35),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.38, 0.70, curve: Curves.easeOutCubic),
//       ),
//     );
//     _otpFade = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.38, 0.70, curve: Curves.easeOut),
//       ),
//     );
//
//     _buttonSlide = Tween<Offset>(
//       begin: const Offset(0, 0.45),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.60, 1.00, curve: Curves.easeOutCubic),
//       ),
//     );
//     _buttonFade = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.60, 1.00, curve: Curves.easeOut),
//       ),
//     );
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) _controller.forward();
//     });
//   }
//
//   @override
//   void dispose() {
//     for (var c in _otpControllers) {
//       c.dispose();
//     }
//     for (var n in _otpFocusNodes) {
//       n.dispose();
//     }
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _onOtpChanged(String value, int index) {
//     String text = value;
//     if (text.length > 1) {
//       text = text.substring(text.length - 1);
//       _otpControllers[index].text = text;
//     }
//
//     if (text.isNotEmpty) {
//       if (index + 1 < _otpFocusNodes.length) {
//         _otpFocusNodes[index + 1].requestFocus();
//       } else {
//         _otpFocusNodes[index].unfocus();
//       }
//     } else {
//       if (index - 1 >= 0) {
//         _otpFocusNodes[index - 1].requestFocus();
//       }
//     }
//
//     _otpControllers[index].selection = TextSelection.fromPosition(
//       TextPosition(offset: _otpControllers[index].text.length),
//     );
//
//     setState(() {});
//   }
//
//   String get _enteredOtp =>
//       _otpControllers.map((c) => c.text.trim()).join();
//
//   Future<void> _handleVerify() async {
//     if (_enteredOtp.length < 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//             'Please enter the 6-digit code',
//             style: TextStyle(fontFamily: "Poppin"),
//           ),
//         ),
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//       // ✅ Supabase real OTP verification API
//       await Supabase.instance.client.auth.verifyOTP(
//         email: widget.email,
//         token: _enteredOtp,
//         type: OtpType.recovery,
//       );
//
//       if (!mounted) return;
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//             'Code verified successfully',
//             style: TextStyle(fontFamily: "Poppin"),
//           ),
//         ),
//       );
//
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => const ChangePasswordScreen(),
//         ),
//       );
//     } on AuthException catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             e.message.isNotEmpty
//                 ? e.message
//                 : 'Invalid or expired code. Please try again.',
//             style: const TextStyle(fontFamily: "Poppin"),
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Verification failed: ${e.toString()}',
//             style: const TextStyle(fontFamily: "Poppin"),
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   Widget _animatedEntry({
//     required Animation<Offset> slide,
//     required Animation<double> fade,
//     required Widget child,
//   }) {
//     return SlideTransition(
//       position: slide,
//       child: FadeTransition(opacity: fade, child: child),
//     );
//   }
//
//   Widget _buildOtpBox(int index, double boxSize) {
//     return SizedBox(
//       width: boxSize,
//       height: boxSize * 1.3,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           TextFormField(
//             controller: _otpControllers[index],
//             focusNode: _otpFocusNodes[index],
//             autofocus: false,
//             textAlign: TextAlign.center,
//             keyboardType: TextInputType.number,
//             style: TextStyle(
//               color: Colors.transparent,
//               fontSize: 18.sp,
//               fontFamily: "semibold",
//               fontWeight: FontWeight.w700,
//             ),
//             cursorColor: const Color(0xFF026F1A),
//             maxLength: 1,
//             decoration: InputDecoration(
//               counterText: '',
//               filled: true,
//               fillColor: Colors.transparent,
//               contentPadding: const EdgeInsets.symmetric(vertical: 8),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(
//                   color: Colors.grey.shade300,
//                   width: 1.0,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(
//                   color: Color(0xFF026F1A),
//                   width: 1.4,
//                 ),
//               ),
//             ),
//             inputFormatters: [
//               FilteringTextInputFormatter.digitsOnly,
//             ],
//             onChanged: (val) => _onOtpChanged(val, index),
//           ),
//
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 200),
//             transitionBuilder: (child, animation) {
//               return ScaleTransition(
//                 scale: animation,
//                 child: FadeTransition(opacity: animation, child: child),
//               );
//             },
//             child: _otpControllers[index].text.isNotEmpty
//                 ? Text(
//               _otpControllers[index].text,
//               key: ValueKey<String>(_otpControllers[index].text),
//               style: TextStyle(
//                 fontSize: 18.sp,
//                 fontFamily: "semibold",
//                 fontWeight: FontWeight.w700,
//                 color: Colors.black,
//               ),
//             )
//                 : SizedBox(
//               key: const ValueKey<String>('empty'),
//               width: boxSize * 0.01,
//               height: boxSize * 0.01,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final size = MediaQuery.of(context).size;
//
//     final double boxSize = size.width * 0.12;
//
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
//           child: Column(
//             children: [
//               _animatedEntry(
//                 slide: _topSlide,
//                 fade: _topFade,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: () => Navigator.of(context).pop(),
//                       child: Container(
//                         width: 13.5.w,
//                         height: 13.5.w,
//                         decoration: const BoxDecoration(
//                           color: Color(0xFFEAF6EA),
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Center(
//                           child: Icon(
//                             Icons.arrow_back_ios_new,
//                             color: Color(0xFF026F1A),
//                             size: 18,
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(width: 3.w),
//
//                     const Expanded(
//                       child: Text(
//                         'Verify',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontFamily: "bold",
//                           fontWeight: FontWeight.w700,
//                           color: Colors.black,
//                           height: 1.1,
//                         ),
//                       ),
//                     ),
//
//                     Container(
//                       height: size.height * 0.08,
//                       width: size.width * 0.18,
//                       decoration: const BoxDecoration(
//                         color: Colors.transparent,
//                         image: DecorationImage(
//                           image: AssetImage("assets/images/LOGO.png"),
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               SizedBox(height: 7.h),
//
//               _animatedEntry(
//                 slide: _shieldSlide,
//                 fade: _shieldFade,
//                 child: Center(
//                   child: Container(
//                     height: size.height * 0.22,
//                     width: size.width * 0.45,
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage(
//                           "assets/images/forgetpasswordimage.png",
//                         ),
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 5.h),
//
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Enter Code',
//                   style: TextStyle(
//                     fontSize: 20.sp,
//                     fontFamily: "bold",
//                     fontWeight: FontWeight.w800,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 1.h),
//
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Enter code to verify your Identity',
//                   style: TextStyle(
//                     fontSize: 11.5.sp,
//                     fontFamily: "regular",
//                     color: Colors.black54,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 2.h),
//
//               _animatedEntry(
//                 slide: _otpSlide,
//                 fade: _otpFade,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: List.generate(6, (i) {
//                     return _buildOtpBox(i, boxSize);
//                   }),
//                 ),
//               ),
//
//               SizedBox(height: 2.h),
//
//               _animatedEntry(
//                 slide: _buttonSlide,
//                 fade: _buttonFade,
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 45,
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _handleVerify,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF026F1A),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 0,
//                       ),
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(28),
//                         side: const BorderSide(
//                           color: Color(0xFF026F1A),
//                           width: 1.2,
//                         ),
//                       ),
//                     ),
//                     child: _isLoading
//                         ? const SizedBox(
//                       height: 22,
//                       width: 22,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2.2,
//                         valueColor:
//                         AlwaysStoppedAnimation<Color>(Colors.white),
//                       ),
//                     )
//                         : const Text(
//                       'Verify',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontFamily: "semibold",
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 6.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }











import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naijafit/presentation/Updatepassword_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VerifyScreen extends StatefulWidget {
  // final String email; // ✅ email pass karo forgot password se

  // const VerifyScreen({super.key, required this.email});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;

  // ✅ NEW: OTP error ke liye manual error variable add kiya
  // ❌ OLD: Sirf SnackBar se error dikhaya jata tha, koi field-level error nahi tha
  String? _otpError;

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

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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
      begin: const Offset(0, -0.10),
      end: Offset.zero,
    ).animate(
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

    _otpSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
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

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.45),
      end: Offset.zero,
    ).animate(
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

  // ✅ NEW: onChanged mein _otpError bhi clear hoga jab user type kare
  // ❌ OLD: Sirf setState hota tha, koi error clear nahi hoti thi
  void _onOtpChanged(String value, int index) {
    String text = value;
    if (text.length > 1) {
      text = text.substring(text.length - 1);
      _otpControllers[index].text = text;
    }

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

    _otpControllers[index].selection = TextSelection.fromPosition(
      TextPosition(offset: _otpControllers[index].text.length),
    );

    // ✅ NEW: Jab user type kare toh OTP error clear ho jaye
    if (_otpError != null) setState(() => _otpError = null);

    setState(() {});
  }

  String get _enteredOtp =>
      _otpControllers.map((c) => c.text.trim()).join();

  // ✅ NEW: _handleVerify mein SnackBar ki jagah _otpError se error dikhayenge
  // ❌ OLD:
  // Future<void> _handleVerify() async {
  //   if (_enteredOtp.length < 6) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please enter the 6-digit code')),
  //     );
  //     return;
  //   }
  //   ...
  // }
  Future<void> _handleVerify() async {
    // Pehle error clear karo
    setState(() => _otpError = null);

    // Manual validation
    if (_enteredOtp.length < 6) {
      setState(() => _otpError = 'Please enter the complete 6-digit code');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // ✅ Supabase real OTP verification API
      await Supabase.instance.client.auth.verifyOTP(
        // email: widget.email,
        token: _enteredOtp,
        type: OtpType.recovery,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Code verified successfully',
            style: TextStyle(fontFamily: "Poppin"),
          ),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ChangePasswordScreen(),
        ),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message.isNotEmpty
                ? e.message
                : 'Invalid or expired code. Please try again.',
            style: const TextStyle(fontFamily: "Poppin"),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Verification failed: ${e.toString()}',
            style: const TextStyle(fontFamily: "Poppin"),
          ),
          backgroundColor: Colors.red,
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

  // ✅ NEW: _buildOtpBox mein border color ab _otpError se bhi control hogi
  //         Jab error ho toh sabhi 6 boxes red ho jayenge
  // ❌ OLD: Border hamesha grey ya green rehti thi, error pe red nahi hoti thi
  Widget _buildOtpBox(int index, double boxSize) {
    return SizedBox(
      width: boxSize,
      height: boxSize * 1.3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TextFormField(
            controller: _otpControllers[index],
            focusNode: _otpFocusNodes[index],
            autofocus: false,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: Colors.transparent,
              fontSize: 18.sp,
              fontFamily: "semibold",
              fontWeight: FontWeight.w700,
            ),
            cursorColor: const Color(0xFF026F1A),
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              // ✅ NEW: errorStyle height 0 — internal space na le
              errorStyle: const TextStyle(fontSize: 0, height: 0),
              // ✅ NEW: Border color _otpError se control hogi
              // ❌ OLD: enabledBorder mein sirf grey color tha
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _otpError != null
                      ? Colors.red
                      : Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _otpError != null
                      ? Colors.red
                      : const Color(0xFF026F1A),
                  width: 1.4,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.4),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (val) => _onOtpChanged(val, index),
          ),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: _otpControllers[index].text.isNotEmpty
                ? Text(
              _otpControllers[index].text,
              key: ValueKey<String>(_otpControllers[index].text),
              style: TextStyle(
                fontSize: 18.sp,
                fontFamily: "semibold",
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            )
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

    final double boxSize = size.width * 0.12;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            children: [
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
                            color: Color(0xFF026F1A),
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
                          fontFamily: "bold",
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

              _animatedEntry(
                slide: _shieldSlide,
                fade: _shieldFade,
                child: Center(
                  child: Container(
                    height: size.height * 0.22,
                    width: size.width * 0.45,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/forgetpasswordimage.png",
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 5.h),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter Code',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: "bold",
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
                    fontFamily: "regular",
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // ✅ NEW: OTP row ab Column mein wrap hai
              //         Error text boxes ke NEECHE alag Text widget mein show hoga
              //         Boxes ki height/shape bilkul same rahegi — koi distortion nahi
              // ❌ OLD:
              // _animatedEntry(
              //   slide: _otpSlide,
              //   fade: _otpFade,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: List.generate(6, (i) => _buildOtpBox(i, boxSize)),
              //   ),
              // ),
              _animatedEntry(
                slide: _otpSlide,
                fade: _otpFade,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (i) {
                        return _buildOtpBox(i, boxSize);
                      }),
                    ),
                    // ✅ NEW: Error text boxes ke NEECHE alag widget mein
                    if (_otpError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 6),
                        child: Text(
                          _otpError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 11,
                            fontFamily: "regular",
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              _animatedEntry(
                slide: _buttonSlide,
                fade: _buttonFade,
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    // onPressed: _isLoading ? null : _handleVerify,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePasswordScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF026F1A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 0,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                        side: const BorderSide(
                          color: Color(0xFF026F1A),
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
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text(
                      'Verify',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "semibold",
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