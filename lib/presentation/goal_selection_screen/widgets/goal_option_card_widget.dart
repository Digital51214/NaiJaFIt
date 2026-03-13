// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../../core/app_export.dart';
// import '../../../widgets/custom_icon_widget.dart';
//
// /// Goal Option Card Widget - Displays individual goal selection option
// /// Features Material Design elevation with tap animations and haptic feedback
// class GoalOptionCardWidget extends StatelessWidget {
//   final String title;
//   final String icon;
//   final String description;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   const GoalOptionCardWidget({
//     super.key,
//     required this.title,
//     required this.icon,
//     required this.description,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         width: double.infinity,
//         height: 100,
//         padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? theme.colorScheme.primary.withValues(alpha: 0.1)
//               : theme.colorScheme.surface,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected
//                 ? Colors.black
//                 : theme.colorScheme.outline.withValues(alpha: 0.3),
//             width: isSelected ? 2 : 1,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: theme.shadowColor.withValues(alpha: 0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             _buildIcon(theme),
//             SizedBox(width: 4.w),
//             Expanded(child: _buildContent(theme)),
//             if (isSelected) _buildCheckmark(theme),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Builds icon container with circular background
//   Widget _buildIcon(ThemeData theme) {
//     return Container(
//       width: 12.w,
//       height: 12.w,
//       decoration: BoxDecoration(
//         color: isSelected
//             ? Colors.black
//             : theme.colorScheme.primary.withValues(alpha: 0.1),
//         shape: BoxShape.circle,
//       ),
//       child:
//       Center(
//         child:
//         CustomIconWidget(
//           iconName: icon,
//           color: isSelected
//               ? theme.colorScheme.onPrimary
//               : Colors.black,
//           size: 24,
//         ),
//       ),
//     );
//   }
//
//   /// Builds title and description text
//   Widget _buildContent(ThemeData theme) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: GoogleFonts.poppins(textStyle: theme.textTheme.titleMedium?.copyWith(
//             color: theme.colorScheme.onSurface,
//             fontWeight: FontWeight.w600,)
//           ),
//         ),
//         SizedBox(height: 0.5.h),
//         Text(
//           description,
//           style: GoogleFonts.poppins(textStyle: theme.textTheme.bodySmall?.copyWith(
//             color: theme.colorScheme.onSurfaceVariant,)
//           ),
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//         ),
//       ],
//     );
//   }
//
//   /// Builds checkmark icon for selected state
//   Widget _buildCheckmark(ThemeData theme) {
//     return Container(
//       width: 8.w,
//       height: 8.w,
//       decoration: BoxDecoration(
//         color: Colors.black,
//         shape: BoxShape.circle,
//       ),
//       child: Center(
//         child: CustomIconWidget(
//           iconName: 'check',
//           color: theme.colorScheme.onPrimary,
//           size: 16,
//         ),
//       ),
//     );
//   }
// }









import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Goal Option Card Widget - Displays individual goal selection option
/// Features Material Design elevation with tap animations and haptic feedback
class GoalOptionCardWidget extends StatelessWidget {
  final String title;
  final String icon;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const GoalOptionCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 95,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildIcon(theme),
            SizedBox(width: 4.w),
            Expanded(child: _buildContent(theme)),
            if (isSelected) _buildCheckmark(theme),
          ],
        ),
      ),
    );
  }

  /// Builds icon container with circular background
  Widget _buildIcon(ThemeData theme) {
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child:
      Center(
        child:
        CustomIconWidget(
          iconName: icon,
          color: isSelected
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.primary,
          size: 24,
        ),
      ),
    );
  }

  /// Builds title and description text
  Widget _buildContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Builds checkmark icon for selected state
  Widget _buildCheckmark(ThemeData theme) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'check',
          color: theme.colorScheme.onPrimary,
          size: 16,
        ),
      ),
    );
  }
}
