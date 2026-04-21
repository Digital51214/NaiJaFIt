import 'package:flutter/material.dart';
import 'package:naijafit/presentation/MealHistoryScreen.dart';
import 'package:naijafit/presentation/Notification_screen.dart';
import 'package:naijafit/presentation/Planfreetrailscreen.dart';
import 'package:naijafit/widgets/ReviewBottomsheet.dart';

class Homescreen2 extends StatefulWidget {
  const Homescreen2({super.key});

  @override
  State<Homescreen2> createState() => _Homescreen2State();
}

class _Homescreen2State extends State<Homescreen2>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _contentSlide;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;

  final int _dailyCalorieTarget = 2057;
  final int _caloriesConsumed = 24;
  final int _mealsLogged = 1;

  int get _remainingCalories => _dailyCalorieTarget - _caloriesConsumed;

  double get _progressRatio =>
      _dailyCalorieTarget == 0 ? 0 : _caloriesConsumed / _dailyCalorieTarget;

  static const Color _green = Color(0xFF026F1A);
  static const Color _greenLight = Color(0xFFDCEFDC);
  static const Color _greenCard = Color(0xFFE8F5E9);
  static const Color _bgColor = Color(0xFFF8F8F8);

  bool _hasShownReviewSheet = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.30),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.00, 0.28, curve: Curves.easeOutCubic),
    ));

    _headerFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.00, 0.25, curve: Curves.easeOut),
    ));

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.20),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.18, 0.68, curve: Curves.easeOutCubic),
    ));

    _contentFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.18, 0.62, curve: Curves.easeOut),
    ));

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.58, 1.00, curve: Curves.easeOutCubic),
    ));

    _buttonFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.58, 0.95, curve: Curves.easeOut),
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
        _scheduleReviewBottomSheet();
      }
    });
  }

  void _scheduleReviewBottomSheet() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted || _hasShownReviewSheet) return;
      _showReviewBottomSheet();
    });
  }

  Future<void> _showReviewBottomSheet() async {
    _hasShownReviewSheet = true;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ReviewBottomSheet(
          onPrimaryTap: () {
            Navigator.pop(context);
          },
          onMaybeLaterTap: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animatedEntry({
    required Animation<Offset> slide,
    required Animation<double> fade,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final double w = mq.size.width;
    final double h = mq.size.height;
    final double ts = mq.textScaleFactor;

    double rf(double fs) {
      final scaled = fs * (w / 375);
      return scaled.clamp(fs * 0.85, fs * 1.20);
    }

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.05,
                vertical: h * 0.022,
              ),
              child: _animatedEntry(
                slide: _headerSlide,
                fade: _headerFade,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: w * 0.075,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage:
                      const AssetImage('assets/images/home2.png'),
                      onBackgroundImageError: (_, __) {},
                    ),
                    SizedBox(width: w * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning!',
                            style: TextStyle(
                              fontFamily: "bold",
                              fontSize: rf(20) / ts,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Let's stay on your track today",
                            style: TextStyle(
                              fontFamily: "regular",
                              fontSize: rf(13) / ts,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotificationScreen(),
                        ),
                      ),
                      child: Container(
                        width: w * 0.13,
                        height: w * 0.13,
                        decoration: const BoxDecoration(
                          color: _greenLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications,
                          color: _green,
                          size: w * 0.055,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: _animatedEntry(
                  slide: _contentSlide,
                  fade: _contentFade,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: h * 0.143,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                        decoration: BoxDecoration(
                          color: _greenCard,
                          borderRadius: BorderRadius.circular(w * 0.07),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Daily Calorie Target',
                                    style: TextStyle(
                                      fontFamily: "regular",
                                      fontSize: rf(13) / ts,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: h * 0.006),
                                  Text(
                                    '$_dailyCalorieTarget kcal',
                                    style: TextStyle(
                                      fontFamily: "bold",
                                      fontSize: rf(26) / ts,
                                      fontWeight: FontWeight.w800,
                                      color: _green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: w * 0.04),
                            Container(
                              height: w * 0.18,
                              width: w * 0.18,
                              decoration: const BoxDecoration(
                                color: _green,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: _greenCard,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$_caloriesConsumed',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        fontFamily: "semibold",
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    const Text(
                                      "KCAL USED",
                                      style: TextStyle(
                                        fontFamily: "regular",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 7,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: h * 0.022),

                      Row(
                        children: [
                          Expanded(
                            child: _statCard(
                              w: w,
                              h: h,
                              ts: ts,
                              rf: rf,
                              label: 'CONSUMED',
                              value: '$_caloriesConsumed kcal',
                              subLabel: 'Calories eaten today',
                            ),
                          ),
                          SizedBox(width: w * 0.035),
                          Expanded(
                            child: _statCard(
                              w: w,
                              h: h,
                              ts: ts,
                              rf: rf,
                              label: 'REMAINING',
                              value: '$_remainingCalories kcal',
                              subLabel: 'Left for today',
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: h * 0.015),

                      _rowCard(
                        w: w,
                        h: h,
                        ts: ts,
                        rf: rf,
                        icon: Icons.restaurant_menu_outlined,
                        title: 'Meals Logged',
                        subtitle: '$_mealsLogged',
                        showChevron: false,
                        onTap: () {},
                      ),

                      SizedBox(height: h * 0.01),

                      _rowCard2(
                        w: w,
                        h: h,
                        ts: ts,
                        rf: rf,
                        icon: Icons.history,
                        title: 'Watch Meal History',
                        subtitle: null,
                        titleColor: Colors.black38,
                        showChevron: true,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MealHistoryScreen()),
                        ),
                      ),

                      SizedBox(height: h * 0.028),

                      _animatedEntry(
                        slide: _buttonSlide,
                        fade: _buttonFade,
                        child: SizedBox(
                          width: double.infinity,
                          height: h * 0.068,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PlanFreeTrialScreen(),
                              ),
                            ),
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: w * 0.055,
                            ),
                            label: Text(
                              'Add Meal',
                              style: TextStyle(
                                fontFamily: "bold",
                                fontSize: rf(15) / ts,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _green,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(w * 0.12),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: h * 0.04),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required double w,
    required double h,
    required double ts,
    required double Function(double) rf,
    required String label,
    required String value,
    required String subLabel,
  }) {
    return Container(
      height: 138,
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.045,
        vertical: h * 0.03,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(w * 0.07),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: "semibold",
              fontSize: rf(10) / ts,
              fontWeight: FontWeight.w600,
              color: Colors.black45,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: h * 0.015),
          Text(
            value,
            style: TextStyle(
              fontFamily: "bold",
              fontSize: rf(18) / ts,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: h * 0.01),
          Text(
            subLabel,
            style: TextStyle(
              fontFamily: "regular",
              fontSize: rf(11) / ts,
              color: _green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowCard({
    required double w,
    required double h,
    required double ts,
    required double Function(double) rf,
    required IconData icon,
    required String title,
    required String? subtitle,
    Color titleColor = Colors.black87,
    required bool showChevron,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 85,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.045,
          vertical: h * 0.018,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(w * 0.07),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: w * 0.115,
              height: w * 0.115,
              decoration: const BoxDecoration(
                color: _greenLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: _green, size: w * 0.052),
            ),
            SizedBox(width: w * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: "semibold",
                      fontSize: rf(14) / ts,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: h * 0.004),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: "bold",
                        fontSize: rf(20) / ts,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron)
              Icon(Icons.chevron_right, color: Colors.black38, size: w * 0.06),
          ],
        ),
      ),
    );
  }

  Widget _rowCard2({
    required double w,
    required double h,
    required double ts,
    required double Function(double) rf,
    required IconData icon,
    required String title,
    required String? subtitle,
    Color titleColor = Colors.black87,
    required bool showChevron,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 67,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.045,
          vertical: h * 0.018,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(w * 0.07),
          border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: w * 0.115,
              height: w * 0.115,
              decoration: const BoxDecoration(
                color: _greenLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: _green, size: w * 0.052),
            ),
            SizedBox(width: w * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: "semibold",
                      fontSize: rf(14) / ts,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: h * 0.004),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: "bold",
                        fontSize: rf(20) / ts,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron)
              Icon(Icons.chevron_right, color: Colors.black38, size: w * 0.06),
          ],
        ),
      ),
    );
  }
}