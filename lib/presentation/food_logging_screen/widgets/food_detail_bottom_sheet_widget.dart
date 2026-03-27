import 'package:flutter/material.dart';

class FoodDetailBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> food;
  final Function(Map<String, dynamic>, String, double) onAdd;

  const FoodDetailBottomSheetWidget({
    super.key,
    required this.food,
    required this.onAdd,
  });

  @override
  State<FoodDetailBottomSheetWidget> createState() =>
      _FoodDetailBottomSheetWidgetState();
}

class _FoodDetailBottomSheetWidgetState
    extends State<FoodDetailBottomSheetWidget> {
  late String _selectedServingSize;
  double _servings = 1.0;

  @override
  void initState() {
    super.initState();
    _selectedServingSize = widget.food['servingSize'] as String;
  }

  void _increment() => setState(() {
    if (_servings < 10.0) _servings += 0.5;
  });

  void _decrement() => setState(() {
    if (_servings > 0.5) _servings -= 0.5;
  });

  double get _calories => (widget.food['calories'] as int) * _servings;
  double _macro(String key) => (widget.food[key] as double) * _servings;

  @override
  Widget build(BuildContext context) {
    final servingOptions =
    (widget.food['servingOptions'] as List).cast<String>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.food['name'] as String,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  widget.food['image'] as String,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: const Color(0xFFE8F5E9),
                    child: const Icon(
                      Icons.restaurant,
                      size: 48,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Serving Size',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  fontFamily: "Poppins",
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: servingOptions.map((option) {
                  final isSelected = option == _selectedServingSize;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedServingSize = option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2E7D32)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2E7D32)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected ? Colors.white : Colors.black87,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              const Text(
                'Number of Servings',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  fontFamily: "Poppins",
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _circleButton(
                    icon: Icons.remove,
                    onTap: _decrement,
                    filled: false,
                  ),
                  const SizedBox(width: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      _servings.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  _circleButton(
                    icon: Icons.add,
                    onTap: _increment,
                    filled: true,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nutrition Information',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(height: 12),
                    _nutritionRow(
                      'Calories',
                      '${_calories.toStringAsFixed(0)} cal',
                      highlight: true,
                    ),
                    const SizedBox(height: 8),
                    _nutritionRow(
                      'Protein',
                      '${_macro("protein").toStringAsFixed(1)}g',
                    ),
                    const SizedBox(height: 8),
                    _nutritionRow(
                      'Carbs',
                      '${_macro("carbs").toStringAsFixed(1)}g',
                    ),
                    const SizedBox(height: 8),
                    _nutritionRow(
                      'Fats',
                      '${_macro("fats").toStringAsFixed(1)}g',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => widget.onAdd(
                    widget.food,
                    _selectedServingSize,
                    _servings,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Add to Food Log',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool filled,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF2E7D32) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: filled ? const Color(0xFF2E7D32) : Colors.grey.shade300,
          ),
          boxShadow: filled
              ? [
            BoxShadow(
              color: const Color(0xFF2E7D32).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ]
              : [],
        ),
        child: Icon(
          icon,
          size: 22,
          color: filled ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _nutritionRow(String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
            fontFamily: "Poppins",
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: highlight ? const Color(0xFF2E7D32) : Colors.black87,
            fontFamily: "Poppins",
          ),
        ),
      ],
    );
  }
}