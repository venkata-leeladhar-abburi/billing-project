import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import 'secondary_button.dart';

class ConfirmBottomSheet extends StatelessWidget {
  const ConfirmBottomSheet({
    required this.title,
    required this.confirmLabel,
    this.body,
    this.cancelLabel = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.confirmButtonColor,
    this.isDestructive = false,
    this.customContent,
    super.key,
  });

  final String title;
  final String? body;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmButtonColor;
  final bool isDestructive;
  final Widget? customContent;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String confirmLabel,
    String? body,
    String cancelLabel = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmButtonColor,
    bool isDestructive = false,
    Widget? customContent,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ConfirmBottomSheet(
        title: title,
        confirmLabel: confirmLabel,
        body: body,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmButtonColor: confirmButtonColor,
        isDestructive: isDestructive,
        customContent: customContent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.s16,
          AppSpacing.s24,
          AppSpacing.s16,
          AppSpacing.s24,
        ),
        decoration: const BoxDecoration(
          color: AppColors.kBgCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.kBorderGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: AppSpacing.s24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.kDark,
              ),
            ),
            if (body != null) ...[
              SizedBox(height: AppSpacing.s8),
              Text(
                body!,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(fontSize: 14, height: 1.6),
              ),
            ],
            if (customContent != null) ...[
              SizedBox(height: AppSpacing.s16),
              customContent!,
            ],
            SizedBox(height: AppSpacing.s24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onConfirm?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: confirmButtonColor ??
                      (isDestructive ? AppColors.kError : AppColors.kOrange),
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: Text(confirmLabel, style: AppTypography.buttonLabel),
              ),
            ),
            SizedBox(height: AppSpacing.s8),
            SecondaryButton(
              label: cancelLabel,
              onTap: () {
                Navigator.of(context).pop(false);
                onCancel?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
