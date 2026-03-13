import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

/// Page 7 — Calorie Target Display
class Page7CalorieTargetDisplay extends StatefulWidget {
  final Map<String, dynamic> onboardingData;
  final Function(bool) onNextEnabled;

  const Page7CalorieTargetDisplay({
    super.key,
    required this.onboardingData,
    required this.onNextEnabled,
  });

  @override
  State<Page7CalorieTargetDisplay> createState() => _Page7CalorieTargetDisplayState();
}

class _Page7CalorieTargetDisplayState extends State<Page7CalorieTargetDisplay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double>  _fade;
  late final Animation<Offset>  _slide;
  late Animation<int> _calorieAnim;

  bool _macroExpanded   = false;
  bool _summaryExpanded = false;

  int    get _cals => widget.onboardingData['dailyCalories'] as int? ?? 2057;
  String get _goal => widget.onboardingData['fitnessGoal']  as String? ?? 'lose_weight';

  Map<String, dynamic> get _macros {
    final Map<String, Map<String, double>> ratios = {
      'lose_weight':     {'protein': 0.30, 'carbs': 0.40, 'fats': 0.30},
      'gain_weight':     {'protein': 0.35, 'carbs': 0.45, 'fats': 0.20},
      'maintain_weight': {'protein': 0.25, 'carbs': 0.50, 'fats': 0.25},
    };
    final r = ratios[_goal] ?? ratios['lose_weight']!;
    return {
      'protein': ((_cals * r['protein']!) / 4).round(),
      'carbs':   ((_cals * r['carbs']!)   / 4).round(),
      'fats':    ((_cals * r['fats']!)    / 9).round(),
      'proteinPct': r['protein']!,
      'carbsPct':   r['carbs']!,
      'fatsPct':    r['fats']!,
    };
  }

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade  = CurvedAnimation(parent: _anim, curve: Curves.easeOut).drive(Tween(begin: 0.0, end: 1.0));
    _slide = CurvedAnimation(parent: _anim, curve: Curves.easeOut)
        .drive(Tween(begin: const Offset(0, 0.08), end: Offset.zero));
    _calorieAnim = IntTween(begin: 0, end: _cals)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));

    widget.onNextEnabled(true); // always enabled
    WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _anim.forward(); });
  }

  @override
  void dispose() { _anim.dispose(); super.dispose(); }

  String _fmtGoal(String g) {
    switch (g) {
      case 'lose_weight':     return 'Lose Weight';
      case 'gain_weight':     return 'Gain Weight';
      case 'maintain_weight': return 'Maintain Weight';
      default:                return g;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Personalized plan',
                  style: GoogleFonts.poppins(
                      fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.black)),
              SizedBox(height: 0.5.h),
              Text('This is your personalized plan and summary of your target and details',
                  style: GoogleFonts.poppins(fontSize: 11.5.sp, color: Colors.grey[600])),
              SizedBox(height: 3.h),

              // Calorie card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 3.h,),
                    Text('Your Daily Calorie Target',
                        style: GoogleFonts.poppins(
                            fontSize: 11.7.sp, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                    SizedBox(height: 3.h),
                    AnimatedBuilder(
                      animation: _calorieAnim,
                      builder: (_, __) => Text(
                        '${_calorieAnim.value}',
                        style: GoogleFonts.poppins(
                            fontSize: 29.sp, fontWeight: FontWeight.w800,
                            color: const Color(0xFF2E7D32), height: 1),
                      ),
                    ),
                    SizedBox(height: 2.h,),
                    Text('Calories',
                        style: GoogleFonts.poppins(
                            fontSize: 11.7.sp, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                    SizedBox(height: 3.h,),
                  ],
                ),
              ),
              SizedBox(height: 1.5.h),

              // Macro Breakdown accordion
              _accordion(
                title: 'Macro Breakdown',
                expanded: _macroExpanded,
                onTap: () => setState(() => _macroExpanded = !_macroExpanded),
                child: Column(
                  children: [
                    SizedBox(height: 1.5.h),
                    _macroRow('Protein', _macros['protein'] as int, _macros['proteinPct'] as double, Colors.orange),
                    SizedBox(height: 1.h),
                    _macroRow('Carbs',   _macros['carbs']   as int, _macros['carbsPct']   as double, const Color(0xFF2E7D32)),
                    SizedBox(height: 1.h),
                    _macroRow('Fats',    _macros['fats']    as int, _macros['fatsPct']    as double, Colors.blue),
                  ],
                ),
              ),
              SizedBox(height: 1.5.h),

              // Plan Summary accordion
              _accordion(
                title: 'Plan Summary',
                expanded: _summaryExpanded,
                onTap: () => setState(() => _summaryExpanded = !_summaryExpanded),
                child: Padding(
                  padding: EdgeInsets.only(top: 1.5.h),
                  child: Column(
                    children: [
                      _summaryRow('Goal',           _fmtGoal(_goal)),
                      SizedBox(height: 1.h),
                      _summaryRow('Timeline',       widget.onboardingData['timeline']?.toString()       ?? 'Not set'),
                      SizedBox(height: 1.h),
                      _summaryRow('Activity Level', widget.onboardingData['activityLevel']?.toString()  ?? 'Not set'),
                      SizedBox(height: 1.h),
                      _summaryRow('Daily Calories', '$_cals kcal'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
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
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.3.h),
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
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF2E7D32))),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF2E7D32)),
                ),
              ],
            ),
            if (expanded) child,
          ],
        ),
      ),
    );
  }

  Widget _macroRow(String name, int grams, double pct, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 18.w,
          child: Text(name, style: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.w600)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct, minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Text('${grams}g', style: GoogleFonts.poppins(fontSize: 10.sp, color: Colors.grey[600])),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 11.sp, color: Colors.grey[600])),
        Text(value,  style: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.w600, color: Colors.black87)),
      ],
    );
  }
}
