import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MacroBreakdownWidget extends StatelessWidget {
  final Map<String, dynamic> macros;

  const MacroBreakdownWidget({super.key, required this.macros});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          _buildMacroBar(
            context: context,
            name: 'Protein',
            grams: (macros["protein"] as Map<String, dynamic>)["grams"] as int,
            target:
                (macros["protein"] as Map<String, dynamic>)["target"] as int,
            percentage:
                (macros["protein"] as Map<String, dynamic>)["percentage"]
                    as double,
            color: theme.colorScheme.secondary,
          ),
          SizedBox(height: 2.h),
          _buildMacroBar(
            context: context,
            name: 'Carbs',
            grams: (macros["carbs"] as Map<String, dynamic>)["grams"] as int,
            target: (macros["carbs"] as Map<String, dynamic>)["target"] as int,
            percentage:
                (macros["carbs"] as Map<String, dynamic>)["percentage"]
                    as double,
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          _buildMacroBar(
            context: context,
            name: 'Fats',
            grams: (macros["fats"] as Map<String, dynamic>)["grams"] as int,
            target: (macros["fats"] as Map<String, dynamic>)["target"] as int,
            percentage:
                (macros["fats"] as Map<String, dynamic>)["percentage"]
                    as double,
            color: theme.colorScheme.tertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBar({
    required BuildContext context,
    required String name,
    required int grams,
    required int target,
    required double percentage,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${grams}g / ${target}g',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 1.2.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage > 1.0 ? 1.0 : percentage,
              child: Container(
                height: 1.2.h,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          '${(percentage * 100).toStringAsFixed(0)}% of target',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
