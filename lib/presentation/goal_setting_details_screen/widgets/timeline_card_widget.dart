// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../../core/app_export.dart';
// import '../../../widgets/custom_icon_widget.dart';
//
// class TimelineCardWidget extends StatelessWidget {
//   final int weeks;
//   final String label;
//   final String difficulty;
//   final bool isRecommended;
//   final bool isSelected;
//   final double? weeklyChange;
//   final VoidCallback onTap;
//
//   const TimelineCardWidget({
//     super.key,
//     required this.weeks,
//     required this.label,
//     required this.difficulty,
//     required this.isRecommended,
//     required this.isSelected,
//     required this.weeklyChange,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 35.w,
//         padding: EdgeInsets.all(3.w),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? Colors.black.withValues(alpha: 0.1)
//               : theme.colorScheme.surface,
//           borderRadius: BorderRadius.circular(12.0),
//           border: Border.all(
//             color: isSelected
//                 ? Colors.black
//                 : theme.colorScheme.outline.withValues(alpha: 0.3),
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (isRecommended)
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 2.w,
//                       vertical: 0.5.h,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: BorderRadius.circular(4.0),
//                     ),
//                     child: Text(
//                       'Recommended',
//                       style: theme.textTheme.labelSmall?.copyWith(
//                         color: theme.colorScheme.onSecondary,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 SizedBox(height: isRecommended ? 1.h : 0),
//                 Text(
//                   label,
//                   style: theme.textTheme.titleMedium?.copyWith(
//                     color: theme.colorScheme.onSurface,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 0.5.h),
//                 Text(
//                   difficulty,
//                   style: GoogleFonts.poppins(textStyle: theme.textTheme.bodySmall?.copyWith(
//                     color: theme.colorScheme.onSurfaceVariant,)
//                   ),
//                 ),
//               ],
//             ),
//             if (weeklyChange != null)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Divider(
//                     color: theme.colorScheme.outline.withValues(alpha: 0.3),
//                     height: 2.h,
//                   ),
//                   Row(
//                     children: [
//                       CustomIconWidget(
//                         iconName: weeklyChange! < 0
//                             ? 'trending_down'
//                             : 'trending_up',
//                         color: Colors.black,
//                         size: 16,
//                       ),
//                       SizedBox(width: 1.w),
//                       Expanded(
//                         child: Text(
//                           '${weeklyChange!.abs().toStringAsFixed(1)} kg/week',
//                           style: theme.textTheme.bodySmall?.copyWith(
//                             color: theme.colorScheme.onSurface,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }










import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TimelineCardWidget extends StatelessWidget {
  final int weeks;
  final String label;
  final String difficulty;
  final bool isRecommended;
  final bool isSelected;
  final double? weeklyChange;
  final VoidCallback onTap;

  const TimelineCardWidget({
    super.key,
    required this.weeks,
    required this.label,
    required this.difficulty,
    required this.isRecommended,
    required this.isSelected,
    required this.weeklyChange,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isRecommended)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      'Recommended',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                SizedBox(height: isRecommended ? 1.h : 0),
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  difficulty,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (weeklyChange != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: weeklyChange! < 0
                            ? 'trending_down'
                            : 'trending_up',
                        color: theme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          '${weeklyChange!.abs().toStringAsFixed(1)} kg/week',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
