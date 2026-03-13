import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class AccountStatusWidget extends StatelessWidget {
  final bool isConnected;
  final DateTime? lastSyncTime;

  const AccountStatusWidget({
    super.key,
    required this.isConnected,
    this.lastSyncTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final syncText = lastSyncTime != null
        ? 'Last synced: ${DateFormat('MMM d, y h:mm a').format(lastSyncTime!)}'
        : 'Never synced';

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isConnected
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  isConnected ? Icons.cloud_done : Icons.cloud_off,
                  size: 20,
                  color: isConnected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supabase Account',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.3.h),
                    Text(
                      isConnected ? 'Connected' : 'Disconnected',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isConnected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isConnected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Divider(height: 1),
          SizedBox(height: 1.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                syncText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data export feature coming soon'),
                    ),
                  );
                },
                icon: Icon(
                  Icons.download,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                label: Text(
                  'Export Data',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
