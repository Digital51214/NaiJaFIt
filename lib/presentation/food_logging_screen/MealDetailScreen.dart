import 'package:flutter/material.dart';
import 'package:naijafit/presentation/ConfirmPortionScreen.dart';
import 'package:naijafit/presentation/Foodconsumedscreen.dart';

class MealDetailScreen extends StatefulWidget {
  final Map<String, dynamic> food;

  // isEditMode = true  → MealHistory se aaya (save karo wapas)
  // isEditMode = false → FoodLogging se aaya (log mein add karo)
  final bool isEditMode;

  const MealDetailScreen({
    super.key,
    required this.food,
    this.isEditMode = false,
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  late String _selectedServingSize;
  double _servings = 1.0;

  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _selectedServingSize = widget.food['servingSize'] as String;
    _nameController =
        TextEditingController(text: widget.food['name'] as String);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  double get _calories => (widget.food['calories'] as int) * _servings;
  double get _protein => (widget.food['protein'] as double) * _servings;
  double get _carbs => (widget.food['carbs'] as double) * _servings;
  double get _fats => (widget.food['fats'] as double) * _servings;

  // ── Edit mode: Save karo aur updated data wapas bhejo ──
  void _saveEdited() {
    final updatedMeal = Map<String, dynamic>.from(widget.food);
    updatedMeal['name'] = _nameController.text.trim();
    updatedMeal['kcal'] = '${_calories.toStringAsFixed(0)} kcal';
    updatedMeal['servingSize'] = _selectedServingSize;
    updatedMeal['calories'] = (widget.food['calories'] as int);
    Navigator.pop(context, updatedMeal);
  }

  // ── View mode: PortionVisualizerScreen pe jao ──
  void _addToLog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PortionVisualizerScreen(
          food: widget.food, // ✅ fixed: widget.food
        ),
      ),
    );
  }
  void _addToLog2() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodConsumedScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final String tag =
        (widget.food['tag'] as String?) ?? 'HEALTHY NIGERIAN MEAL';
    final String imagePath = widget.food['image'] as String;

    final bool isNetworkImage =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, height * 0.022, width * 0.05, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF4EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chevron_left_rounded,
                          color: Color(0xFF1B7F3A), size: 26),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.isEditMode ? 'Edit Meal' : 'Meal Detail',
                      style: const TextStyle(
                        fontSize: 22,
                        fontFamily: "semibold",
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Image.asset('assets/images/LOGO.png',
                      height: width * 0.15, width: width * 0.15),
                ],
              ),
            ),

            // ── Scrollable Content ──────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  right: width * 0.05,
                  top: height * 0.020,
                  bottom: height * 0.020,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Hero Image ─────────────────────────
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            width: double.infinity,
                            height: height * 0.285,
                            child: isNetworkImage
                                ? Image.network(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _imageFallback(),
                            )
                                : Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _imageFallback(),
                            ),
                          ),
                        ),
                        // Calorie badge
                        Positioned(
                          bottom: 14,
                          right: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B7F3A),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              '${_calories.toStringAsFixed(0)} kcal',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: "extrabold",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: height * 0.022),

                    // ── Tag ────────────────────────────────
                    Text(
                      tag,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1B7F3A),
                          fontFamily: "semibold",
                          letterSpacing: 1.2),
                    ),

                    SizedBox(height: height * 0.008),

                    // ── Meal Name ──────────────────────────
                    widget.isEditMode
                        ? TextField(
                      controller: _nameController,
                      style: const TextStyle(
                          fontSize: 24,
                          fontFamily: "regular",
                          fontWeight: FontWeight.w800,
                          color: Colors.black87),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        hintText: 'Meal name',
                        hintStyle: const TextStyle(
                            color: Colors.black38,fontFamily: "regular", fontSize: 20),
                        filled: true,
                        fillColor: const Color(0xFFF5FAF6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: Color(0xFF1B7F3A), width: 1.5),
                        ),
                      ),
                    )
                        : Text(
                      widget.food['name'] as String,
                      style: const TextStyle(
                          fontSize: 24,
                          fontFamily: "semibold",
                          fontWeight: FontWeight.w800,
                          color: Colors.black87),
                    ),

                    SizedBox(height: height * 0.016),

                    // ── Macro Cards ────────────────────────
                    Row(
                      children: [
                        Expanded(
                            child: _macroCard(
                                'CARBS', '${_carbs.toStringAsFixed(0)}g')),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _macroCard(
                                'Protein', '${_protein.toStringAsFixed(0)}g')),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _macroCard(
                                'Fats', '${_fats.toStringAsFixed(0)}g')),
                      ],
                    ),

                    SizedBox(height: height * 0.022),

                    // ── Serving Size Selector ──────────────
                    const Text('Serving Size',
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "medium",
                            fontWeight: FontWeight.w700,
                            color: Colors.black87)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                      (widget.food['servingOptions'] as List<dynamic>)
                          .cast<String>()
                          .map((option) {
                        final isSelected = option == _selectedServingSize;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedServingSize = option),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 9),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1B7F3A)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF1B7F3A)
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              option,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "medium",
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: height * 0.022),

                    // ── Number of Servings ─────────────────
                    const Text('Number of Servings',
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "medium",
                            fontWeight: FontWeight.w700,
                            color: Colors.black87)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _circleButton(
                          icon: Icons.remove,
                          onTap: () => setState(() {
                            if (_servings > 0.5) _servings -= 0.5;
                          }),
                          filled: false,
                        ),
                        const SizedBox(width: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            _servings.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 20,
                                fontFamily: "extrabold",
                                fontWeight: FontWeight.w700,
                                color: Colors.black87),
                          ),
                        ),
                        const SizedBox(width: 24),
                        _circleButton(
                          icon: Icons.add,
                          onTap: () => setState(() {
                            if (_servings < 10.0) _servings += 0.5;
                          }),
                          filled: true,
                        ),
                      ],
                    ),

                    SizedBox(height: height * 0.022),

                    // ── Portion Visualizer ─────────────────
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PortionVisualizerScreen(
                              food: widget.food, // ✅ correct
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 55,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Portion Visualizer',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "semibold",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54)),
                            Icon(Icons.chevron_right_rounded,
                                color: Colors.black38, size: 30),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.030),
                  ],
                ),
              ),
            ),

            // ── Bottom Button ──────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, 0, width * 0.05, height * 0.025),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: widget.isEditMode ? _saveEdited : _addToLog2,
                  icon: Icon(
                    widget.isEditMode ? Icons.check_rounded : Icons.add,
                    size: 22,
                    color: Colors.white,
                  ),
                  label: Text(
                    widget.isEditMode ? 'Save Changes' : 'Add Meal to Log',
                    style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "extrabold",
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B7F3A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback() => Container(
    color: const Color(0xFFE8F5E9),
    child:
    const Icon(Icons.restaurant, size: 60, color: Color(0xFF2E7D32)),
  );

  Widget _macroCard(String label, String value) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FAF6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 9,
                  fontFamily: "regular",
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                  letterSpacing: 0.8)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 18,
                  fontFamily: "medium",
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B7F3A))),
        ],
      ),
    );
  }

  Widget _circleButton(
      {required IconData icon,
        required VoidCallback onTap,
        required bool filled}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF1B7F3A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color:
              filled ? const Color(0xFF1B7F3A) : Colors.grey.shade300),
          boxShadow: filled
              ? [
            BoxShadow(
                color: const Color(0xFF1B7F3A).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ]
              : [],
        ),
        child: Icon(icon,
            size: 22, color: filled ? Colors.white : Colors.black87),
      ),
    );
  }
}