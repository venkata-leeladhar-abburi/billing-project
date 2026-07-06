import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

class InputField extends StatelessWidget {
  const InputField({
    required this.label,
    this.controller,
    this.placeholder,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.errorText,
    this.prefixText,
    this.suffixWidget,
    this.maxLines = 1,
    this.onChanged,
    this.onTap,
    this.isRequired = false,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final String? placeholder;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final String? errorText;
  final String? prefixText;
  final Widget? suffixWidget;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.kBorderGray),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTypography.labelSmall,
            children: [
              TextSpan(text: label.toUpperCase()),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.kOrange),
                ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.s8),
        SizedBox(
          height: maxLines == 1 ? 52 : null,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            readOnly: readOnly,
            maxLines: obscureText ? 1 : maxLines,
            onChanged: onChanged,
            onTap: onTap,
            style: AppTypography.bodyLarge.copyWith(
              color: readOnly ? AppColors.kSecondary : AppColors.kDark,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: readOnly ? const Color(0xFFFAFAFA) : AppColors.kBgCard,
              hintText: placeholder,
              hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.kMuted),
              prefixText: prefixText,
              prefixStyle: AppTypography.bodyLarge,
              suffixIcon: suffixWidget,
              errorText: errorText,
              errorStyle: const TextStyle(fontSize: 11, color: AppColors.kError),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
                vertical: maxLines == 1 ? 0 : AppSpacing.s12,
              ),
              border: border,
              enabledBorder: border,
              disabledBorder: border,
              focusedBorder: border.copyWith(
                borderSide: const BorderSide(color: AppColors.kOrange, width: 1.5),
              ),
              errorBorder: border.copyWith(
                borderSide: const BorderSide(color: AppColors.kError, width: 1.5),
              ),
              focusedErrorBorder: border.copyWith(
                borderSide: const BorderSide(color: AppColors.kError, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
