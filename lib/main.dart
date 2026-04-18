import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import '../core/app_state.dart';
import '../widgets/custom_error_widget.dart';
import './services/openai_service.dart';
import './services/payment_service.dart';
import './services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
    debugPrintStack(stackTrace: details.stack);
  };

  runZonedGuarded(() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    await _initializeStripeSafely();
    await _initializeSupabaseSafely();

    runApp(const MyApp());

    unawaited(_initializeOptionalServices());
  }, (error, stackTrace) {
    debugPrint('Unhandled Zone Error: $error');
    debugPrintStack(stackTrace: stackTrace);

    runApp(
      StartupErrorApp(
        message: 'Unhandled startup error: $error',
      ),
    );
  });
}

Future<void> _initializeStripeSafely() async {
  try {
    // Yahan apni REAL publishable key lagani hai
    Stripe.publishableKey = "pk_test_your_actual_publishable_key";
    await Stripe.instance.applySettings();
  } catch (e, stackTrace) {
    debugPrint('Stripe Init Error: $e');
    debugPrintStack(stackTrace: stackTrace);
  }
}

Future<void> _initializeSupabaseSafely() async {
  try {
    await SupabaseService.initialize();
  } catch (e, stackTrace) {
    debugPrint('Supabase Init Error: $e');
    debugPrintStack(stackTrace: stackTrace);
  }
}

Future<void> _initializeOptionalServices() async {
  try {
    await PaymentService.initialize();
  } catch (e, stackTrace) {
    debugPrint('PaymentService Init Error: $e');
    debugPrintStack(stackTrace: stackTrace);
  }

  try {
    OpenAIService.instance.initialize();
  } catch (e, stackTrace) {
    debugPrint('OpenAI Init Error: $e');
    debugPrintStack(stackTrace: stackTrace);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return CustomErrorWidget(errorDetails: details);
    };

    return AppStateProvider(
      child: Sizer(
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
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}

class StartupErrorApp extends StatelessWidget {
  final String message;

  const StartupErrorApp({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}