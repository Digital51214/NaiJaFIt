import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NotificationSettingsWidget extends StatelessWidget {
  final bool mealReminders;
  final bool progressUpdates;
  final bool streakNotifications;
  final bool weeklyReports;
  final Function(bool) onMealRemindersChanged;
  final Function(bool) onProgressUpdatesChanged;
  final Function(bool) onStreakNotificationsChanged;
  final Function(bool) onWeeklyReportsChanged;

  const NotificationSettingsWidget({
    super.key,
    required this.mealReminders,
    required this.progressUpdates,
    required this.streakNotifications,
    required this.weeklyReports,
    required this.onMealRemindersChanged,
    required this.onProgressUpdatesChanged,
    required this.onStreakNotificationsChanged,
    required this.onWeeklyReportsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          _buildNotificationItem(
            context,
            'Meal Reminders',
            'Get notified for breakfast, lunch, and dinner',
            Icons.notifications_active_outlined,
            mealReminders,
            onMealRemindersChanged,
          ),
          Divider(height: 2.h),
          _buildNotificationItem(
            context,
            'Progress Updates',
            'Daily summaries of your calorie tracking',
            Icons.trending_up,
            progressUpdates,
            onProgressUpdatesChanged,
          ),
          Divider(height: 2.h),
          _buildNotificationItem(
            context,
            'Streak Notifications',
            'Celebrate your logging streaks',
            Icons.local_fire_department,
            streakNotifications,
            onStreakNotificationsChanged,
          ),
          Divider(height: 2.h),
          _buildNotificationItem(
            context,
            'Weekly Reports',
            'Get weekly progress summaries',
            Icons.assessment_outlined,
            weeklyReports,
            onWeeklyReportsChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Icon(icon, size: 20, color: theme.colorScheme.primary),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.3.h),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: theme.colorScheme.primary,
        ),
      ],
    );
  }
}
