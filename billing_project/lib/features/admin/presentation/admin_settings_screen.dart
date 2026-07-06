import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../../features/auth/domain/admin_auth_notifier.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/confirm_bottom_sheet.dart';

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  Future<void> _onLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmBottomSheet.show(
      context,
      title: 'Log out of Super Admin portal?',
      body: 'You will need your admin email and password to log back in.',
      confirmLabel: 'Log Out',
      isDestructive: true,
    );
    if (confirmed == true) {
      ref.read(adminAuthProvider.notifier).logout();
      if (context.mounted) context.go('/admin/login');
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
                TextField(obscureText: true, decoration: InputDecoration(labelText: 'Current Password', filled: true, fillColor: AppColors.kBgPage, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
                SizedBox(height: AppSpacing.s12),
                TextField(obscureText: true, decoration: InputDecoration(labelText: 'New Password', filled: true, fillColor: AppColors.kBgPage, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
                SizedBox(height: AppSpacing.s12),
                TextField(obscureText: true, decoration: InputDecoration(labelText: 'Confirm New Password', filled: true, fillColor: AppColors.kBgPage, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
                SizedBox(height: AppSpacing.s16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password updated (simulated)')));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.kOrange, minimumSize: const Size.fromHeight(48)),
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

  Future<void> _showChangeEmail(BuildContext context) async {
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
                Text('Change Email', style: AppTypography.h3.copyWith(fontSize: 16)),
                SizedBox(height: AppSpacing.s16),
                TextField(keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: 'New Email', filled: true, fillColor: AppColors.kBgPage, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
                SizedBox(height: AppSpacing.s12),
                TextField(obscureText: true, decoration: InputDecoration(labelText: 'Confirm Password', filled: true, fillColor: AppColors.kBgPage, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
                SizedBox(height: AppSpacing.s16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email updated (simulated)')));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.kOrange, minimumSize: const Size.fromHeight(48)),
                    child: const Text('Update Email', style: TextStyle(color: Colors.white)),
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
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(color: AppColors.kNavy, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const Text('L', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                ),
                SizedBox(height: AppSpacing.s12),
                Text('Leeladhar', style: AppTypography.h2.copyWith(fontSize: 18)),
                SizedBox(height: AppSpacing.s4),
                Text('leeladhar@onestopsolutions.in', style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kSecondary)),
                SizedBox(height: AppSpacing.s8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s4),
                  decoration: BoxDecoration(color: AppColors.kNavy, borderRadius: AppSpacing.rPill),
                  child: const Text('SUPER ADMIN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
                SizedBox(height: AppSpacing.s8),
                Text('One Stop Solutions', style: AppTypography.caption.copyWith(fontSize: 11)),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.s24),
          _sectionLabel('Platform Management'),
          _tile(context, 'Platform Settings', onTap: () => context.push('/admin/platform-settings')),
          _tile(context, 'Subscription Plans', onTap: () => context.push('/admin/plans')),
          _tile(context, 'WhatsApp Templates', onTap: () => context.go('/admin/templates')),
          _tile(context, 'Revenue Report', onTap: () => context.push('/admin/revenue')),
          SizedBox(height: AppSpacing.s24),
          _sectionLabel('Team'),
          _tile(context, 'Salespersons', onTap: () => context.go('/admin/salespersons')),
          _tile(context, 'All Shops', onTap: () => context.go('/admin/shops')),
          _tile(context, 'Cancellations', onTap: () => context.push('/admin/cancellations')),
          SizedBox(height: AppSpacing.s24),
          _sectionLabel('Account'),
          _tile(context, 'Change Password', onTap: () => _showChangePassword(context)),
          _tile(context, 'Change Email', onTap: () => _showChangeEmail(context)),
          _tile(context, 'Two-Factor Auth', trailing: 'Coming in Phase 2'),
          SizedBox(height: AppSpacing.s24),
          _sectionLabel('App'),
          _tile(context, 'App Version', trailing: '${AppStrings.appName} v1.0.0'),
          _tile(context, 'Privacy Policy', onTap: () {
            // TODO: open privacy policy URL when published
          }),
          _tile(context, 'Help / Docs', onTap: () {
            // TODO: open internal admin docs URL when published
          }),
          SizedBox(height: AppSpacing.s24),
          _sectionLabel('Session'),
          _tile(context, 'Log Out', textColor: AppColors.kError, onTap: () => _onLogout(context, ref)),
          SizedBox(height: AppSpacing.s24),
          Text(
            '${AppStrings.appName} v1.0.0 · Admin Portal · One Stop Solutions',
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

  Widget _tile(BuildContext context, String label, {String? trailing, Color? textColor, VoidCallback? onTap}) {
    return AppCard(
      onTap: onTap,
      margin: EdgeInsets.only(bottom: AppSpacing.s8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.body.copyWith(fontSize: 14, color: textColor ?? AppColors.kDark))),
          if (trailing != null)
            Text(trailing, style: AppTypography.caption)
          else if (onTap != null)
            const Icon(Icons.chevron_right, color: AppColors.kMuted, size: 20),
        ],
      ),
    );
  }
}
