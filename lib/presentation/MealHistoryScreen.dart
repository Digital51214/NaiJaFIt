import 'package:flutter/material.dart';
import 'package:naijafit/presentation/food_logging_screen/MealDetailScreen.dart';

class MealHistoryScreen extends StatefulWidget {
  const MealHistoryScreen({super.key});

  @override
  State<MealHistoryScreen> createState() => _MealHistoryScreenState();
}

class _MealHistoryScreenState extends State<MealHistoryScreen> {
  // ── Today meals — StatefulWidget mein taake edit se update ho ──
  List<Map<String, dynamic>> _todayMeals = [
    {
      'mealType': 'BREAKFAST',
      'name': 'Jollof Rice',
      'kcal': '400 kcal',
      'calories': 400,
      'protein': 12.0,
      'carbs': 52.0,
      'fats': 14.0,
      'servingSize': '1 plate',
      'servingOptions': ['1 plate', '2 plates', 'Half plate'],
      'tag': 'HEALTHY NIGERIAN BREAKFAST',
      'image': 'assets/images/breakfast1.png',
    },
    {
      'mealType': 'LUNCH',
      'name': 'Chicken Rice',
      'kcal': '600 kcal',
      'calories': 600,
      'protein': 28.0,
      'carbs': 60.0,
      'fats': 18.0,
      'servingSize': '1 plate',
      'servingOptions': ['1 plate', '2 plates', 'Half plate'],
      'tag': 'HEALTHY NIGERIAN LUNCH',
      'image': 'assets/images/lunch.png',
    },
    {
      'mealType': 'DINNER',
      'name': 'Yam',
      'kcal': '500 kcal',
      'calories': 500,
      'protein': 6.0,
      'carbs': 70.0,
      'fats': 8.0,
      'servingSize': '1 bowl',
      'servingOptions': ['1 bowl', '2 bowls', 'Half bowl'],
      'tag': 'HEALTHY NIGERIAN DINNER',
      'image': 'assets/images/dinner.png',
    },
  ];

  // ── Total kcal dynamically calculate ──
  int get _totalKcal {
    int total = 0;
    for (var meal in _todayMeals) {
      final raw = (meal['kcal'] as String).replaceAll(RegExp(r'[^0-9]'), '');
      total += int.tryParse(raw) ?? 0;
    }
    return total;
  }

  // ── Edit icon → MealDetailScreen (edit mode) → updated data wapas ──
  Future<void> _openEditScreen(int index) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => MealDetailScreen(
          food: Map<String, dynamic>.from(_todayMeals[index]),
          isEditMode: true,
        ),
      ),
    );
    if (result != null) {
      setState(() => _todayMeals[index] = result);
    }
  }

  // ── Delete meal ──
  void _deleteMeal(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Meal',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text(
            'Are you sure you want to delete "${_todayMeals[index]['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.black54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _todayMeals.removeAt(index));
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                  w * 0.05, h * 0.022, w * 0.05, h * 0.010),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: w * 0.115,
                      height: w * 0.115,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF4EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chevron_left_rounded,
                          color: Color(0xFF1B7F3A), size: 26),
                    ),
                  ),
                  SizedBox(width: w * 0.04),
                  Expanded(
                    child: Text(
                      'Meal History',
                      style: TextStyle(
                        fontSize: w * 0.062,
                        fontFamily: "semibold",
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Image.asset('assets/images/LOGO.png',
                      width: w * 0.17, height: w * 0.17),
                ],
              ),
            ),

            // ── Scrollable Body ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.010),

                    // ── TODAY ──────────────────────────────────────
                    _DaySectionHeader(
                      label: 'Today',
                      kcal: 'Total: $_totalKcal kcal',
                      isToday: true,
                      w: w,
                      h: h,
                    ),
                    SizedBox(height: h * 0.012),

                    // Dynamic today meal cards
                    ...List.generate(_todayMeals.length, (i) {
                      final meal = _todayMeals[i];
                      return Padding(
                        padding: EdgeInsets.only(bottom: h * 0.012),
                        child: _MealCardLarge(
                          mealType: meal['mealType'] as String,
                          name: meal['name'] as String,
                          kcal: meal['kcal'] as String,
                          image: meal['image'] as String,
                          w: w,
                          h: h,
                          onEditTap: () => _openEditScreen(i),
                          onDeleteTap: () => _deleteMeal(i),
                        ),
                      );
                    }),

                    SizedBox(height: h * 0.015),

                    // ── YESTERDAY ──────────────────────────────────
                    _DaySectionHeader(
                      label: 'Yesterday',
                      kcal: '1240 kcal',
                      isToday: false,
                      w: w,
                      h: h,
                    ),
                    SizedBox(height: h * 0.012),
                    _MealCardCompactGroup(
                      meals: const [
                        {'name': 'Pounded Yam', 'kcal': '', 'icon': 'food'},
                        {'name': 'Fruit Salad', 'kcal': '440 kcal', 'icon': 'drink'},
                      ],
                      w: w,
                      h: h,
                    ),

                    SizedBox(height: h * 0.025),

                    // ── MONDAY ─────────────────────────────────────
                    _DaySectionHeader(
                      label: 'Monday',
                      kcal: '1240 kcal',
                      isToday: false,
                      w: w,
                      h: h,
                      labelColor: const Color(0xFF1B7F3A),
                    ),
                    SizedBox(height: h * 0.012),
                    _MealCardSingleCompact(name: 'Pounded Yam', w: w, h: h),

                    SizedBox(height: h * 0.030),
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

