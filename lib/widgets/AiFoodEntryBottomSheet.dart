import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// ─────────────────────────────────────────────────────────────────
///  AI Food Entry Bottom Sheet
///  Usage:
///    showModalBottomSheet(
///      context: context,
///      isScrollControlled: true,
///      backgroundColor: Colors.transparent,
///      builder: (_) => AiFoodEntryBottomSheet(
///        onFoodAdded: (food) { /* add to your list */ },
///      ),
///    );
/// ─────────────────────────────────────────────────────────────────

class AiFoodEntryBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onFoodAdded;

  const AiFoodEntryBottomSheet({
    super.key,
    required this.onFoodAdded,
  });

  @override
  State<AiFoodEntryBottomSheet> createState() => _AiFoodEntryBottomSheetState();
}

class _AiFoodEntryBottomSheetState extends State<AiFoodEntryBottomSheet> {
  // ── Controllers ──────────────────────────────
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController  = TextEditingController();
  final TextEditingController _carbsController    = TextEditingController();
  final TextEditingController _fatController      = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _aiDataFetched = false;

  // ── Anthropic API Call ────────────────────────
  Future<void> _askAI() async {
    final foodName = _foodNameController.text.trim();
    if (foodName.isEmpty) {
      setState(() => _errorMessage = 'Please enter a food name first');
      return;
    }

    setState(() {
      _isLoading     = true;
      _errorMessage  = null;
      _aiDataFetched = false;
    });

    const String apiKey = 'YOUR_ANTHROPIC_API_KEY'; // 🔑 Replace with your key

    try {
      final response = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {
          'Content-Type':      'application/json',
          'x-api-key':         apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model':      'claude-haiku-4-5-20251001',
          'max_tokens': 300,
          'messages': [
            {
              'role':    'user',
              'content': '''You are a nutrition expert. 
Give me the nutritional information for: "$foodName" (per typical single serving).

Reply ONLY with a valid JSON object — no explanation, no markdown, no extra text.
Format:
{
  "calories": <number>,
  "protein": <number in grams>,
  "carbs": <number in grams>,
  "fat": <number in grams>,
  "serving": "<serving description>"
}''',
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data    = jsonDecode(response.body);
        final content = data['content'][0]['text'] as String;

        // Strip any accidental markdown fences
        final clean = content
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        final nutrition = jsonDecode(clean) as Map<String, dynamic>;

        setState(() {
          _caloriesController.text = nutrition['calories'].toString();
          _proteinController.text  = nutrition['protein'].toString();
          _carbsController.text    = nutrition['carbs'].toString();
          _fatController.text      = nutrition['fat'].toString();
          _aiDataFetched           = true;
          _isLoading               = false;
        });
      } else {
        setState(() {
          _errorMessage = 'AI error: ${response.statusCode}. Try again.';
          _isLoading    = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection error. Check internet & try again.';
        _isLoading    = false;
      });
    }
  }

  // ── Add Food ──────────────────────────────────
  void _addFood() {
    final name     = _foodNameController.text.trim();
    final calories = int.tryParse(_caloriesController.text.trim()) ?? 0;
    final protein  = double.tryParse(_proteinController.text.trim()) ?? 0.0;
    final carbs    = double.tryParse(_carbsController.text.trim()) ?? 0.0;
    final fat      = double.tryParse(_fatController.text.trim()) ?? 0.0;

    if (name.isEmpty) {
      setState(() => _errorMessage = 'Food name is required');
      return;
    }
    if (calories == 0) {
      setState(() => _errorMessage = 'Please fill nutrition info first');
      return;
    }

    final food = {
      'name':         name,
      'calories':     calories,
      'protein':      protein,
      'carbs':        carbs,
      'fats':         fat,
      'servingSize':  '1 serving',
      'servingOptions': ['1 serving'],
      'category':    'Custom',
      'region':      'Custom',
      'image':       'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
    };

    widget.onFoodAdded(food);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Drag Handle ──
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Title ──
            const Text(
              'Add Custom Food',
              style: TextStyle(
                fontFamily: 'semibold',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Enter food name and let AI fill the nutrition details',
              style: TextStyle(
                fontFamily: 'regular',
                fontSize: 12,
                color: Colors.black45,
              ),
            ),
            const SizedBox(height: 20),

            // ── Food Name + Ask AI Row ──
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _foodNameController,
                    label:       'Food Name',
                    hint:        'e.g. Jollof Rice',
                    icon:        Icons.restaurant,
                    inputType:   TextInputType.text,
                  ),
                ),
                const SizedBox(width: 10),
                // Ask AI Button
                GestureDetector(
                  onTap: _isLoading ? null : _askAI,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: _isLoading
                          ? Colors.grey.shade300
                          : const Color(0xFF1B7F3A),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: _isLoading
                          ? []
                          : [
                        BoxShadow(
                          color: const Color(0xFF1B7F3A).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Row(
                      children: const [
                        Icon(Icons.auto_awesome,
                            color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Ask AI',
                          style: TextStyle(
                            fontFamily: 'semibold',
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── AI Success Banner ──
            if (_aiDataFetched) ...[
              const SizedBox(height: 10),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF56B327), width: 1),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.check_circle,
                        color: Color(0xFF2E7D32), size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AI filled the nutrition info! You can edit if needed.',
                        style: TextStyle(
                          fontFamily: 'regular',
                          fontSize: 11,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ── Error Message ──
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.redAccent, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          fontFamily: 'regular',
                          fontSize: 11,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // ── Nutrition Grid (2 columns) ──
            const Text(
              'Nutrition Info (per serving)',
              style: TextStyle(
                fontFamily: 'semibold',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _buildNutritionField(
                    controller: _caloriesController,
                    label: 'Calories',
                    unit:  'kcal',
                    color: const Color(0xFFFF6B35),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNutritionField(
                    controller: _proteinController,
                    label: 'Protein',
                    unit:  'g',
                    color: const Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildNutritionField(
                    controller: _carbsController,
                    label: 'Carbs',
                    unit:  'g',
                    color: const Color(0xFFFFC107),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNutritionField(
                    controller: _fatController,
                    label: 'Fat',
                    unit:  'g',
                    color: const Color(0xFF9C27B0),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Add Food Button ──
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _addFood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B7F3A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Add Food to List',
                  style: TextStyle(
                    fontFamily: 'semibold',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helper: Text Field ────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType inputType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'medium',
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: controller,
            keyboardType: inputType,
            style: const TextStyle(fontFamily: 'regular', fontSize: 14),
            decoration: InputDecoration(
              hintText:        hint,
              hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
              prefixIcon:      Icon(icon, color: const Color(0xFF1B7F3A), size: 18),
              border:          InputBorder.none,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  // ── Helper: Nutrition Field ───────────────────
  Widget _buildNutritionField({
    required TextEditingController controller,
    required String label,
    required String unit,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              '$label ($unit)',
              style: const TextStyle(
                fontFamily: 'medium',
                fontSize: 11,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'semibold',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            decoration: const InputDecoration(
              border:         InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
