import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/payment_service.dart';
import '../../widgets/custom_icon_widget.dart';

class SubscriptionCheckoutScreen extends StatefulWidget {
  final String planType;
  final String planTitle;
  final String price;
  final String period;

  const SubscriptionCheckoutScreen({
    super.key,
    required this.planType,
    required this.planTitle,
    required this.price,
    required this.period,
  });

  @override
  State<SubscriptionCheckoutScreen> createState() =>
      _SubscriptionCheckoutScreenState();
}

class _SubscriptionCheckoutScreenState extends State<SubscriptionCheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessingPayment = false;
  String? _message;
  String? _errorMessage;
  bool _isCardComplete = false;
  String _selectedPlan = 'monthly';

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();

  late final stripe.CardEditController _cardController;

  @override
  void initState() {
    super.initState();
    _selectedPlan = widget.planType;

    // ✅ init controller
    _cardController = stripe.CardEditController();

    // ✅ this was causing crash in many cases due to unsafe casting
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = AuthService.instance.currentUser;
      if (user == null) return;
      if (!mounted) return;

      // ✅ SAFE (no "as String?" cast)
      final fullName = user.userMetadata?['full_name']?.toString() ?? '';
      final email = user.email?.toString() ?? '';

      setState(() {
        _emailController.text = email;
        _nameController.text = fullName;
      });
    } catch (e) {
      // ✅ don't crash screen if metadata is weird
      if (kDebugMode) {
        // ignore: avoid_print
        print('Load user data error: $e');
      }
    }
  }

  String get _currentPrice => _selectedPlan == 'monthly' ? '\$2.29' : '\$24.99';
  String get _currentPeriod => _selectedPlan == 'monthly' ? '/month' : '/year';
  String get _currentPlanTitle =>
      _selectedPlan == 'monthly' ? 'Monthly Plan' : 'Yearly Plan';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Complete Subscription',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Plan Selection Toggle
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildPlanToggle(
                                'Monthly Plan',
                                '\$2.29/month',
                                'monthly',
                                theme,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: _buildPlanToggle(
                                'Yearly Plan',
                                '\$24.99/year',
                                'yearly',
                                theme,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),

                      // Plan Summary
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _currentPlanTitle,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _currentPrice,
                                      style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    Text(
                                      _currentPeriod,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            if (_selectedPlan == 'yearly')
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondary.withValues(
                                    alpha: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '7-Day Free Trial',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              ),
                            if (_selectedPlan == 'yearly') SizedBox(height: 1.h),
                            if (_selectedPlan == 'yearly')
                              Text(
                                'You won\'t be charged until your trial ends',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),

                      // Billing Information
                      Text(
                        'Billing Information',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2.h),

                      _buildTextField(_nameController, 'Full Name', true),
                      _buildTextField(_emailController, 'Email', true),
                      _buildTextField(_addressLine1Controller, 'Address Line 1', false),
                      Row(
                        children: [
                          Expanded(child: _buildTextField(_cityController, 'City', false)),
                          SizedBox(width: 3.w),
                          Expanded(child: _buildTextField(_stateController, 'State', false)),
                        ],
                      ),
                      _buildTextField(_zipCodeController, 'Zip Code', false),

                      SizedBox(height: 3.h),

                      // Payment Information
                      Text(
                        'Payment Information',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2.h),

                      // Card Information Section
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Card Information',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 2.h),

                            // ✅ Card Field
                            stripe.CardField(
                              controller: _cardController,
                              onCardChanged: (card) {
                                if (!mounted) return;
                                setState(() {
                                  _isCardComplete = card?.complete ?? false;
                                  if (_errorMessage != null &&
                                      _errorMessage!.toLowerCase().contains('card')) {
                                    _errorMessage = null;
                                  }
                                });
                              },
                            ),

                            SizedBox(height: 3.h),

                            if (kDebugMode)
                              Container(
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  color: Colors.yellow[50],
                                  border: Border.all(color: Colors.orange[200]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Test Cards:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text('Success: 4242 4242 4242 4242',
                                        style: TextStyle(fontSize: 11.sp)),
                                    Text('Declined: 4000 0000 0000 9995',
                                        style: TextStyle(fontSize: 11.sp)),
                                  ],
                                ),
                              ),

                            SizedBox(height: 2.h),

                            if (_message != null)
                              Container(
                                padding: EdgeInsets.all(3.w),
                                margin: EdgeInsets.only(bottom: 2.h),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  border: Border.all(color: Colors.green[200]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.green, size: 16),
                                    SizedBox(width: 2.w),
                                    Expanded(
                                      child: Text(
                                        _message!,
                                        style: TextStyle(color: Colors.green[800]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if (_errorMessage != null)
                              Container(
                                padding: EdgeInsets.all(3.w),
                                margin: EdgeInsets.only(bottom: 2.h),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  border: Border.all(color: Colors.red[200]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.error, color: Colors.red, size: 16),
                                    SizedBox(width: 2.w),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: TextStyle(color: Colors.red[800]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Bottom button
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 6.h,
                          child: ElevatedButton(
                            onPressed: _isProcessingPayment ? null : _handlePayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isProcessingPayment
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Text('Processing...'),
                              ],
                            )
                                : Text(
                              _selectedPlan == 'yearly'
                                  ? 'Start 7-Day Free Trial'
                                  : 'Subscribe Now',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildPlanToggle(
      String title,
      String price,
      String planType,
      ThemeData theme,
      ) {
    final isSelected = _selectedPlan == planType;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = planType;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.5.h),
            Text(
              price,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary.withValues(alpha: 0.9)
                    : theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      bool required,
      ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
        ),
        validator: required
            ? (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        }
            : null,
      ),
    );
  }

  Future<void> _handlePayment() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = 'Please fill in all required fields';
      });
      return;
    }

    if (!_isCardComplete) {
      setState(() {
        _errorMessage = 'Please enter valid card details';
      });
      return;
    }

    setState(() {
      _isProcessingPayment = true;
      _errorMessage = null;
      _message = null;
    });

    try {
      final user = AuthService.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final trialDays = _selectedPlan == 'yearly' ? 7 : 0;

      final subscriptionResponse = await PaymentService.instance.createSubscription(
        userId: user.id,
        priceId: _selectedPlan == 'monthly' ? 'price_monthly_id' : 'price_yearly_id',
        planType: _selectedPlan,
        trialPeriodDays: trialDays,
      );

      await stripe.Stripe.instance.confirmPayment(
        paymentIntentClientSecret: subscriptionResponse.clientSecret,
        data: stripe.PaymentMethodParams.card(
          paymentMethodData: stripe.PaymentMethodData(
            billingDetails: stripe.BillingDetails(
              name: _nameController.text,
              email: _emailController.text,
              address: stripe.Address(
                line1: _addressLine1Controller.text,
                line2: '',
                city: _cityController.text,
                state: _stateController.text,
                postalCode: _zipCodeController.text,
                country: 'US',
              ),
            ),
          ),
        ),
      );

      if (!mounted) return;

      setState(() {
        _message = 'Payment successful! Welcome to NaijaFit Premium.';
        _isProcessingPayment = false;
      });

      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.mainDashboard, (route) => false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Payment failed: ${e.toString()}';
        _isProcessingPayment = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressLine1Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _cardController.dispose();
    super.dispose();
  }
}