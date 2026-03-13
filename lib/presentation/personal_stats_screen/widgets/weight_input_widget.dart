import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class WeightInputWidget extends StatefulWidget {
  final bool isInKg;
  final Function(bool) onUnitToggle;
  final Function(double?) onWeightChanged;
  final bool isValid;

  const WeightInputWidget({
    super.key,
    required this.isInKg,
    required this.onUnitToggle,
    required this.onWeightChanged,
    required this.isValid,
  });

  @override
  State<WeightInputWidget> createState() => _WeightInputWidgetState();
}

class _WeightInputWidgetState extends State<WeightInputWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Current Weight',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            _buildUnitToggle(theme),
          ],
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
          ],
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.isInKg
                ? 'Enter weight in kg'
                : 'Enter weight in lbs',
            hintStyle: theme.inputDecorationTheme.hintStyle,
            suffixIcon: widget.isValid
                ? Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'check_circle',
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  )
                : null,
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
          onChanged: (value) {
            final weight = double.tryParse(value);
            widget.onWeightChanged(weight);
          },
        ),
        if (_controller.text.isNotEmpty && !widget.isValid)
          Padding(
            padding: EdgeInsets.only(top: 1.h, left: 3.w),
            child: Text(
              widget.isInKg
                  ? 'Weight must be between 30 and 300 kg'
                  : 'Weight must be between 66 and 660 lbs',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUnitToggle(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          _buildToggleButton('kg', widget.isInKg, theme),
          _buildToggleButton('lbs', !widget.isInKg, theme),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected, ThemeData theme) {
    return GestureDetector(
      onTap: () => widget.onUnitToggle(label == 'kg'),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
