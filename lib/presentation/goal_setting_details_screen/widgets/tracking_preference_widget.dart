// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../../core/app_export.dart';
// import '../../../widgets/custom_icon_widget.dart';
//
// class TrackingPreferenceWidget extends StatelessWidget {
//   final String title;
//   final String description;
//   final String icon;
//   final bool isEnabled;
//   final Function(bool) onToggle;
//
//   const TrackingPreferenceWidget({
//     super.key,
//     required this.title,
//     required this.description,
//     required this.icon,
//     required this.isEnabled,
//     required this.onToggle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Container(
//       height: 80,
//       padding: EdgeInsets.all(3.w),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surface,
//         borderRadius: BorderRadius.circular(12.0),
//         border: Border.all(
//           color: theme.colorScheme.outline.withValues(alpha: 0.3),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 12.w,
//             height: 12.w,
//             decoration: BoxDecoration(
//               color: isEnabled
//                   ? Colors.black.withValues(alpha: 0.1)
//                   : theme.colorScheme.outline.withValues(alpha: 0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: CustomIconWidget(
//                 iconName: icon,
//                 color: isEnabled
//                     ? Colors.black
//                     : theme.colorScheme.onSurfaceVariant,
//                 size: 24,
//               ),
//             ),
//           ),
//           SizedBox(width: 3.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.w600,
//                     color: theme.colorScheme.onSurface,
//                   ),
//                 ),
//                 SizedBox(height: 0.5.h),
//                 Text(
//                   description,
//                   style: theme.textTheme.bodySmall?.copyWith(
//                     color: theme.colorScheme.onSurfaceVariant,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Switch(
//             value: isEnabled,
//             onChanged: onToggle,
//             activeThumbColor: Colors.black,
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

class TrackingPreferenceWidget extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final bool isEnabled;
  final Function(bool) onToggle;

  const TrackingPreferenceWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: isEnabled
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : theme.colorScheme.outline.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: isEnabled
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onToggle,
            activeThumbColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
