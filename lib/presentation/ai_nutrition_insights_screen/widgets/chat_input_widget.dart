import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChatInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final bool isEnabled;

  const ChatInputWidget({
    super.key,
    required this.controller,
    required this.onSend,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: isEnabled,
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: isEnabled ? onSend : null,
              style: const TextStyle(
                fontFamily: "regular",
              ),
              decoration: InputDecoration(
                hintText: 'Ask about Nigerian nutrition...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: "regular",
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.5.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Material(
            color: isEnabled
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(24.0),
            child: InkWell(
              onTap: isEnabled
                  ? () {
                if (controller.text.trim().isNotEmpty) {
                  onSend(controller.text);
                }
              }
                  : null,
              borderRadius: BorderRadius.circular(24.0),
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: Icon(
                  Icons.send,
                  color: theme.colorScheme.onPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}