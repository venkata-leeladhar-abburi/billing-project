import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/confirm_bottom_sheet.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../features/auth/domain/auth_notifier.dart';
import '../domain/settings_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        centerTitle: true,
        title: Text('Settings', style: AppTypography.h3.copyWith(fontSize: 17)),
      ),
      body: asyncState.when(
        loading: () => const LoadingOverlay(),
        error: (error, _) => const Center(child: Text('Could not load')),
        data: (data) => _buildBody(context, ref, data),
      ),
    );
  }

  Future<void> _onLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmBottomSheet.show(
      context,
      title: 'Log out?',
      body: 'You will need to verify your WhatsApp number again to log back in.',
      confirmLabel: 'Log Out',
      isDestructive: true,
    );
    if (confirmed == true) {
      ref.read(authProvider.notifier).logout();
      if (context.mounted) context.go('/login');
    }
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, SettingsState data) {
    return ListView(
      padding: EdgeInsets.all(AppSpacing.s16),
      children: [
        AppCard(
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: AppColors.kOrangeLight,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  data.shopName.isNotEmpty ? data.shopName[0] : '?',
                  style: AppTypography.h1Serif.copyWith(fontSize: 24, color: AppColors.kOrange),
                ),
              ),
              SizedBox(height: AppSpacing.s12),
              Text(data.shopName, style: AppTypography.h2.copyWith(fontSize: 18)),
              SizedBox(height: AppSpacing.s4),
              Text(
                '${data.ownerName} · ${data.phone}',
                style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kSecondary),
              ),
              SizedBox(height: AppSpacing.s8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s4),
                decoration: BoxDecoration(color: AppColors.kOrangeLight, borderRadius: AppSpacing.rPill),
                child: Text(
                  data.businessType,
                  style: const TextStyle(fontSize: 11, color: AppColors.kOrange, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: AppSpacing.s8),
              GestureDetector(
                onTap: () => context.push('/credits'),
                child: Text('View Plan', style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kOrange)),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.s24),
        _sectionLabel('Account'),
        _tile(context, 'My Plan', onTap: () => context.push('/credits')),
        _tile(context, 'Notifications', onTap: () => context.push('/notifications')),
        SizedBox(height: AppSpacing.s24),
        _sectionLabel('Billing'),
        _tile(context, 'GST Details', trailing: 'View only'),
        _tile(
          context,
          'Default GST Rate',
          trailing: '${(data.gstRate * 100).toStringAsFixed(0)}%',
          onTap: () => _showGstPicker(context, ref, data.gstRate),
        ),
        SizedBox(height: AppSpacing.s24),
        _sectionLabel('Support'),
        _tile(context, 'Help & FAQ', onTap: () {
          // TODO: open help/FAQ URL in WebView when content is ready
        }),
        _tile(
          context,
          'WhatsApp Support',
          onTap: () => launchUrl(Uri.parse('https://wa.me/919876500000')),
        ),
        _tile(context, 'Privacy Policy', onTap: () {
          // TODO: open privacy policy URL when published
        }),
        SizedBox(height: AppSpacing.s24),
        _sectionLabel('Danger Zone'),
        _tile(
          context,
          'Request AutoPay Cancellation',
          onTap: () => context.push('/settings/cancel-request'),
        ),
        _tile(
          context,
          'Log Out',
          textColor: AppColors.kError,
          onTap: () => _onLogout(context, ref),
        ),
        SizedBox(height: AppSpacing.s24),
        Text(
          '${AppStrings.appName} v1.0.0',
          textAlign: TextAlign.center,
          style: AppTypography.caption.copyWith(fontSize: 11),
        ),
      ],
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.s8, left: AppSpacing.s4),
      child: Text(label, style: AppTypography.labelSmall.copyWith(fontSize: 12)),
    );
  }

  Widget _tile(
    BuildContext context,
    String label, {
    String? trailing,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return AppCard(
      onTap: onTap,
      margin: EdgeInsets.only(bottom: AppSpacing.s8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.body.copyWith(
                fontSize: 14,
                color: textColor ?? AppColors.kDark,
              ),
            ),
          ),
          if (trailing != null)
            Text(trailing, style: AppTypography.caption)
          else if (onTap != null)
            const Icon(Icons.chevron_right, color: AppColors.kMuted, size: 20),
        ],
      ),
    );
  }

  Future<void> _showGstPicker(BuildContext context, WidgetRef ref, double current) async {
    const rates = [0.0, 0.05, 0.12, 0.18];
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final rate in rates)
              ListTile(
                title: Text('${(rate * 100).toStringAsFixed(0)}%'),
                trailing: rate == current ? const Icon(Icons.check, color: AppColors.kOrange) : null,
                onTap: () {
                  ref.read(settingsProvider.notifier).setGstRate(rate);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}
