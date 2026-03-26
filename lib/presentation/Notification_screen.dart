import 'package:flutter/material.dart';
import 'package:naijafit/widgets/custom_backbutton.dart';
import 'package:sizer/sizer.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3.5.h),

                /// Top Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),

                    /// Logo
                    Image.asset(
                      'assets/images/LOGO.png',
                      height: 8.h,
                      width: 16.w,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),

                SizedBox(height: 2.5.h),

                /// Title
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),

                SizedBox(height: 2.5.h),

                /// Notification Cards
                const _NotificationCard(
                  title: "Notifications",
                  subtitle: "Your Beats Notifications......",
                  time: "10 min Ago",
                ),
                SizedBox(height: 1.2.h),

                const _NotificationCard(
                  title: "Notifications",
                  subtitle: "Your Beats Notifications......",
                  time: "10 min Ago",
                ),
                SizedBox(height: 1.2.h),

                const _NotificationCard(
                  title: "Notifications",
                  subtitle: "Your Beats Notifications......",
                  time: "10 min Ago",
                ),

                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;

  const _NotificationCard({
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE7ECE3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          /// Leading Icon
          Container(
            alignment: Alignment.center,
            width: 12.w,
            height: 12.w,
            child: Image.asset(
              "assets/images/notification.png",
              width: 7.w,
              height: 7.w,
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(width: 2.5.w),

          /// Center Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 0.4.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.2.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.38),
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 2.w),

          /// Trailing Time + Dot
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 1.5.w,
                height: 1.5.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF5DAA2A),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 1.5.w),
              Text(
                time,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.35),
                  fontFamily: "Poppin",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}