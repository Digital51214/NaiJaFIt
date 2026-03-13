import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ActivityLevelWidget extends StatelessWidget {
  final String selectedLevel;
  final Function(String) onLevelSelected;

  const ActivityLevelWidget({
    super.key,
    required this.selectedLevel,
    required this.onLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, String>> activityLevels = [
      {'level': 'Sedentary', 'description': 'Little or no exercise'},
      {
        'level': 'Lightly Active',
        'description': 'Light exercise 1-3 days/week',
      },
      {
        'level': 'Moderately Active',
        'description': 'Moderate exercise 3-5 days/week',
      },
      {'level': 'Very Active', 'description': 'Hard exercise 6-7 days/week'},
      {
        'level': 'Extremely Active',
        'description': 'Very hard exercise & physical job',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Level',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        ...activityLevels.map((activity) {
          final isSelected = selectedLevel == activity['level'];
          return Padding(
            padding: EdgeInsets.only(bottom: 1.5.h),
            child: GestureDetector(
              onTap: () => onLevelSelected(activity['level']!),
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(3.w),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 5.w,
                      height: 5.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline,
                          width: 2,
                        ),
                        color: isSelected
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 2.w,
                                height: 2.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : null,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity['level']!,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            activity['description']!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
