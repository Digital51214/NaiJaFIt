import 'package:flutter/material.dart';
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
                      CustomBackButton(onTap: (){
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
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: "Poppin",
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
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: "Poppin",
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Text(
                    'Card Information',
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      color: const Color(0xFF8E8E8E),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppin",
                    ),
                  ),

                  SizedBox(height: 1.6.h),

                  const _InputField(
                    hintText: 'Card Number...',
                    prefixIcon: Icons.credit_card_rounded,
                    keyboardType: TextInputType.number,
                  ),

                  SizedBox(height: 1.h),

                  const _InputField(
                    hintText: 'MM/YY',
                    prefixIcon: Icons.credit_card_rounded,
                    keyboardType: TextInputType.number,
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MainDashboardScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF047A17),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Check Out',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: "Poppin",
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
          fontFamily: "Poppin",
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFF9A9A9A),
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w400,
            fontFamily: "Poppin",
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