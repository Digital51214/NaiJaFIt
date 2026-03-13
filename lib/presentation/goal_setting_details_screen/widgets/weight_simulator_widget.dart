// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../../core/app_export.dart';
// import '../../../widgets/custom_icon_widget.dart';
//
// class WeightSimulatorWidget extends StatelessWidget {
//   final double? currentWeight;
//   final double? targetWeight;
//   final int? weeks;
//   final bool isKg;
//
//   const WeightSimulatorWidget({
//     super.key,
//     required this.currentWeight,
//     required this.targetWeight,
//     required this.weeks,
//     required this.isKg,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     if (currentWeight == null || targetWeight == null || weeks == null) {
//       return const SizedBox.shrink();
//     }
//
//     final totalChange = targetWeight! - currentWeight!;
//     final weeklyChange = totalChange / weeks!;
//     final isHealthyRate = weeklyChange.abs() <= 1.0;
//
//     return Container(
//       padding: EdgeInsets.all(4.w),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surface,
//         borderRadius: BorderRadius.circular(12.0),
//         border: Border.all(
//           color: theme.colorScheme.outline.withValues(alpha: 0.3),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CustomIconWidget(
//                 iconName: 'insights',
//                 color: Colors.black,
//                 size: 24,
//               ),
//               SizedBox(width: 2.w),
//               Text(
//                 'Progress Projection',
//                 style: theme.textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.w600,
//                   color: theme.colorScheme.onSurface,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 2.h),
//           _buildProgressBar(theme),
//           SizedBox(height: 2.h),
//           _buildWeightLabels(theme),
//           SizedBox(height: 2.h),
//           _buildHealthIndicator(theme, isHealthyRate, weeklyChange),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProgressBar(ThemeData theme) {
//     final progress = 0.0;
//
//     return Column(
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(8.0),
//           child: LinearProgressIndicator(
//             value: progress,
//             backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
//             valueColor: AlwaysStoppedAnimation<Color>(
//               Colors.black,
//             ),
//             minHeight: 12,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildWeightLabels(ThemeData theme) {
//     final unit = isKg ? 'kg' : 'lbs';
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Current',
//               style: theme.textTheme.bodySmall?.copyWith(
//                 color: theme.colorScheme.onSurfaceVariant,
//               ),
//             ),
//             SizedBox(height: 0.5.h),
//             Text(
//               '${currentWeight!.toStringAsFixed(1)} $unit',
//               style: theme.textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey,
//               ),
//             ),
//           ],
//         ),
//         CustomIconWidget(
//           iconName: 'arrow_forward',
//           color: theme.colorScheme.onSurfaceVariant,
//           size: 20,
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               'Target',
//               style: theme.textTheme.bodySmall?.copyWith(
//                 color: theme.colorScheme.onSurfaceVariant,
//               ),
//             ),
//             SizedBox(height: 0.5.h),
//             Text(
//               '${targetWeight!.toStringAsFixed(1)} $unit',
//               style: theme.textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildHealthIndicator(
//       ThemeData theme,
//       bool isHealthyRate,
//       double weeklyChange,
//       ) {
//     return Container(
//       padding: EdgeInsets.all(3.w),
//       decoration: BoxDecoration(
//         color: isHealthyRate
//             ? Colors.black.withValues(alpha: 0.1)
//             : theme.colorScheme.error.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Row(
//         children: [
//           CustomIconWidget(
//             iconName: isHealthyRate ? 'check_circle' : 'warning',
//             color: isHealthyRate
//                 ? Colors.black
//                 : theme.colorScheme.error,
//             size: 20,
//           ),
//           SizedBox(width: 2.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   isHealthyRate ? 'Healthy Rate' : 'Aggressive Rate',
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     fontWeight: FontWeight.w600,
//                     color: isHealthyRate
//                         ? Colors.black
//                         : theme.colorScheme.error,
//                   ),
//                 ),
//                 SizedBox(height: 0.5.h),
//                 Text(
//                   isHealthyRate
//                       ? 'Your goal is achievable with ${weeklyChange.abs().toStringAsFixed(1)} ${isKg ? 'kg' : 'lbs'}/week'
//                       : 'Consider a longer timeline for sustainable results',
//                   style: theme.textTheme.bodySmall?.copyWith(
//                     color: theme.colorScheme.onSurfaceVariant,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

















import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class WeightSimulatorWidget extends StatelessWidget {
  final double? currentWeight;
  final double? targetWeight;
  final int? weeks;
  final bool isKg;

  const WeightSimulatorWidget({
    super.key,
    required this.currentWeight,
    required this.targetWeight,
    required this.weeks,
    required this.isKg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (currentWeight == null || targetWeight == null || weeks == null) {
      return const SizedBox.shrink();
    }

    final totalChange = targetWeight! - currentWeight!;
    final weeklyChange = totalChange / weeks!;
    final isHealthyRate = weeklyChange.abs() <= 1.0;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'insights',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Progress Projection',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildProgressBar(theme),
          SizedBox(height: 2.h),
          _buildWeightLabels(theme),
          SizedBox(height: 2.h),
          _buildHealthIndicator(theme, isHealthyRate, weeklyChange),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ThemeData theme) {
    final progress = 0.0;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
            minHeight: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildWeightLabels(ThemeData theme) {
    final unit = isKg ? 'kg' : 'lbs';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              '${currentWeight!.toStringAsFixed(1)} $unit',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        CustomIconWidget(
          iconName: 'arrow_forward',
          color: theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Target',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              '${targetWeight!.toStringAsFixed(1)} $unit',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthIndicator(
    ThemeData theme,
    bool isHealthyRate,
    double weeklyChange,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isHealthyRate
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : theme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isHealthyRate ? 'check_circle' : 'warning',
            color: isHealthyRate
                ? theme.colorScheme.primary
                : theme.colorScheme.error,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHealthyRate ? 'Healthy Rate' : 'Aggressive Rate',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isHealthyRate
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  isHealthyRate
                      ? 'Your goal is achievable with ${weeklyChange.abs().toStringAsFixed(1)} ${isKg ? 'kg' : 'lbs'}/week'
                      : 'Consider a longer timeline for sustainable results',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
