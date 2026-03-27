import 'package:flutter/material.dart';
import 'package:naijafit/widgets/custom_backbutton.dart';
import 'package:sizer/sizer.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {
        "title": "Notifications",
        "subtitle": "Your Beats Notifications...",
        "time": "10 min ago",
      },
      {
        "title": "Workout Reminder",
        "subtitle": "Don't forget your workout today!",
        "time": "30 min ago",
      },
      {
        "title": "New Feature",
        "subtitle": "AI Coach is now available!",
        "time": "1 hour ago",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            /// 🔝 HEADER
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 3.5.h, 5.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(
                    onTap: () => Navigator.of(context).pop(),
                  ),

                  Image.asset(
                    'assets/images/LOGO.png',
                    height: 8.h,
                    width: 16.w,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.5.h),

            /// 🏷 TITLE
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            /// 📜 LIST
            Expanded(
              child: notifications.isEmpty
                  ? const _EmptyState()
                  : ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                itemCount: notifications.length,
                separatorBuilder: (_, __) => SizedBox(height: 1.5.h),
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return _NotificationCard(
                    title: item["title"]!,
                    subtitle: item["subtitle"]!,
                    time: item["time"]!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 📭 EMPTY STATE (important for real apps)
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No notifications yet",
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey,
          fontFamily: "Poppins",
        ),
      ),
    );
  }
}

/// 🔔 NOTIFICATION CARD
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
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE7ECE3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          /// 🔔 ICON
          Container(
            width: 12.w,
            height: 12.w,
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/notification.png",
              width: 7.w,
              height: 7.w,
            ),
          ),

          SizedBox(width: 3.w),

          /// 📝 TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 0.4.h),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.5),
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 2.w),

          /// ⏱ TIME + DOT
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 1.5.w,
                height: 1.5.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF5DAA2A),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                time,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.4),
                  fontFamily: "Poppins",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}