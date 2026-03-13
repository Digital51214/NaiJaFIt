import 'package:flutter/material.dart';
import 'package:naijafit/presentation/Continue_fre%20screen.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/benefit_card_widget.dart';
import './widgets/pricing_card_widget.dart';

/// Premium Subscription Screen
/// Presents monetization opportunity with 7-day free trial and cultural value proposition
class PremiumSubscriptionScreen extends StatefulWidget {
  const PremiumSubscriptionScreen({super.key});

  @override
  State<PremiumSubscriptionScreen> createState() =>
      _PremiumSubscriptionScreenState();
}

class _PremiumSubscriptionScreenState extends State<PremiumSubscriptionScreen>
    with SingleTickerProviderStateMixin {
  int _selectedPlanIndex = 1; // Default to yearly plan
  final bool _isProcessing = false;

  // ✅ Animations (same style as previous screens)
  late final AnimationController _controller;

  // Top widgets (from top)
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;

  late final Animation<Offset> _trialSlide;
  late final Animation<double> _trialFade;

  // Bottom widgets (from bottom, stagger)
  late final Animation<Offset> _choosePlanSlide;
  late final Animation<double> _choosePlanFade;

  late final Animation<Offset> _pricingListSlide;
  late final Animation<double> _pricingListFade;

  late final Animation<Offset> _benefitsTitleSlide;
  late final Animation<double> _benefitsTitleFade;

  late final Animation<Offset> _benefitsGridSlide;
  late final Animation<double> _benefitsGridFade;

  late final Animation<Offset> _startTrialBtnSlide;
  late final Animation<double> _startTrialBtnFade;

  late final Animation<Offset> _legalSlide;
  late final Animation<double> _legalFade;

  late final Animation<Offset> _basicSlide;
  late final Animation<double> _basicFade;

  final List<Map<String, dynamic>> _pricingPlans = [
    {
      "id": "monthly",
      "title": "Monthly Plan",
      "price": "\$2.29",
      "period": "/month",
      "description": "Billed monthly",
      "badge": null,
    },
    {
      "id": "yearly",
      "title": "Yearly Plan",
      "price": "\$24.99",
      "period": "/year",
      "description": "Billed annually",
      "badge": "Save one month payment",
    },
  ];

  final List<Map<String, dynamic>> _benefits = [
    {
      "icon": "psychology",
      "title": "AI Nutrition Coach",
      "description": "Personalized guidance for Nigerian diet",
      "imageUrl":
      "https://img.rocket.new/generatedImages/rocket_gen_img_1beea347c-1766491860734.png",
      "semanticLabel":
      "Digital illustration of AI brain with food icons representing intelligent nutrition coaching",
    },
    {
      "icon": "restaurant",
      "title": "Authentic Nigerian Cuisines",
      "description": "Traditional meals with calorie tracking",
      "imageUrl":
      "https://images.unsplash.com/photo-1719846566446-556415153112",
      "semanticLabel":
      "Colorful plate of traditional Nigerian jollof rice with fried plantains and chicken",
    },
    {
      "icon": "insights",
      "title": "Macro Tracking & Insights",
      "description": "Detailed protein, carbs, and fats breakdown",
      "imageUrl":
      "https://img.rocket.new/generatedImages/rocket_gen_img_16e02980c-1768164472763.png",
      "semanticLabel":
      "Modern dashboard showing colorful charts and graphs for nutrition data analysis",
    },
    {
      "icon": "favorite",
      "title": "Cultural Dietary Preferences",
      "description": "Respect for Nigerian eating patterns",
      "imageUrl":
      "https://img.rocket.new/generatedImages/rocket_gen_img_17f5ac6c3-1768401186516.png",
      "semanticLabel":
      "Nigerian family sharing traditional meal together at dining table with various dishes",
    },
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // ✅ TOP: Header row
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

    // ✅ TOP: Trial container
    _trialSlide = Tween<Offset>(
      begin: const Offset(0, -0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.10, 0.28, curve: Curves.easeOutCubic),
      ),
    );
    _trialFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.10, 0.28, curve: Curves.easeOut),
      ),
    );

    // ✅ Bottom: Choose plan title
    _choosePlanSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.22, 0.40, curve: Curves.easeOutCubic),
      ),
    );
    _choosePlanFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.22, 0.40, curve: Curves.easeOut),
      ),
    );

    // ✅ Bottom: Pricing list
    _pricingListSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.32, 0.52, curve: Curves.easeOutCubic),
      ),
    );
    _pricingListFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.32, 0.52, curve: Curves.easeOut),
      ),
    );

    // ✅ Bottom: Benefits title
    _benefitsTitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.42, 0.64, curve: Curves.easeOutCubic),
      ),
    );
    _benefitsTitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.42, 0.64, curve: Curves.easeOut),
      ),
    );

    // ✅ Bottom: Benefits grid
    _benefitsGridSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.54, 0.78, curve: Curves.easeOutCubic),
      ),
    );
    _benefitsGridFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.54, 0.78, curve: Curves.easeOut),
      ),
    );

    // ✅ Bottom: Start trial button
    _startTrialBtnSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 0.90, curve: Curves.easeOutCubic),
      ),
    );
    _startTrialBtnFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 0.90, curve: Curves.easeOut),
      ),
    );

    // ✅ Bottom: Legal text
    _legalSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.74, 0.96, curve: Curves.easeOutCubic),
      ),
    );
    _legalFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.74, 0.96, curve: Curves.easeOut),
      ),
    );

    // ✅ Bottom: Continue basic
    _basicSlide = Tween<Offset>(
      begin: const Offset(0, 0.40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.80, 1.00, curve: Curves.easeOutCubic),
      ),
    );
    _basicFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.80, 1.00, curve: Curves.easeOut),
      ),
    );

    // ✅ start AFTER first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleStartTrial() async {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please sign in to start your trial'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final selectedPlan = _pricingPlans[_selectedPlanIndex];

    Navigator.of(context).pushNamed(
      '/subscription-checkout-screen',
      arguments: {
        'planType': selectedPlan['id'],
        'planTitle': selectedPlan['title'],
        'price': selectedPlan['price'],
        'period': selectedPlan['period'],
      },
    );
  }

  void _handleContinueBasic() {
    Navigator.of(context, rootNavigator: true)
        .pushReplacementNamed('/main-dashboard-screen');
  }

  Widget _entry({
    required Animation<Offset> slide,
    required Animation<double> fade,
    required Widget child,
  }) {
    return SlideTransition(
      position: slide,
      child: FadeTransition(opacity: fade, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Header from TOP
                    _entry(
                      slide: _headerSlide,
                      fade: _headerFade,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Unlock Premium Features',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                              fontSize: 22,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: CustomIconWidget(
                              iconName: 'close',
                              color: theme.colorScheme.onSurface,
                              size: 24,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 44,
                              minHeight: 44,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // ✅ Trial container from TOP
                    _entry(
                      slide: _trialSlide,
                      fade: _trialFade,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 2.h,
                          horizontal: 4.w,
                        ),
                        decoration: BoxDecoration(
                          color:
                          theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Start Your 7-Day Free Trial',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Cancel anytime before trial ends',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // ✅ Choose plan title from BOTTOM
                    _entry(
                      slide: _choosePlanSlide,
                      fade: _choosePlanFade,
                      child: Text(
                        'Choose Your Plan',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // ✅ Pricing cards from BOTTOM
                    _entry(
                      slide: _pricingListSlide,
                      fade: _pricingListFade,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _pricingPlans.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 2.h),
                        itemBuilder: (context, index) {
                          final plan = _pricingPlans[index];
                          return PricingCardWidget(
                            title: plan["title"] as String,
                            price: plan["price"] as String,
                            period: plan["period"] as String,
                            description: plan["description"] as String,
                            badge: plan["badge"] as String?,
                            isSelected: _selectedPlanIndex == index,
                            onTap: () =>
                                setState(() => _selectedPlanIndex = index),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // ✅ Benefits title from BOTTOM
                    _entry(
                      slide: _benefitsTitleSlide,
                      fade: _benefitsTitleFade,
                      child: Text(
                        'Premium Benefits',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // ✅ Benefits grid from BOTTOM
                    _entry(
                      slide: _benefitsGridSlide,
                      fade: _benefitsGridFade,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 2.w,
                          mainAxisSpacing: 2.h,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: _benefits.length,
                        itemBuilder: (context, index) {
                          final benefit = _benefits[index];
                          return BenefitCardWidget(
                            icon: benefit["icon"] as String,
                            title: benefit["title"] as String,
                            description: benefit["description"] as String,
                            imageUrl: benefit["imageUrl"] as String,
                            semanticLabel: benefit["semanticLabel"] as String,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // ✅ Start trial button from BOTTOM
                    _entry(
                      slide: _startTrialBtnSlide,
                      fade: _startTrialBtnFade,
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ContinueFreescreen()));
                              // Navigator.of(context, rootNavigator: true).pushNamed(
                              //   AppRoutes.mainDashboard,
                              // );
                            },
                          // _isProcessing ? null : _handleStartTrial,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 0.h),
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                          child: _isProcessing
                              ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                              : Text(
                            'Start Free Trial',
                            style:
                            theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onPrimary,
                              fontSize: 18
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),

                    // ✅ Legal from BOTTOM
                    _entry(
                      slide: _legalSlide,
                      fade: _legalFade,
                      child: Text(
                        'After 7 days, subscription auto-renews at ${_pricingPlans[_selectedPlanIndex]["price"]}${_pricingPlans[_selectedPlanIndex]["period"]}. Cancel anytime in settings.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // ✅ Continue basic from BOTTOM
                    _entry(
                      slide: _basicSlide,
                      fade: _basicFade,
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pushNamed(
                              AppRoutes.signIn,
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor:
                            theme.colorScheme.onSurfaceVariant,
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 1.h,
                            ),
                          ),
                          child: Text(
                            'Continue with Basic',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurfaceVariant,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}