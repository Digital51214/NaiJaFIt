import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

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
    _selectedServingSize = widget.food["servingSize"] as String;
  }

  void _incrementServings() {
    setState(() {
      _servings += 0.5;
      if (_servings > 10.0) _servings = 10.0;
    });
  }

  void _decrementServings() {
    setState(() {
      _servings -= 0.5;
      if (_servings < 0.5) _servings = 0.5;
    });
  }

  double _calculateCalories() {
    return (widget.food["calories"] as int) * _servings;
  }

  double _calculateMacro(String macro) {
    return (widget.food[macro] as double) * _servings;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              SizedBox(height: 2.h),
              _buildFoodImage(theme),
              SizedBox(height: 2.h),
              _buildServingSizeSelector(theme),
              SizedBox(height: 2.h),
              _buildServingsAdjuster(theme),
              SizedBox(height: 2.h),
              _buildNutritionInfo(theme),
              SizedBox(height: 2.h),
              _buildAddButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.food["name"] as String,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.outline, width: 1),
            ),
            child: CustomIconWidget(
              iconName: 'close',
              color: theme.colorScheme.onSurface,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFoodImage(ThemeData theme) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CustomImageWidget(
          imageUrl: widget.food["image"] as String,
          width: 80.w,
          height: 25.h,
          fit: BoxFit.cover,
          semanticLabel: widget.food["semanticLabel"] as String,
        ),
      ),
    );
  }

  Widget _buildServingSizeSelector(ThemeData theme) {
    final servingOptions = widget.food["servingOptions"] as List<dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Serving Size',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: servingOptions.map((option) {
            final isSelected = option == _selectedServingSize;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedServingSize = option;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: Text(
                  option as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildServingsAdjuster(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Number of Servings',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _decrementServings,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'remove',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outline, width: 1),
              ),
              child: Text(
                _servings.toStringAsFixed(1),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: _incrementServings,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: 'add',
                  color: theme.colorScheme.onPrimary,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNutritionInfo(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          _buildNutritionRow(
            theme,
            'Calories',
            '${_calculateCalories().toStringAsFixed(0)} cal',
          ),
          SizedBox(height: 1.h),
          _buildNutritionRow(
            theme,
            'Protein',
            '${_calculateMacro("protein").toStringAsFixed(1)}g',
          ),
          SizedBox(height: 1.h),
          _buildNutritionRow(
            theme,
            'Carbs',
            '${_calculateMacro("carbs").toStringAsFixed(1)}g',
          ),
          SizedBox(height: 1.h),
          _buildNutritionRow(
            theme,
            'Fats',
            '${_calculateMacro("fats").toStringAsFixed(1)}g',
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(ThemeData theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          widget.onAdd(widget.food, _selectedServingSize, _servings);
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Add to Food Log',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
