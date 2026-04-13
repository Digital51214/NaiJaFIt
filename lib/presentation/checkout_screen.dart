import 'package:flutter/material.dart';
import 'package:naijafit/presentation/SaveYourProgressScreen.dart';
import 'package:naijafit/presentation/ThankyouScreen.dart';
import 'package:naijafit/presentation/main_dashboard_screen/main_dashboard_screen.dart';
import 'package:naijafit/widgets/custom_backbutton.dart';
import 'package:sizer/sizer.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header: Back Button + Logo ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomBackButton(onTap: () {
                        Navigator.of(context).pop();
                      }),
                      Image.asset(
                        'assets/images/LOGO.png',
                        height: 7.h,
                        width: 14.w,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // ── Customer Information ──
                  Text(
                    'Customer Information',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: "medium",
                    ),
                  ),

                  SizedBox(height: 2.h),

                  const _InputField(hintText: 'First Name..'),
                  SizedBox(height: 1.h),

                  const _InputField(hintText: 'Last Name...'),
                  SizedBox(height: 1.h),

                  const _InputField(hintText: 'Email Address...'),
                  SizedBox(height: 1.h),

                  const _InputField(hintText: 'Address line 1'),
                  SizedBox(height: 1.h),

                  Row(
                    children: [
                      const Expanded(
                        child: _InputField(hintText: 'City'),
                      ),
                      SizedBox(width: 3.w),
                      const Expanded(
                        child: _InputField(hintText: 'State'),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  const _InputField(
                    hintText: 'Zip Code/Postal Code',
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 3.h),

                  // ── Billing information ──
                  Text(
                    'Billing information',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: "medium",
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Text(
                    'Card Information',
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: const Color(0xFF8E8E8E),
                      fontWeight: FontWeight.w400,
                      fontFamily: "regular",
                    ),
                  ),

                  SizedBox(height: 1.6.h),

                  const _InputField(
                    hintText: 'Card Number...',
                    prefixIcon: Icons.credit_card_rounded,
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 1.h),

                  Row(
                    children: [
                      const Expanded(
                        child: _InputField(
                          hintText: 'MM/YY',
                          prefixIcon: Icons.credit_card_rounded,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      const Expanded(
                        child: _InputField(
                          hintText: 'CVC',
                          prefixIcon: Icons.lock_outline_rounded,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Bottom Checkout Area ──
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(5.w, 1.2.h, 5.w, 2.5.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(5.w),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 18,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    height: 6.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Saveyourprogressscreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF026F1A),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 2),
                      ),
                      child: Text(
                        'Check Out',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: "bold",
                        ),
                      ),
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

class _InputField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;

  const _InputField({
    required this.hintText,
    this.prefixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6.h,
      child: TextFormField(
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w400,
          color: Colors.black,
          fontFamily: "regular",
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFF9A9A9A),
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w400,
            fontFamily: "regular",
          ),
          filled: true,
          fillColor: const Color(0xFFF7F7F7),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 1.6.h,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
            prefixIcon,
            size: 5.w,
            color: const Color(0xFFAEAEAE),
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(
              color: Color(0xFFD9D9D9),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(
              color: Color(0xFFD9D9D9),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(
              color: Color(0xFF047A17),
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}










// import 'package:flutter/material.dart';
// import 'package:naijafit/presentation/main_dashboard_screen/main_dashboard_screen.dart';
// import 'package:naijafit/services/auth_service.dart';
// import 'package:naijafit/widgets/custom_backbutton.dart';
// import 'package:sizer/sizer.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class CheckoutScreen extends StatefulWidget {
//   // ── Plan Data from PremiumSubscriptionScreen ──
//   final String planId;
//   final String planTitle;
//   final String planPrice;
//   final double amount;
//   final String currency;
//   final String interval;
//   final String userId;
//   final String userEmail;
//   final bool isFreeTrial;
//   final int trialDays;
//
//   const CheckoutScreen({
//     super.key,
//     required this.planId,
//     required this.planTitle,
//     required this.planPrice,
//     required this.amount,
//     required this.currency,
//     required this.interval,
//     required this.userId,
//     required this.userEmail,
//     required this.isFreeTrial,
//     required this.trialDays,
//   });
//
//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }
//
// class _CheckoutScreenState extends State<CheckoutScreen> {
//   // ── Controllers ──
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _stateController = TextEditingController();
//   final _zipController = TextEditingController();
//   final _cardNumberController = TextEditingController();
//   final _cardExpiryController = TextEditingController();
//   final _cardCvcController = TextEditingController();
//
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // Pre-fill email from logged-in user
//     _emailController.text = widget.userEmail;
//   }
//
//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _addressController.dispose();
//     _cityController.dispose();
//     _stateController.dispose();
//     _zipController.dispose();
//     _cardNumberController.dispose();
//     _cardExpiryController.dispose();
//     _cardCvcController.dispose();
//     super.dispose();
//   }
//
//   // ── Validation ──
//   bool _validateFields() {
//     if (_firstNameController.text.trim().isEmpty) {
//       _showSnackBar('Please enter your first name', isError: true);
//       return false;
//     }
//     if (_lastNameController.text.trim().isEmpty) {
//       _showSnackBar('Please enter your last name', isError: true);
//       return false;
//     }
//     if (_emailController.text.trim().isEmpty ||
//         !_emailController.text.contains('@')) {
//       _showSnackBar('Please enter a valid email address', isError: true);
//       return false;
//     }
//     if (_addressController.text.trim().isEmpty) {
//       _showSnackBar('Please enter your address', isError: true);
//       return false;
//     }
//     if (_cityController.text.trim().isEmpty) {
//       _showSnackBar('Please enter your city', isError: true);
//       return false;
//     }
//     if (_stateController.text.trim().isEmpty) {
//       _showSnackBar('Please enter your state', isError: true);
//       return false;
//     }
//     if (_zipController.text.trim().isEmpty) {
//       _showSnackBar('Please enter your zip code', isError: true);
//       return false;
//     }
//     if (_cardNumberController.text.trim().length < 16) {
//       _showSnackBar('Please enter a valid card number', isError: true);
//       return false;
//     }
//     if (_cardExpiryController.text.trim().isEmpty) {
//       _showSnackBar('Please enter card expiry date', isError: true);
//       return false;
//     }
//     if (_cardCvcController.text.trim().length < 3) {
//       _showSnackBar('Please enter a valid CVC', isError: true);
//       return false;
//     }
//     return true;
//   }
//
//   // ── Checkout: Update Supabase profile & navigate ──
//   Future<void> _onCheckout() async {
//     if (!_validateFields()) return;
//
//     setState(() => _isLoading = true);
//
//     try {
//       // Update user profile in Supabase with checkout info
//       await AuthService.instance.updateUserProfile(
//         userId: widget.userId,
//         fullName:
//             '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
//       );
//
//       if (!mounted) return;
//
//       _showSnackBar(
//         widget.isFreeTrial
//             ? '${widget.trialDays}-day free trial started! ✓'
//             : 'Subscription activated! ✓',
//       );
//
//       await Future.delayed(const Duration(milliseconds: 800));
//
//       if (mounted) {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MainDashboardScreen(),
//           ),
//           (route) => false,
//         );
//       }
//     } on AuthException catch (e) {
//       if (mounted) {
//         _showSnackBar('Auth error: ${e.message}', isError: true);
//       }
//     } catch (e) {
//       if (mounted) {
//         _showSnackBar('Checkout failed. Please try again.', isError: true);
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   void _showSnackBar(String message, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: TextStyle(
//             fontSize: 10.sp,
//             fontFamily: "medium",
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor:
//             isError ? Colors.red.shade700 : const Color(0xFF47A312),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F7F7),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             SingleChildScrollView(
//               padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 16.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ── Header ──
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       CustomBackButton(
//                           onTap: () => Navigator.of(context).pop()),
//                       Image.asset(
//                         'assets/images/LOGO.png',
//                         height: 7.h,
//                         width: 14.w,
//                         fit: BoxFit.contain,
//                       ),
//                     ],
//                   ),
//
//                   SizedBox(height: 3.h),
//
//                   // ── Plan Summary Banner ──
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(
//                         horizontal: 4.w, vertical: 1.8.h),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE8F5E9),
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(
//                         color: const Color(0xFF47A312),
//                         width: 1,
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.planTitle,
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 fontFamily: "medium",
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             SizedBox(height: 0.4.h),
//                             Text(
//                               widget.planPrice,
//                               style: TextStyle(
//                                 fontSize: 10.sp,
//                                 fontFamily: "regular",
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.black54,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             if (widget.isFreeTrial)
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 3.w, vertical: 0.4.h),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFF47A312),
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 child: Text(
//                                   '${widget.trialDays} Days FREE',
//                                   style: TextStyle(
//                                     fontSize: 8.sp,
//                                     fontFamily: "medium",
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             SizedBox(height: 0.4.h),
//                             Text(
//                               'Due today: \$0.00',
//                               style: TextStyle(
//                                 fontSize: 9.sp,
//                                 fontFamily: "medium",
//                                 fontWeight: FontWeight.w600,
//                                 color: const Color(0xFF026F1A),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   SizedBox(height: 3.h),
//
//                   // ── Customer Information ──
//                   Text(
//                     'Customer Information',
//                     style: TextStyle(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black,
//                       fontFamily: "medium",
//                     ),
//                   ),
//
//                   SizedBox(height: 2.h),
//
//                   _InputField(
//                     hintText: 'First Name..',
//                     controller: _firstNameController,
//                   ),
//                   SizedBox(height: 1.h),
//
//                   _InputField(
//                     hintText: 'Last Name...',
//                     controller: _lastNameController,
//                   ),
//                   SizedBox(height: 1.h),
//
//                   _InputField(
//                     hintText: 'Email Address...',
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                   ),
//                   SizedBox(height: 1.h),
//
//                   _InputField(
//                     hintText: 'Address line 1',
//                     controller: _addressController,
//                   ),
//                   SizedBox(height: 1.h),
//
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _InputField(
//                           hintText: 'City',
//                           controller: _cityController,
//                         ),
//                       ),
//                       SizedBox(width: 3.w),
//                       Expanded(
//                         child: _InputField(
//                           hintText: 'State',
//                           controller: _stateController,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   SizedBox(height: 1.h),
//
//                   _InputField(
//                     hintText: 'Zip Code/Postal Code',
//                     controller: _zipController,
//                     keyboardType: TextInputType.number,
//                   ),
//
//                   SizedBox(height: 3.h),
//
//                   // ── Billing Information ──
//                   Text(
//                     'Billing information',
//                     style: TextStyle(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black,
//                       fontFamily: "medium",
//                     ),
//                   ),
//
//                   SizedBox(height: 1.h),
//
//                   Text(
//                     'Card Information',
//                     style: TextStyle(
//                       fontSize: 8.sp,
//                       color: const Color(0xFF8E8E8E),
//                       fontWeight: FontWeight.w400,
//                       fontFamily: "regular",
//                     ),
//                   ),
//
//                   SizedBox(height: 1.6.h),
//
//                   _InputField(
//                     hintText: 'Card Number...',
//                     controller: _cardNumberController,
//                     prefixIcon: Icons.credit_card_rounded,
//                     keyboardType: TextInputType.number,
//                     maxLength: 16,
//                   ),
//
//                   SizedBox(height: 1.h),
//
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _InputField(
//                           hintText: 'MM/YY',
//                           controller: _cardExpiryController,
//                           prefixIcon: Icons.credit_card_rounded,
//                           keyboardType: TextInputType.number,
//                         ),
//                       ),
//                       SizedBox(width: 3.w),
//                       Expanded(
//                         child: _InputField(
//                           hintText: 'CVC',
//                           controller: _cardCvcController,
//                           prefixIcon: Icons.lock_outline_rounded,
//                           keyboardType: TextInputType.number,
//                           maxLength: 4,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             // ── Bottom Checkout Button ──
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               child: Container(
//                 padding:
//                     EdgeInsets.fromLTRB(5.w, 1.2.h, 5.w, 2.5.h),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(5.w),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.08),
//                       blurRadius: 18,
//                       offset: const Offset(0, -4),
//                     ),
//                   ],
//                 ),
//                 child: SafeArea(
//                   top: false,
//                   child: SizedBox(
//                     height: 6.h,
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _isLoading ? null : _onCheckout,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF026F1A),
//                         disabledBackgroundColor:
//                             const Color(0xFF026F1A).withOpacity(0.6),
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         padding:
//                             const EdgeInsets.symmetric(vertical: 2),
//                       ),
//                       child: _isLoading
//                           ? const SizedBox(
//                               width: 22,
//                               height: 22,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2.5,
//                               ),
//                             )
//                           : Text(
//                               widget.isFreeTrial
//                                   ? 'Start ${widget.trialDays}-Day Free Trial'
//                                   : 'Check Out',
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.white,
//                                 fontFamily: "bold",
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ── Reusable Input Field with Controller ──
// class _InputField extends StatelessWidget {
//   final String hintText;
//   final TextEditingController controller;
//   final IconData? prefixIcon;
//   final TextInputType? keyboardType;
//   final int? maxLength;
//
//   const _InputField({
//     required this.hintText,
//     required this.controller,
//     this.prefixIcon,
//     this.keyboardType,
//     this.maxLength,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 6.h,
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLength: maxLength,
//         buildCounter: (_,
//                 {required currentLength,
//                 required isFocused,
//                 maxLength}) =>
//             null,
//         style: TextStyle(
//           fontSize: 11.sp,
//           fontWeight: FontWeight.w400,
//           color: Colors.black,
//           fontFamily: "regular",
//         ),
//         decoration: InputDecoration(
//           hintText: hintText,
//           hintStyle: TextStyle(
//             color: const Color(0xFF9A9A9A),
//             fontSize: 10.5.sp,
//             fontWeight: FontWeight.w400,
//             fontFamily: "regular",
//           ),
//           filled: true,
//           fillColor: const Color(0xFFF7F7F7),
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: 4.w,
//             vertical: 1.6.h,
//           ),
//           prefixIcon: prefixIcon != null
//               ? Icon(
//                   prefixIcon,
//                   size: 5.w,
//                   color: const Color(0xFFAEAEAE),
//                 )
//               : null,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(24),
//             borderSide: const BorderSide(
//               color: Color(0xFFD9D9D9),
//               width: 1,
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(24),
//             borderSide: const BorderSide(
//               color: Color(0xFFD9D9D9),
//               width: 1,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(24),
//             borderSide: const BorderSide(
//               color: Color(0xFF047A17),
//               width: 1.2,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }