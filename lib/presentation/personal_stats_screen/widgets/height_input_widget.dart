import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class HeightInputWidget extends StatefulWidget {
  final bool isInCm;
  final Function(bool) onUnitToggle;
  final Function(double?, double?, double?) onHeightChanged;
  final bool isValid;

  const HeightInputWidget({
    super.key,
    required this.isInCm,
    required this.onUnitToggle,
    required this.onHeightChanged,
    required this.isValid,
  });

  @override
  State<HeightInputWidget> createState() => _HeightInputWidgetState();
}

class _HeightInputWidgetState extends State<HeightInputWidget> {
  final TextEditingController _cmController = TextEditingController();
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();

  @override
  void dispose() {
    _cmController.dispose();
    _feetController.dispose();
    _inchesController.dispose();
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
              'Height',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            _buildUnitToggle(theme),
          ],
        ),
        SizedBox(height: 1.h),
        widget.isInCm ? _buildCmInput(theme) : _buildFeetInchesInput(theme),
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
          _buildToggleButton('cm', widget.isInCm, theme),
          _buildToggleButton('ft', !widget.isInCm, theme),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected, ThemeData theme) {
    return GestureDetector(
      onTap: () => widget.onUnitToggle(label == 'cm'),
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

  Widget _buildCmInput(ThemeData theme) {
    return TextFormField(
      controller: _cmController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
      ],
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: 'Enter height in cm 120 to 250',
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
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
      ),
      onChanged: (value) {
        final cm = double.tryParse(value);
        widget.onHeightChanged(cm, null, null);
      },
    );
  }

  Widget _buildFeetInchesInput(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _feetController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Feet 4 to 8',
              hintStyle: theme.inputDecorationTheme.hintStyle,
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
              final feet = double.tryParse(value);
              final inches = double.tryParse(_inchesController.text);
              widget.onHeightChanged(null, feet, inches);
            },
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: TextFormField(
            controller: _inchesController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
            ],
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Inches',
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
              final feet = double.tryParse(_feetController.text);
              final inches = double.tryParse(value);
              widget.onHeightChanged(null, feet, inches);
            },
          ),
        ),
      ],
    );
  }
}
