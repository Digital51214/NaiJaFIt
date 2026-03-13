import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import '../widgets/custom_error_widget.dart';
import './services/openai_service.dart';
import './services/payment_service.dart';
import './services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // ✅ Stripe Init
  Stripe.publishableKey = "pk_test_your_publishable_key_here";
  await Stripe.instance.applySettings();

  // ✅ CRITICAL: Supabase must initialize BEFORE runApp
  await SupabaseService.initialize();  // 👈 MUST

  // Optional services (non-critical)
  await _initializeOptionalServices();

  runApp(const MyApp());
}

Future<void> _initializeOptionalServices() async {
  try {
    await PaymentService.initialize();
  } catch (e) {
    debugPrint('Stripe Init Error: $e');
  }

  try {
    OpenAIService.instance.initialize();
  } catch (e) {
    debugPrint('OpenAI Init Error: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasShownError = false;

    ErrorWidget.builder = (FlutterErrorDetails details) {
      if (!hasShownError) {
        hasShownError = true;

        Future.delayed(const Duration(seconds: 5), () {
          hasShownError = false;
        });

        return CustomErrorWidget(errorDetails: details);
      }

      return const SizedBox.shrink();
    };

    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'naijafit',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          routes: AppRoutes.routes,
          initialRoute: AppRoutes.splash,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child ?? const SizedBox(),
            );
          },
        );
      },
    );
  }
}