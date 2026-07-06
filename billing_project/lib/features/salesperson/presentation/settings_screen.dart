import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../../features/auth/domain/salesperson_auth_notifier.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/confirm_bottom_sheet.dart';
import '../domain/salesperson_dashboard_notifier.dart';

class SalespersonSettingsScreen extends ConsumerWidget {
  const SalespersonSettingsScreen({super.key});

  Future<void> _onLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmBottomSheet.show(
      context,
      title: 'Log out?',
      body: 'You will need your mobile number and password to log back in.',
      confirmLabel: 'Log Out',
      isDestructive: true,
    );
    if (confirmed == true) {
      ref.read(salespersonAuthProvider.notifier).logout();
      if (context.mounted) context.go('/salesperson/login');
    }
  }

  Future<void> _showChangePassword(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.s16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Change Password', style: AppTypography.h3.copyWith(fontSize: 16)),
                SizedBox(height: AppSpacing.s16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    filled: true,
                    fillColor: AppColors.kBgPage,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(height: AppSpacing.s12),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    filled: true,
                    fillColor: AppColors.kBgPage,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(height: AppSpacing.s12),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    filled: true,
                    fillColor: AppColors.kBgPage,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(height: AppSpacing.s16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password updated (simulated)')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kOrange,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Update Password', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalShops = ref.watch(salespersonDashboardProvider).value?.totalShops ?? 0;

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Settings', style: AppTypography.h3.copyWith(fontSize: 17)),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.s16),
        children: [
          AppCard(
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(color: AppColors.kOrangeLight, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text('V', style: AppTypography.h1Serif.copyWith(fontSize: 24, color: AppColors.kOrange)),
                ),
                SizedBox(height: AppSpacing.s12),
                Text('Venkatesh Naidu', style: AppTypography.h2.copyWith(fontSize: 18)),
                SizedBox(height: AppSpacing.s4),
                Text('+91 98765 00001', style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kSecondary)),
                SizedBox(height: AppSpacing.s8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s4),
                  decoration: BoxDecoration(color: AppColors.kOrangeLight, borderRadius: AppSpacing.rPill),
                  child: Text('SALES TEAM', style: AppTypography.caption.copyWith(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.kOrange)),
                ),
                SizedBox(height: AppSpacing.s8),
                Text('$totalShops active shops', style: AppTypography.caption),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.s24),
          _sectionLabel('My Work'),
          _tile(context, 'My Shops', onTap: () => context.go('/salesperson/shops')),
          _tile(context, 'Cancellation Requests', onTap: () => context.go('/salesperson/cancellations')),
          _tile(context, 'My Performance', trailing: 'Coming soon'),
          SizedBox(height: AppSpacing.s24),
          _sectionLabel('Account'),
          _tile(context, 'Change Password', onTap: () => _showChangePassword(context)),
          _tile(
            context,
            'Contact Super Admin',
            onTap: () => launchUrl(Uri.parse('https://wa.me/919876500001'), mode: LaunchMode.externalApplication),
          ),
          SizedBox(height: AppSpacing.s24),
          _sectionLabel('App Info'),
          _tile(context, 'Help & FAQ', onTap: () {
            // TODO: open help/FAQ URL in WebView when content is ready
          }),
          _tile(context, 'Privacy Policy', onTap: () {
            // TODO: open privacy policy URL when published
          }),
          SizedBox(height: AppSpacing.s24),
          _sectionLabel('Danger Zone'),
          _tile(context, 'Log Out', textColor: AppColors.kError, onTap: () => _onLogout(context, ref)),
          SizedBox(height: AppSpacing.s24),
          Text(
            '${AppStrings.appName} v1.0.0 · Sales Portal',
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(fontSize: 11),
          ),
        ],
      ),
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
            child: Text(label, style: AppTypography.body.copyWith(fontSize: 14, color: textColor ?? AppColors.kDark)),
          ),
          if (trailing != null)
            Text(trailing, style: AppTypography.caption)
          else if (onTap != null)
            const Icon(Icons.chevron_right, color: AppColors.kMuted, size: 20),
        ],
      ),
    );
  }
}
