import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalizationSummaryWidget extends StatelessWidget {
  final String selectedGoal;
  final int targetWeight;
  final int timelineWeeks;

  const PersonalizationSummaryWidget({
    super.key,
    required this.selectedGoal,
    required this.targetWeight,
    required this.timelineWeeks,
  });

  String _getGoalDisplayName(String goal) {
    switch (goal) {
      case 'lose_weight':
        return 'Lose Weight';
      case 'gain_muscle':
        return 'Gain Muscle';
      case 'maintain_weight':
        return 'Maintain Weight';
      default:
        return 'Lose Weight';
    }
  }

  IconData _getGoalIcon(String goal) {
    switch (goal) {
      case 'lose_weight':
        return Icons.trending_down;
      case 'gain_muscle':
        return Icons.fitness_center;
      case 'maintain_weight':
        return Icons.balance;
      default:
        return Icons.trending_down;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Plan Summary',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
                size: 6.w,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildSummaryItem(
            context: context,
            icon: _getGoalIcon(selectedGoal),
            label: 'Goal',
            value: _getGoalDisplayName(selectedGoal),
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          _buildSummaryItem(
            context: context,
            icon: Icons.monitor_weight,
            label: 'Target Weight',
            value: '${targetWeight}kg',
            color: theme.colorScheme.secondary,
          ),
          SizedBox(height: 2.h),
          _buildSummaryItem(
            context: context,
            icon: Icons.calendar_today,
            label: 'Timeline',
            value: '$timelineWeeks weeks',
            color: theme.colorScheme.tertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Icon(icon, color: color, size: 5.w),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 0.3.h),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
