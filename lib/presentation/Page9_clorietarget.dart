// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// class Page7CalorieTargetDisplay extends StatefulWidget {
//   final Map<String, dynamic> onboardingData;
//   final Function(bool) onNextEnabled;
//
//   const Page7CalorieTargetDisplay({
//     super.key,
//     required this.onboardingData,
//     required this.onNextEnabled,
//   });
//
//   @override
//   State<Page7CalorieTargetDisplay> createState() =>
//       _Page7CalorieTargetDisplayState();
// }
//
// class _Page7CalorieTargetDisplayState
//     extends State<Page7CalorieTargetDisplay>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _anim;
//   late final Animation<double> _fade;
//   late final Animation<Offset> _slide;
//   late Animation<int> _calorieAnim;
//
//   bool _macroExpanded = false;
//   bool _summaryExpanded = false;
//
//   int get _cals =>
//       widget.onboardingData['dailyCalories'] as int? ?? 2000;
//
//   String get _goal =>
//       widget.onboardingData['fitnessGoal'] as String? ?? 'maintain_weight';
//
//   Map<String, dynamic> get _macros {
//     final Map<String, Map<String, double>> ratios = {
//       'lose_weight': {'protein': 0.30, 'carbs': 0.40, 'fats': 0.30},
//       'gain_weight': {'protein': 0.35, 'carbs': 0.45, 'fats': 0.20},
//       'maintain_weight': {'protein': 0.25, 'carbs': 0.50, 'fats': 0.25},
//     };
//     final r = ratios[_goal] ?? ratios['maintain_weight']!;
//     return {
//       'protein': ((_cals * r['protein']!) / 4).round(),
//       'carbs': ((_cals * r['carbs']!) / 4).round(),
//       'fats': ((_cals * r['fats']!) / 9).round(),
//       'proteinPct': r['protein']!,
//       'carbsPct': r['carbs']!,
//       'fatsPct': r['fats']!,
//     };
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _anim = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     );
//     _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut)
//         .drive(Tween(begin: 0.0, end: 1.0));
//     _slide = CurvedAnimation(parent: _anim, curve: Curves.easeOut)
//         .drive(Tween(begin: const Offset(0, 0.08), end: Offset.zero));
//     _calorieAnim = IntTween(begin: 0, end: _cals).animate(
//       CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic),
//     );
//
//     widget.onNextEnabled(true);
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
//   String _fmtGoal(String g) {
//     switch (g) {
//       case 'lose_weight':
//         return 'Lose Weight';
//       case 'gain_weight':
//         return 'Gain Weight';
//       case 'maintain_weight':
//         return 'Maintain Weight';
//       default:
//         return g;
//     }
//   }
//
//   String _fmtActivity(String? a) {
//     switch (a) {
//       case 'sedentary':
//         return 'Sedentary';
//       case 'lightly_active':
//         return 'Lightly Active';
//       case 'moderately_active':
//         return 'Moderately Active';
//       case 'very_active':
//         return 'Very Active';
//       case 'extremely_active':
//         return 'Extremely Active';
//       default:
//         return a ?? 'Not set';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final data = widget.onboardingData;
//
//     return FadeTransition(
//       opacity: _fade,
//       child: SlideTransition(
//         position: _slide,
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Your Personalized plan',
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontFamily: "semibold",
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black,
//                 ),
//               ),
//
//               SizedBox(height: 0.5.h),
//
//               Text(
//                 'This is your personalized plan and summary of your target and details',
//                 style: TextStyle(
//                   fontSize: 11.5.sp,
//                   fontFamily: "regular",
//                   color: Colors.grey[600],
//                 ),
//               ),
//
//               SizedBox(height: 3.h),
//
//               // Calorie card
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 3.h),
//
//                     Text(
//                       'Your Daily Calorie Target',
//                       style: TextStyle(
//                         fontSize: 11.7.sp,
//                         fontFamily: "regular",
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//
//                     SizedBox(height: 3.h),
//
//                     AnimatedBuilder(
//                       animation: _calorieAnim,
//                       builder: (_, __) => Text(
//                         '${_calorieAnim.value}',
//                         style: TextStyle(
//                           fontSize: 29.sp,
//                           fontFamily: "semibold",
//                           fontWeight: FontWeight.w800,
//                           color: const Color(0xFF2E7D32),
//                           height: 1,
//                         ),
//                       ),
//                     ),
//
//                     SizedBox(height: 2.h),
//
//                     Text(
//                       'Calories',
//                       style: TextStyle(
//                         fontSize: 11.7.sp,
//                         fontFamily: "medium",
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//
//                     SizedBox(height: 3.h),
//                   ],
//                 ),
//               ),
//
//               SizedBox(height: 1.5.h),
//
//               // Macro Breakdown accordion
//               _accordion(
//                 title: 'Macro Breakdown',
//                 expanded: _macroExpanded,
//                 onTap: () =>
//                     setState(() => _macroExpanded = !_macroExpanded),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 1.5.h),
//                     _macroRow(
//                       'Protein',
//                       _macros['protein'] as int,
//                       _macros['proteinPct'] as double,
//                       Colors.orange,
//                     ),
//                     SizedBox(height: 1.h),
//                     _macroRow(
//                       'Carbs',
//                       _macros['carbs'] as int,
//                       _macros['carbsPct'] as double,
//                       const Color(0xFF2E7D32),
//                     ),
//                     SizedBox(height: 1.h),
//                     _macroRow(
//                       'Fats',
//                       _macros['fats'] as int,
//                       _macros['fatsPct'] as double,
//                       Colors.blue,
//                     ),
//                   ],
//                 ),
//               ),
//
//               SizedBox(height: 1.5.h),
//
//               // Plan Summary accordion
//               _accordion(
//                 title: 'Plan Summary',
//                 expanded: _summaryExpanded,
//                 onTap: () =>
//                     setState(() => _summaryExpanded = !_summaryExpanded),
//                 child: Padding(
//                   padding: EdgeInsets.only(top: 1.5.h),
//                   child: Column(
//                     children: [
//                       _summaryRow('Goal', _fmtGoal(_goal)),
//                       SizedBox(height: 1.h),
//                       _summaryRow(
//                         'Timeline',
//                         data['timeline']?.toString() ?? 'Not set',
//                       ),
//                       SizedBox(height: 1.h),
//                       _summaryRow(
//                         'Activity Level',
//                         _fmtActivity(data['activityLevel']?.toString()),
//                       ),
//                       SizedBox(height: 1.h),
//                       _summaryRow(
//                         'Current Weight',
//                         data['currentWeightRaw'] != null
//                             ? '${data['currentWeightRaw']} ${data['currentWeightUnit'] ?? 'KG'}'
//                             : 'Not set',
//                       ),
//                       SizedBox(height: 1.h),
//                       _summaryRow(
//                         'Target Weight',
//                         data['targetWeightRaw'] != null
//                             ? '${data['targetWeightRaw']} ${data['targetWeightUnit'] ?? 'KG'}'
//                             : 'Not set',
//                       ),
//                       SizedBox(height: 1.h),
//                       _summaryRow('Daily Calories', '$_cals kcal'),
//                     ],
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 2.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _accordion({
//     required String title,
//     required bool expanded,
//     required VoidCallback onTap,
//     required Widget child,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.3.h),
//         decoration: BoxDecoration(
//           color: Colors.grey.withOpacity(0.05),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     fontFamily: "semibold",
//                     fontWeight: FontWeight.w600,
//                     color: const Color(0xFF2E7D32),
//                   ),
//                 ),
//                 AnimatedRotation(
//                   turns: expanded ? 0.5 : 0,
//                   duration: const Duration(milliseconds: 300),
//                   child: const Icon(
//                     Icons.keyboard_arrow_down,
//                     color: Color(0xFF2E7D32),
//                   ),
//                 ),
//               ],
//             ),
//             if (expanded) child,
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _macroRow(String name, int grams, double pct, Color color) {
//     return Row(
//       children: [
//         SizedBox(
//           width: 18.w,
//           child: Text(
//             name,
//             style: TextStyle(
//               fontSize: 11.sp,
//               fontFamily: "medium",
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         Expanded(
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(4),
//             child: LinearProgressIndicator(
//               value: pct,
//               minHeight: 8,
//               backgroundColor: Colors.grey[200],
//               valueColor: AlwaysStoppedAnimation<Color>(color),
//             ),
//           ),
//         ),
//         SizedBox(width: 2.w),
//         Text(
//           '${grams}g',
//           style: TextStyle(
//             fontSize: 10.sp,
//             fontFamily: "medium",
//             color: Colors.grey[600],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _summaryRow(String label, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 11.sp,
//             fontFamily: "medium",
//             color: Colors.grey[600],
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 11.sp,
//             fontFamily: "medium",
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }
// }









import 'package:flutter/material.dart';
import 'package:naijafit/presentation/Nagarionsays_screen.dart';
import 'package:sizer/sizer.dart';

/// Standalone screen — no longer part of onboarding PageView.
/// Receives all collected data via [onboardingData].
class Page7CalorieTargetDisplay extends StatefulWidget {
  final Map<String, dynamic> onboardingData;

  const Page7CalorieTargetDisplay({
    super.key,
    required this.onboardingData,
  });

  @override
  State<Page7CalorieTargetDisplay> createState() =>
      _Page7CalorieTargetDisplayState();
}

class _Page7CalorieTargetDisplayState extends State<Page7CalorieTargetDisplay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late Animation<int> _calorieAnim;

  bool _summaryExpanded = true;

  // ── Derived helpers ──────────────────────────────────────────────────────

  int get _cals => widget.onboardingData['dailyCalories'] as int? ?? 2000;

  String get _goal =>
      widget.onboardingData['fitnessGoal'] as String? ?? 'maintain_weight';

  Map<String, dynamic> get _macros {
    final Map<String, Map<String, double>> ratios = {
      'lose_weight': {'protein': 0.30, 'carbs': 0.40, 'fats': 0.30},
      'gain_weight': {'protein': 0.35, 'carbs': 0.45, 'fats': 0.20},
      'maintain_weight': {'protein': 0.25, 'carbs': 0.50, 'fats': 0.25},
    };
    final r = ratios[_goal] ?? ratios['maintain_weight']!;
    return {
      'protein': ((_cals * r['protein']!) / 4).round(),
      'carbs': ((_cals * r['carbs']!) / 4).round(),
      'fats': ((_cals * r['fats']!) / 9).round(),
      'proteinPct': r['protein']!,
      'carbsPct': r['carbs']!,
      'fatsPct': r['fats']!,
    };
  }

  int get _healthScore {
    switch (_goal) {
      case 'lose_weight':
        return 88;
      case 'gain_weight':
        return 84;
      default:
        return 90;
    }
  }

  String get _goalTitle {
    switch (_goal) {
      case 'lose_weight':
        return 'Fat-loss focused plan';
      case 'gain_weight':
        return 'Healthy weight-gain plan';
      default:
        return 'Balanced maintenance plan';
    }
  }

  String get _goalDescription {
    switch (_goal) {
      case 'lose_weight':
        return 'Higher protein and a calorie deficit to support steady fat loss.';
      case 'gain_weight':
        return 'Slight calorie surplus with balanced macros to support growth.';
      default:
        return 'Balanced calorie target and macros to help maintain your weight.';
    }
  }

  // ── Formatters ───────────────────────────────────────────────────────────

  String _fmtGoal(String g) {
    switch (g) {
      case 'lose_weight':
        return 'Lose Weight';
      case 'gain_weight':
        return 'Gain Weight';
      case 'maintain_weight':
        return 'Maintain Weight';
      default:
        return g;
    }
  }

  String _fmtActivity(String? a) {
    switch (a) {
      case 'sedentary':
        return 'Sedentary';
      case 'lightly_active':
        return 'Lightly Active';
      case 'moderately_active':
        return 'Moderately Active';
      case 'very_active':
        return 'Very Active';
      case 'extremely_active':
        return 'Extremely Active';
      default:
        return a ?? 'Not set';
    }
  }

  String _formatValue(dynamic value) {
    if (value == null) return 'Not set';
    if (value is num) {
      if (value == 0) return 'Not set';
      if (value % 1 == 0) return value.toInt().toString();
      return value.toStringAsFixed(1);
    }
    final str = value.toString().trim();
    return str.isEmpty ? 'Not set' : str;
  }

  /// Shows current or target weight with unit label
  String _formatWeight(String rawKey, String unitKey) {
    final data = widget.onboardingData;
    final raw = data[rawKey];
    final unit = data[unitKey]?.toString() ?? 'KG';

    if (raw == null) return 'Not set';
    final num? numVal = raw is num ? raw : num.tryParse(raw.toString());
    if (numVal == null || numVal == 0) return 'Not set';

    final String formatted =
    numVal % 1 == 0 ? numVal.toInt().toString() : numVal.toStringAsFixed(1);
    return '$formatted $unit';
  }

  /// Shows height with unit label
  String _formatHeight() {
    final data = widget.onboardingData;
    final raw = data['heightRaw'];
    final unit = data['heightUnit']?.toString() ?? 'Cm';

    if (raw == null) return 'Not set';
    final num? numVal = raw is num ? raw : num.tryParse(raw.toString());
    if (numVal == null || numVal == 0) return 'Not set';

    final String formatted =
    numVal % 1 == 0 ? numVal.toInt().toString() : numVal.toStringAsFixed(1);
    return '$formatted $unit';
  }

  /// Shows age with unit label
  String _formatAge() {
    final data = widget.onboardingData;
    final age = data['age'];
    final unit = data['ageUnit']?.toString() ?? 'Yrs';

    if (age == null) return 'Not set';
    final num? numVal = age is num ? age : num.tryParse(age.toString());
    if (numVal == null || numVal == 0) return 'Not set';

    return '${numVal.toInt()} $unit';
  }

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut)
        .drive(Tween(begin: 0.0, end: 1.0));
    _slide = CurvedAnimation(parent: _anim, curve: Curves.easeOut)
        .drive(Tween(begin: const Offset(0, 0.08), end: Offset.zero));

    _calorieAnim = IntTween(begin: 0, end: _cals).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _anim.forward();
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final data = widget.onboardingData;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Congratulations, your custom plan is ready',
                          style: TextStyle(
                            fontSize: 15.8.sp,
                            fontFamily: "semibold",
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.7.h),
                  Text(
                    'Here is your personalized nutrition report based on your goals and body details.',
                    style: TextStyle(
                      fontSize: 10.8.sp,
                      fontFamily: "regular",
                      color: Colors.grey[600],
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: 2.6.h),

                  // ── Daily Calorie Card ──
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: 5.w, vertical: 2.4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FAF7),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE6ECE5)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Daily calorie target',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontFamily: "regular",
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 1.6.h),
                        AnimatedBuilder(
                          animation: _calorieAnim,
                          builder: (_, __) => Text(
                            '${_calorieAnim.value}',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontFamily: "semibold",
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF2E7D32),
                              height: 1,
                            ),
                          ),
                        ),
                        SizedBox(height: 0.7.h),
                        Text(
                          'Calories per day',
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            fontFamily: "medium",
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // ── Macro Cards Row 1 ──
                  Row(
                    children: [
                      Expanded(
                        child: _metricCard(
                          title: 'Carbs',
                          value: '${_macros['carbs']}g',
                          subtitle:
                          '${((_macros['carbsPct'] as double) * 100).round()}%',
                          icon: Icons.grain,
                          iconColor: const Color(0xFF2E7D32),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _metricCard(
                          title: 'Protein',
                          value: '${_macros['protein']}g',
                          subtitle:
                          '${((_macros['proteinPct'] as double) * 100).round()}%',
                          icon: Icons.fitness_center,
                          iconColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.4.h),

                  // ── Macro Cards Row 2 ──
                  Row(
                    children: [
                      Expanded(
                        child: _metricCard(
                          title: 'Fats',
                          value: '${_macros['fats']}g',
                          subtitle:
                          '${((_macros['fatsPct'] as double) * 100).round()}%',
                          icon: Icons.opacity,
                          iconColor: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _metricCard(
                          title: 'Health Score',
                          value: '$_healthScore/100',
                          subtitle: 'Based on your plan',
                          icon: Icons.favorite_outline,
                          iconColor: const Color(0xFF56A61F),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // ── Goal Description Card ──
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: 4.5.w, vertical: 2.1.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF7EE),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 11.w,
                          height: 11.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFFDDEED9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.track_changes_rounded,
                            color: const Color(0xFF2E7D32),
                            size: 5.5.w,
                          ),
                        ),
                        SizedBox(width: 3.5.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _goalTitle,
                                style: TextStyle(
                                  fontSize: 11.5.sp,
                                  fontFamily: "semibold",
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2E7D32),
                                ),
                              ),
                              SizedBox(height: 0.6.h),
                              Text(
                                _goalDescription,
                                style: TextStyle(
                                  fontSize: 9.5.sp,
                                  fontFamily: "regular",
                                  color: const Color(0xFF5F6B5F),
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 1.6.h),

                  // ── Plan Summary Accordion ──
                  _accordion(
                    title: 'Plan Summary',
                    expanded: _summaryExpanded,
                    onTap: () =>
                        setState(() => _summaryExpanded = !_summaryExpanded),
                    child: Padding(
                      padding: EdgeInsets.only(top: 1.5.h),
                      child: Column(
                        children: [
                          _summaryRow('Goal', _fmtGoal(_goal)),
                          SizedBox(height: 1.h),
                          _summaryRow(
                            'Timeline',
                            _formatValue(data['timeline']),
                          ),
                          SizedBox(height: 1.h),
                          _summaryRow(
                            'Activity Level',
                            _fmtActivity(data['activityLevel']?.toString()),
                          ),
                          SizedBox(height: 1.h),

                          // Current Weight — from Page2
                          _summaryRow(
                            'Current Weight',
                            _formatWeight('currentWeightRaw', 'currentWeightUnit'),
                          ),
                          SizedBox(height: 1.h),

                          // Target Weight — from Page2
                          _summaryRow(
                            'Target Weight',
                            _formatWeight('targetWeightRaw', 'targetWeightUnit'),
                          ),
                          SizedBox(height: 1.h),

                          // Age — from Page6
                          _summaryRow('Age', _formatAge()),
                          SizedBox(height: 1.h),

                          // Height — from Page6
                          _summaryRow('Height', _formatHeight()),
                          SizedBox(height: 1.h),

                          _summaryRow('Daily Calories', '$_cals kcal'),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // ── Continue Button ──
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>WhatNigeriansAreSayingScreen()),
                            (Route<dynamic>route)=>false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF026F1A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'semibold',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Widget helpers ───────────────────────────────────────────────────────

  Widget _metricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 9.w,
            height: 9.w,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 4.5.w, color: iconColor),
          ),
          SizedBox(height: 1.3.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 10.sp,
              fontFamily: "medium",
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 0.4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: "semibold",
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 0.2.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 8.7.sp,
              fontFamily: "regular",
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _accordion({
    required String title,
    required bool expanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.2.h),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: "semibold",
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            if (expanded) child,
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: "medium",
              color: Colors.grey[600],
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: "medium",
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
