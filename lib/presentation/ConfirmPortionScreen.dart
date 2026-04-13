import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naijafit/presentation/Foodconsumedscreen.dart';
import 'package:naijafit/presentation/food_logging_screen/MealDetailScreen.dart';

class PortionVisualizerScreen extends StatefulWidget {
  final Map<String, dynamic> food;

  const PortionVisualizerScreen({super.key, required this.food});

  @override
  State<PortionVisualizerScreen> createState() =>
      _PortionVisualizerScreenState();
}

class _PortionVisualizerScreenState extends State<PortionVisualizerScreen>
    with SingleTickerProviderStateMixin {

  final List<String> _portionLabels = [
    'Half Plate',
    'Standard',
    'Big Chop',
    'Double',
  ];

  final List<double> _portionMultipliers = [0.5, 1.0, 1.5, 2.0];

  int _selectedPortionIndex = 1;

  double get _sliderValue => _selectedPortionIndex.toDouble();

  double get _multiplier => _portionMultipliers[_selectedPortionIndex];

  int get _currentCalories =>
      ((widget.food['calories'] as int) * _multiplier).round();

  double get _currentProtein =>
      (widget.food['protein'] as double) * _multiplier;

  double get _currentFats => (widget.food['fats'] as double) * _multiplier;

  double get _currentCarbs => (widget.food['carbs'] as double) * _multiplier;

  int get _densityPercent {
    final total = _currentProtein + _currentFats + _currentCarbs;
    if (total == 0) return 0;
    return ((_currentCarbs / total) * 100).round();
  }

  // // ✅ FIXED: MealDetailScreen hata ke FoodConsumedScreen pe navigate karo
  // void _confirmPortion() {
  //   HapticFeedback.mediumImpact();
  //
  //   const int dailyTarget = 2000;
  //   final int remaining = dailyTarget - _currentCalories;
  //
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => FoodConsumedScreen(
  //         mealName: widget.food['name'] as String,
  //         mealTime: '${_portionLabels[_selectedPortionIndex]} • Logged',
  //         consumedCalories: _currentCalories,
  //         remainingCalories: remaining < 0 ? 0 : remaining,
  //         protein: _currentProtein,
  //         carbs: _currentCarbs,
  //         savedCalories: remaining < 0 ? 0 : remaining,
  //         savePercent: remaining > 0 ? remaining / dailyTarget : 0.0,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final String imagePath = widget.food['image'] as String? ?? '';
    final bool isNetwork =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(w * 0.05, h * 0.022, w * 0.05, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: h * 0.062,
                      height: h * 0.062,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF4EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: Color(0xFF1B7F3A),
                        size: 30,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/LOGO.png',
                    width: h * 0.08,
                    height: w * 0.18,
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.015),

            // ── Food Image with plate ring + calorie badge ──
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  width: 158,
                  height: 158,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: imagePath.isEmpty
                        ? Container(
                      color: const Color(0xFFE8F5E9),
                      child: const Icon(Icons.restaurant,
                          size: 60, color: Color(0xFF2E7D32)),
                    )
                        : isNetwork
                        ? Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFE8F5E9),
                        child: const Icon(Icons.restaurant,
                            size: 60, color: Color(0xFF2E7D32)),
                      ),
                    )
                        : Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFE8F5E9),
                        child: const Icon(Icons.restaurant,
                            size: 60, color: Color(0xFF2E7D32)),
                      ),
                    ),
                  ),
                ),

                // Calorie Badge
                Positioned(
                  bottom: w * -0.035,
                  right: w * -0.02,
                  child: AnimatedContainer(
                    height: 35,
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 0.03, vertical: h * 0.002),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B7F3A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$_currentCalories',
                              style: TextStyle(
                                fontSize: w * 0.036,
                                fontFamily: "bold",
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: ' kcal',
                              style: TextStyle(
                                fontSize: w * 0.023,
                                fontFamily: "regular",
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: h * 0.04),

            // ── Portion Card ────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: h * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Portion Labels Row
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(_portionLabels.length, (i) {
                          final isSelected = i == _selectedPortionIndex;
                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() => _selectedPortionIndex = i);
                            },
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                fontSize: w * 0.035,
                                fontFamily: "regular",
                                fontWeight: isSelected
                                    ? FontWeight.w800
                                    : FontWeight.w400,
                                color: isSelected
                                    ? const Color(0xFF1B7F3A)
                                    : Colors.black45,
                              ),
                              child: Text(_portionLabels[i]),
                            ),
                          );
                        }),
                      ),
                    ),

                    SizedBox(height: h * 0.01),

                    // Slider
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF1B7F3A),
                        inactiveTrackColor: Colors.grey.shade200,
                        thumbColor: const Color(0xFF1B7F3A),
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 12),
                        trackHeight: 8,
                        overlayColor:
                        const Color(0xFF1B7F3A).withOpacity(0.15),
                        overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 22),
                      ),
                      child: Slider(
                        value: _sliderValue,
                        min: 0,
                        max: 3,
                        divisions: 3,
                        onChanged: (val) {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedPortionIndex = val.round());
                        },
                      ),
                    ),

                    SizedBox(height: h * 0.02),

                    // 3 Info Cards
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                      child: Row(
                        children: [
                          Expanded(
                            child: _InfoCard(
                              icon: Icons.water_drop_outlined,
                              label: 'Density',
                              value: '$_densityPercent%',
                              subLabel: 'Complex Carbs',
                              isHighlighted: true,
                              w: w,
                              h: h,
                            ),
                          ),
                          SizedBox(width: w * 0.03),
                          Expanded(
                            child: _InfoCard(
                              icon: Icons.fitness_center_rounded,
                              label: 'Protein',
                              value: '${_currentProtein.toStringAsFixed(0)}g',
                              subLabel: 'Muscle Growth',
                              isHighlighted: false,
                              w: w,
                              h: h,
                            ),
                          ),
                          SizedBox(width: w * 0.03),
                          Expanded(
                            child: _InfoCard(
                              icon: Icons.eco_outlined,
                              label: 'Fats',
                              value: '${_currentFats.toStringAsFixed(0)}g',
                              subLabel: 'Healthy Oils',
                              isHighlighted: false,
                              w: w,
                              h: h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Confirm Portion → FoodConsumedScreen
            Padding(
              padding: EdgeInsets.fromLTRB(
                  w * 0.05, h * 0.04, w * 0.05, h * 0.03),
              child: SizedBox(
                width: double.infinity,
                height: h * 0.058,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MealDetailScreen(food: widget.food)),
                        (Route<dynamic>route)=>false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B7F3A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 2),
                  ),
                  child: Text(
                    'Confirm Portion',
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontFamily: "extrabold",
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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

// ─────────────────────────────────────────────────────────────
// Info Card Widget
// ─────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subLabel;
  final bool isHighlighted;
  final double w;
  final double h;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subLabel,
    required this.isHighlighted,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor =
    isHighlighted ? const Color(0xFFD6EDD9) : const Color(0xFFF5FAF6);
    final Color iconColor = const Color(0xFF1B7F3A);
    final Color textColor =
    isHighlighted ? const Color(0xFF1B7F3A) : Colors.black87;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding:
      EdgeInsets.symmetric(vertical: h * 0.018, horizontal: w * 0.02),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlighted
              ? const Color(0xFF1B7F3A).withOpacity(0.15)
              : Colors.grey.shade100,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: w * 0.10,
            height: w * 0.10,
            decoration: BoxDecoration(
              color:
              isHighlighted ? const Color(0xFFB8DDB8) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: w * 0.048, color: iconColor),
          ),
          SizedBox(height: h * 0.010),
          Text(
            label,
            style: TextStyle(
              fontSize: w * 0.030,
              fontFamily: "regular",
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: h * 0.004),
          Text(
            value,
            style: TextStyle(
              fontSize: w * 0.048,
              fontFamily: "medium",
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          SizedBox(height: h * 0.003),
          Text(
            subLabel,
            style: TextStyle(
              fontSize: w * 0.026,
              fontFamily: "regular",
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1B7F3A),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
