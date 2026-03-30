// import 'package:flutter/material.dart';
// import 'package:naijafit/presentation/checkout_screen.dart';
// import 'package:naijafit/services/auth_service.dart';
// import 'package:naijafit/widgets/custom_backbutton.dart';
// import 'package:sizer/sizer.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class PremiumSubscriptionScreen extends StatefulWidget {
//   const PremiumSubscriptionScreen({super.key});
//
//   @override
//   State<PremiumSubscriptionScreen> createState() =>
//       _PremiumSubscriptionScreenState();
// }
//
// class _PremiumSubscriptionScreenState extends State<PremiumSubscriptionScreen>
//     with SingleTickerProviderStateMixin {
//   int _selectedPlan = 1;
//   bool _isRestoring = false;
//
//   late final AnimationController _anim;
//   late final Animation<double> _fade;
//   late final Animation<Offset> _slide;
//
//   final List<Map<String, dynamic>> _plans = [
//     {
//       'index': 0,
//       'title': 'Monthly',
//       'price': '\$1.73/wk',
//       'badge': null,
//       'planId': 'monthly_plan',
//       'amount': 6.99,
//       'currency': 'USD',
//       'interval': 'month',
//     },
//     {
//       'index': 1,
//       'title': 'Yearly',
//       'price': '\$0.99/week',
//       'badge': '7 Days Free',
//       'planId': 'yearly_plan',
//       'amount': 51.48,
//       'currency': 'USD',
//       'interval': 'year',
//     },
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _anim = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut)
//         .drive(Tween(begin: 0.0, end: 1.0));
//     _slide = CurvedAnimation(parent: _anim, curve: Curves.easeOut)
//         .drive(Tween(begin: const Offset(0, 0.08), end: Offset.zero));
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) _anim.forward();
//     });
//   }
//
//   @override
//   void dispose() {
//     _anim.dispose();
//     super.dispose();
//   }
//
//   // ── Restore Purchase ──
//   Future<void> _onRestore() async {
//     setState(() => _isRestoring = true);
//     try {
//       final user = AuthService.instance.currentUser;
//       if (user == null) {
//         if (mounted) {
//           _showSnackBar(
//             'No active session found. Please sign in to restore purchases.',
//             isError: true,
//           );
//         }
//         return;
//       }
//
//       final profile = await AuthService.instance.getUserProfile(user.id);
//       if (!mounted) return;
//
//       if (profile == null) {
//         _showSnackBar(
//           'No subscription found for your account.',
//           isError: true,
//         );
//         return;
//       }
//
//       _showSnackBar('Purchase restored successfully! ✓');
//       await Future.delayed(const Duration(seconds: 1));
//       if (mounted) {
//         Navigator.of(context, rootNavigator: true).pushNamed('/home');
//       }
//     } on AuthException catch (e) {
//       if (mounted) {
//         _showSnackBar('Auth error: ${e.message}', isError: true);
//       }
//     } catch (e) {
//       if (mounted) {
//         _showSnackBar('Restore failed. Please try again.', isError: true);
//       }
//     } finally {
//       if (mounted) setState(() => _isRestoring = false);
//     }
//   }
//
//   // ── Start Trial → Navigate to CheckoutScreen with plan data ──
//   void _onStartTrial() {
//     final user = AuthService.instance.currentUser;
//
//     if (user == null) {
//       _showSnackBar('Please sign in to start your trial.', isError: true);
//       return;
//     }
//
//     final selectedPlanData =
//     _plans.firstWhere((p) => p['index'] == _selectedPlan);
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CheckoutScreen(
//           planId: selectedPlanData['planId'] as String,
//           planTitle: selectedPlanData['title'] as String,
//           planPrice: selectedPlanData['price'] as String,
//           amount: selectedPlanData['amount'] as double,
//           currency: selectedPlanData['currency'] as String,
//           interval: selectedPlanData['interval'] as String,
//           userId: user.id,
//           userEmail: user.email ?? '',
//           isFreeTrial: true,
//           trialDays: 7,
//         ),
//       ),
//     );
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
//         isError ? Colors.red.shade700 : const Color(0xFF47A312),
//         behavior: SnackBarBehavior.floating,
//         shape:
//         RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
//
//   Widget _buildTimelineItem({
//     required Widget icon,
//     required Color iconBg,
//     required String title,
//     required String subtitle,
//     bool isLast = false,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           children: [
//             Container(
//               width: 11.w,
//               height: 11.w,
//               decoration: BoxDecoration(
//                 color: iconBg,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(child: icon),
//             ),
//             if (!isLast)
//               Container(
//                 width: 1.5,
//                 height: 5.5.h,
//                 margin: EdgeInsets.symmetric(vertical: 0.3.h),
//                 child: CustomPaint(painter: _DashedLinePainter()),
//               ),
//           ],
//         ),
//         SizedBox(width: 4.w),
//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.only(top: 1.h),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 13.sp,
//                     fontFamily: "medium",
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(height: 0.4.h),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: 9.sp,
//                     fontFamily: "regular",
//                     fontWeight: FontWeight.w400,
//                     color: Colors.black,
//                     height: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPlanCard({
//     required int index,
//     required String title,
//     required String price,
//     String? badge,
//   }) {
//     final isSelected = _selectedPlan == index;
//     return GestureDetector(
//       onTap: () => setState(() => _selectedPlan = index),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             width: 40.w,
//             padding:
//             EdgeInsets.symmetric(vertical: 3.5.h, horizontal: 4.w),
//             decoration: BoxDecoration(
//               color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
//               borderRadius: BorderRadius.circular(25),
//               border: Border.all(
//                 color: isSelected
//                     ? const Color(0xFF47A312)
//                     : Colors.grey.shade300,
//                 width: isSelected ? 2 : 1,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     fontFamily: "medium",
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(height: 0.8.h),
//                 Text(
//                   price,
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     fontFamily: "medium",
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (badge != null)
//             Positioned(
//               top: -1.4.h,
//               right: 3.w,
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: 3.w, vertical: 0.4.h),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF47A312),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   badge,
//                   style: TextStyle(
//                     fontSize: 7.5.sp,
//                     fontFamily: "medium",
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: FadeTransition(
//                 opacity: _fade,
//                 child: SlideTransition(
//                   position: _slide,
//                   child: SingleChildScrollView(
//                     padding: EdgeInsets.symmetric(horizontal: 5.w),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SizedBox(height: 1.h),
//
//                         // ── Header Row ──
//                         Container(
//                           width: double.infinity,
//                           decoration: const BoxDecoration(
//                               color: Colors.transparent),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(top: 4.2.h),
//                                 child: CustomBackButton(
//                                   onTap: () => Navigator.pop(context),
//                                 ),
//                               ),
//                               const Spacer(),
//                               SizedBox(
//                                 height: 200,
//                                 width: 180,
//                                 child: Image.asset(
//                                   'assets/images/LOGO.png',
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                               const Spacer(),
//                               Padding(
//                                 padding: EdgeInsets.only(top: 6.h),
//                                 child: GestureDetector(
//                                   onTap:
//                                   _isRestoring ? null : _onRestore,
//                                   child: _isRestoring
//                                       ? const SizedBox(
//                                     width: 16,
//                                     height: 16,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       color: Color(0xFF2E7D32),
//                                     ),
//                                   )
//                                       : Text(
//                                     'Restore',
//                                     style: TextStyle(
//                                       fontSize: 11.sp,
//                                       fontFamily: "medium",
//                                       fontWeight: FontWeight.w600,
//                                       color:
//                                       const Color(0xFF2E7D32),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         RichText(
//                           textAlign: TextAlign.center,
//                           text: TextSpan(
//                             style: TextStyle(
//                               fontSize: 19.sp,
//                               fontFamily: "semibold",
//                               fontWeight: FontWeight.w800,
//                               color: Colors.black,
//                               height: 1.35,
//                             ),
//                             children: const [
//                               TextSpan(text: 'Start your 7-day '),
//                               TextSpan(
//                                 text: 'FREE',
//                                 style: TextStyle(color: Colors.green),
//                               ),
//                               TextSpan(text: ' trial\nto continue'),
//                             ],
//                           ),
//                         ),
//
//                         SizedBox(height: 2.h),
//
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildTimelineItem(
//                                 iconBg: const Color(0xFFFFC107),
//                                 icon: Icon(Icons.lock,
//                                     color: Colors.black, size: 5.w),
//                                 title: 'Today',
//                                 subtitle:
//                                 "Unclock all the app's feature built for Nigerian\nmeals and portion guidance",
//                               ),
//                               _buildTimelineItem(
//                                 iconBg: const Color(0xFFF5F5F5),
//                                 icon: Icon(Icons.notifications,
//                                     color: Colors.black, size: 5.w),
//                                 title: 'In 6 Days - Reminder',
//                                 subtitle:
//                                 'We will send you a reminder that your trial is\nending soon',
//                               ),
//                               _buildTimelineItem(
//                                 iconBg: const Color(0xFFF5F5F5),
//                                 icon: Icon(
//                                     Icons.calendar_month_outlined,
//                                     color: Colors.black,
//                                     size: 5.w),
//                                 title: 'In 7 Days - Reminder',
//                                 subtitle:
//                                 'You will be charged after 7 days unless you\ncancel anytime before',
//                                 isLast: true,
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         SizedBox(height: 3.h),
//
//                         Row(
//                           mainAxisAlignment:
//                           MainAxisAlignment.spaceBetween,
//                           children: [
//                             _buildPlanCard(
//                               index: 0,
//                               title: 'Monthly',
//                               price: '\$1.73/wk',
//                             ),
//                             _buildPlanCard(
//                               index: 1,
//                               title: 'Yearly',
//                               price: '\$0.99/week',
//                               badge: '7 Days Free',
//                             ),
//                           ],
//                         ),
//
//                         SizedBox(height: 2.h),
//
//                         Text(
//                           'No Payment Due Now',
//                           style: TextStyle(
//                             fontSize: 11.sp,
//                             fontFamily: "medium",
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black54,
//                           ),
//                         ),
//
//                         SizedBox(height: 2.h),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             // ── CTA Button ──
//             Padding(
//               padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
//               child: SizedBox(
//                 height: 45,
//                 width: double.infinity,
//                 child: ElevatedButton(
//                    onPressed: _onStartTrial,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF026F1A),
//                     elevation: 0,
//                     minimumSize: const Size(double.infinity, 50),
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 12, horizontal: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: Text(
//                     'Start my 7-day free trial',
//                     style: TextStyle(
//                       fontSize: 10.sp,
//                       fontFamily: "bold",
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                       height: 1.2,
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
// class _DashedLinePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     const dashHeight = 3.0;
//     const dashSpace = 2.0;
//     final paint = Paint()
//       ..color = Colors.grey.shade400
//       ..strokeWidth = 1.5;
//
//     double startY = 0;
//     while (startY < size.height) {
//       canvas.drawLine(
//         Offset(size.width / 2, startY),
//         Offset(size.width / 2, startY + dashHeight),
//         paint,
//       );
//       startY += dashHeight + dashSpace;
//     }
//   }
//
//   @override
//   bool shouldRepaint(_DashedLinePainter oldDelegate) => false;
// }









import 'package:flutter/material.dart';
import 'package:naijafit/presentation/checkout_screen.dart';
import 'package:naijafit/widgets/custom_backbutton.dart';
import 'package:sizer/sizer.dart';

class PremiumSubscriptionScreen extends StatefulWidget {
  const PremiumSubscriptionScreen({super.key});

  @override
  State<PremiumSubscriptionScreen> createState() =>
      _PremiumSubscriptionScreenState();
}

class _PremiumSubscriptionScreenState extends State<PremiumSubscriptionScreen>
    with SingleTickerProviderStateMixin {
  int _selectedPlan = 1;

  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut)
        .drive(Tween(begin: 0.0, end: 1.0));
    _slide = CurvedAnimation(parent: _anim, curve: Curves.easeOut)
        .drive(Tween(begin: const Offset(0, 0.08), end: Offset.zero));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _anim.forward();
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _onStartTrial() {
    Navigator.of(context, rootNavigator: true).pushNamed('/home');
  }

  void _onRestore() {}

  Widget _buildTimelineItem({
    required Widget icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 11.w,
              height: 11.w,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Center(child: icon),
            ),
            if (!isLast)
              Container(
                width: 1.5,
                height: 5.5.h,
                margin: EdgeInsets.symmetric(vertical: 0.3.h),
                child: CustomPaint(
                  painter: _DashedLinePainter(),
                ),
              ),
          ],
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: "medium",
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 0.4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontFamily: "regular",
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required int index,
    required String title,
    required String price,
    String? badge,
  }) {
    final isSelected = _selectedPlan == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40.w,
            padding: EdgeInsets.symmetric(vertical: 3.5.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF47A312)
                    : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: "medium",
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: "medium",
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          if (badge != null)
            Positioned(
              top: -1.4.h,
              right: 3.w,
              child: Container(
                padding:
                EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF47A312),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 7.5.sp,
                    fontFamily: "medium",
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 1.h),

                        // ── Header Row ──
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 4.2.h),
                                child: CustomBackButton(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              SizedBox(width: 25.sp,),

                              SizedBox(
                                height: 200,
                                width: 180,
                                child: Image.asset(
                                  'assets/images/LOGO.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 19.sp,
                              fontFamily: "semibold",
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              height: 1.35,
                            ),
                            children: const [
                              TextSpan(text: 'Start your 7-day '),
                              TextSpan(
                                text: 'FREE',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              TextSpan(text: ' trial\nto continue'),
                            ],
                          ),
                        ),

                        SizedBox(height: 2.h),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTimelineItem(
                                iconBg: const Color(0xFFFFC107),
                                icon: Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                  size: 5.w,
                                ),
                                title: 'Today',
                                subtitle:
                                "Unclock all the app's feature built for Nigerian\nmeals and portion guidance",
                              ),
                              _buildTimelineItem(
                                iconBg: const Color(0xFFF5F5F5),
                                icon: Icon(
                                  Icons.notifications,
                                  color: Colors.black,
                                  size: 5.w,
                                ),
                                title: 'In 6 Days - Reminder',
                                subtitle:
                                'We will send you a reminder that your trial is\nending soon',
                              ),
                              _buildTimelineItem(
                                iconBg: const Color(0xFFF5F5F5),
                                icon: Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.black,
                                  size: 5.w,
                                ),
                                title: 'In 7 Days - Reminder',
                                subtitle:
                                'You will be charged after 7 days unless you\ncancel anytime before',
                                isLast: true,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 3.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildPlanCard(
                              index: 0,
                              title: 'Monthly',
                              price: '\$1.73/wk',
                            ),
                            _buildPlanCard(
                              index: 1,
                              title: 'Yearly',
                              price: '\$0.99/week',
                              badge: '7 Days Free',
                            ),
                          ],
                        ),

                        SizedBox(height: 2.h),

                        Text(
                          'No Payment Due Now',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontFamily: "medium",
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),

                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
              child: SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckoutScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF026F1A),
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 50),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Start my 7-day free trial',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontFamily: "bold",
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
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

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashHeight = 3.0;
    const dashSpace = 2.0;
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.5;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) => false;
}