// ──────────────────────────────────────────────────────────────
// Day Section Header
// ──────────────────────────────────────────────────────────────
class _DaySectionHeader extends StatelessWidget {
  final String label;
  final String kcal;
  final bool isToday;
  final double w;
  final double h;
  final Color labelColor;

  const _DaySectionHeader({
    required this.label,
    required this.kcal,
    required this.isToday,
    required this.w,
    required this.h,
    this.labelColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: w * 0.048,
            fontFamily: "semibold",
            fontWeight: FontWeight.w800,
            color: isToday ? const Color(0xFF1B7F3A) : labelColor,
          ),
        ),
        isToday
            ? Container(
          padding: EdgeInsets.symmetric(
              horizontal: w * 0.038, vertical: h * 0.006),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4EC),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            kcal,
            style: TextStyle(
              fontSize: w * 0.033,
              fontFamily: "medium",
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1B7F3A),
            ),
          ),
        )
            : Text(
          kcal,
          style: TextStyle(
            fontSize: w * 0.038,
            fontFamily: "medium",
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Large Meal Card with edit/delete callbacks
// ──────────────────────────────────────────────────────────────
class _MealCardLarge extends StatelessWidget {
  final String mealType;
  final String name;
  final String kcal;
  final String image;
  final double w;
  final double h;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const _MealCardLarge({
    required this.mealType,
    required this.name,
    required this.kcal,
    required this.image,
    required this.w,
    required this.h,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: h * 0.115,
      padding: EdgeInsets.symmetric(
          horizontal: w * 0.038, vertical: h * 0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: SizedBox(
              width: w * 0.15,
              height: w * 0.15,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFE8F5E9),
                  child: const Icon(Icons.restaurant,
                      size: 30, color: Color(0xFF2E7D32)),
                ),
              ),
            ),
          ),
          SizedBox(width: w * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(mealType,
                    style: TextStyle(
                        fontSize: w * 0.028,
                        fontFamily: "regular",
                        fontWeight: FontWeight.w500,
                        color: Colors.black45,
                        letterSpacing: 0.8)),
                SizedBox(height: h * 0.004),
                Text(name,
                    style: TextStyle(
                        fontSize: w * 0.048,
                        fontFamily: "semibold",
                        fontWeight: FontWeight.w800,
                        color: Colors.black87)),
                SizedBox(height: h * 0.004),
                Text(kcal,
                    style: TextStyle(
                        fontSize: w * 0.036,
                        fontFamily: "regular",
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1B7F3A))),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onEditTap,
                child: Icon(Icons.edit_outlined,
                    size: w * 0.055, color: Colors.black38),
              ),
              SizedBox(height: h * 0.018),
              GestureDetector(
                onTap: onDeleteTap,
                child: Icon(Icons.delete,
                    size: w * 0.055, color: Colors.black38),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Compact Group Card (Yesterday)
// ──────────────────────────────────────────────────────────────
class _MealCardCompactGroup extends StatelessWidget {
  final List<Map<String, String>> meals;
  final double w;
  final double h;

  const _MealCardCompactGroup(
      {required this.meals, required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: w * 0.05, vertical: h * 0.018),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4EC).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: meals.asMap().entries.map((e) {
          final idx = e.key;
          final meal = e.value;
          return Column(
            children: [
              _CompactMealRow(
                  name: meal['name']!,
                  kcal: meal['kcal']!,
                  iconType: meal['icon']!,
                  w: w,
                  h: h),
              if (idx < meals.length - 1) SizedBox(height: h * 0.014),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _CompactMealRow extends StatelessWidget {
  final String name;
  final String kcal;
  final String iconType;
  final double w;
  final double h;

  const _CompactMealRow(
      {required this.name,
        required this.kcal,
        required this.iconType,
        required this.w,
        required this.h});

  @override
  Widget build(BuildContext context) {
    final icon = iconType == 'drink'
        ? Icons.local_cafe_outlined
        : Icons.restaurant_menu_outlined;
    return Row(
      children: [
        Container(
          width: w * 0.11,
          height: w * 0.11,
          decoration: const BoxDecoration(
              color: Color(0xFFD2EBD8), shape: BoxShape.circle),
          child: Icon(icon, size: w * 0.055, color: const Color(0xFF1B7F3A)),
        ),
        SizedBox(width: w * 0.038),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(
                      fontSize: w * 0.042,
                      fontFamily: "semibold",
                      fontWeight: FontWeight.w700,
                      color: Colors.black87)),
              if (kcal.isNotEmpty)
                Text(kcal,
                    style: TextStyle(
                        fontSize: w * 0.034,
                        fontFamily: "regular",
                        fontWeight: FontWeight.w500,
                        color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Monday single compact item
// ──────────────────────────────────────────────────────────────
class _MealCardSingleCompact extends StatelessWidget {
  final String name;
  final double w;
  final double h;

  const _MealCardSingleCompact(
      {required this.name, required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: h * 0.066,
      width: double.infinity,
      padding:
      EdgeInsets.symmetric(horizontal: h * 0.02, vertical: h * 0.01),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4EC).withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Container(
            width: w * 0.11,
            height: w * 0.11,
            decoration: const BoxDecoration(
                color: Color(0xFFEAF4EC), shape: BoxShape.circle),
            child: Icon(Icons.restaurant_menu_outlined,
                size: w * 0.055,
                color: const Color(0xFF1B7F3A).withOpacity(0.5)),
          ),
          SizedBox(width: w * 0.038),
          Text(name,
              style: TextStyle(
                  fontSize: w * 0.042,
                  fontFamily: "semibold",
                  fontWeight: FontWeight.w600,
                  color: Colors.black45)),
        ],
      ),
    );
  }
}
