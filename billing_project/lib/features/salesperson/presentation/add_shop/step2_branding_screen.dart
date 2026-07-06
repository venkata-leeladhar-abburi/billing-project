import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_action_bar.dart';
import '../../../../shared/widgets/step_progress_bar.dart';
import '../../domain/add_shop_notifier.dart';

class Step2BrandingScreen extends ConsumerWidget {
  const Step2BrandingScreen({super.key});

  Future<void> _pickLogo(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined, color: AppColors.kOrange),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.of(sheetContext).pop();
                final picked = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 85);
                if (picked != null) ref.read(addShopProvider.notifier).setLogo(picked.path);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.kOrange),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.of(sheetContext).pop();
                final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
                if (picked != null) ref.read(addShopProvider.notifier).setLogo(picked.path);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close, color: AppColors.kMuted),
              title: const Text('Cancel'),
              onTap: () => Navigator.of(sheetContext).pop(),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    return parts.first[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(addShopProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.kDark),
          onPressed: () => context.pop(),
        ),
        title: Text('New Shop · Step 2 of 4', style: AppTypography.h3.copyWith(fontSize: 15)),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.s16),
        children: [
          StepProgressBar(
            stepLabels: const ['Details', 'Branding', 'Plan', 'AutoPay'],
            currentStep: 1,
            completedSteps: 1,
          ),
          SizedBox(height: AppSpacing.s24),
          AppCard(
            child: Column(
              children: [
                Text('SHOP LOGO', style: AppTypography.labelSmall),
                SizedBox(height: AppSpacing.s16),
                GestureDetector(
                  onTap: () => _pickLogo(context, ref),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.kBorderGray, width: 1.5),
                      image: data.logoPath != null
                          ? DecorationImage(image: FileImage(File(data.logoPath!)), fit: BoxFit.cover)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: data.logoPath == null
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.camera_alt_outlined, size: 28, color: Color(0xFFCCCCCC)),
                              SizedBox(height: AppSpacing.s4),
                              Text('Tap to upload logo', style: AppTypography.caption.copyWith(fontSize: 12)),
                            ],
                          )
                        : null,
                  ),
                ),
                SizedBox(height: AppSpacing.s12),
                Text(
                  'Recommended: 200×200px, PNG or JPG, max 2MB',
                  textAlign: TextAlign.center,
                  style: AppTypography.caption.copyWith(fontSize: 11),
                ),
                if (data.logoPath == null) ...[
                  SizedBox(height: AppSpacing.s8),
                  GestureDetector(
                    onTap: () => ref.read(addShopProvider.notifier).skipLogo(),
                    child: Text('Skip for now', style: AppTypography.body.copyWith(fontSize: 12, color: AppColors.kOrange)),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: AppSpacing.s16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BILL HEADER PREVIEW', style: AppTypography.labelSmall),
                SizedBox(height: AppSpacing.s12),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s12),
                  decoration: BoxDecoration(color: AppColors.kNavy, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                          image: data.logoPath != null
                              ? DecorationImage(image: FileImage(File(data.logoPath!)), fit: BoxFit.cover)
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: data.logoPath == null
                            ? Text(_initials(data.shopName), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))
                            : null,
                      ),
                      SizedBox(width: AppSpacing.s12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.shopName.isEmpty ? 'Shop Name' : data.shopName,
                              style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                            Text(
                              'GST: ${data.gstNumber.isEmpty ? '—' : data.gstNumber}',
                              style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.4)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.s8),
                Text('This is how your shop will appear on every PDF bill', style: AppTypography.caption.copyWith(fontSize: 11)),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.s16),
          AppCard(
            child: Text(
              'Custom bill colors coming soon',
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: AppColors.kMuted),
            ),
          ),
          SizedBox(height: AppSpacing.s48),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        secondaryLabel: 'Step 2 of 4',
        ctaLabel: 'Next: Select Plan →',
        onCtaTap: () => context.push('/salesperson/shops/add/plan'),
      ),
    );
  }
}
