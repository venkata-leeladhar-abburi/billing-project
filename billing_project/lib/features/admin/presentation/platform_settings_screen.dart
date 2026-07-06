import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/confirm_bottom_sheet.dart';
import '../../../shared/widgets/success_toast.dart';
import '../domain/platform_settings_notifier.dart';

class PlatformSettingsScreen extends ConsumerStatefulWidget {
  const PlatformSettingsScreen({super.key});

  @override
  ConsumerState<PlatformSettingsScreen> createState() => _PlatformSettingsScreenState();
}

class _PlatformSettingsScreenState extends ConsumerState<PlatformSettingsScreen> {
  bool _showAiSensyKey = false;
  bool _showRazorpaySecret = false;
  final _prefixController = TextEditingController();
  final _alertNumberController = TextEditingController();
  final _forceResendController = TextEditingController();
  bool _seeded = false;

  @override
  void dispose() {
    _prefixController.dispose();
    _alertNumberController.dispose();
    _forceResendController.dispose();
    super.dispose();
  }

  void _seed(PlatformSettingsState s) {
    if (_seeded) return;
    _seeded = true;
    _prefixController.text = s.campaignPrefix;
    _alertNumberController.text = s.criticalAlertNumber;
  }

  Future<void> _confirmLiveModeToggle(bool value) async {
    if (!value) {
      final confirmed = await ConfirmBottomSheet.show(
        context,
        title: 'Switch to Test Mode?',
        body: 'Switching to Test Mode will stop real payments from being processed.',
        confirmLabel: 'Switch to Test Mode',
        isDestructive: true,
      );
      if (confirmed != true) return;
    }
    ref.read(platformSettingsProvider.notifier).toggleLiveMode(value);
  }

  Future<void> _saveAll() async {
    ref.read(platformSettingsProvider.notifier).updateField(
          campaignPrefix: _prefixController.text.trim(),
          criticalAlertNumber: _alertNumberController.text.trim(),
        );
    final ok = await ref.read(platformSettingsProvider.notifier).saveAll();
    if (ok && mounted) SuccessToast.show(context, message: 'Settings saved');
  }

  Future<void> _clearCaches() async {
    final confirmed = await ConfirmBottomSheet.show(
      context,
      title: 'Clear all caches?',
      body: 'This clears local Isar caches on this device. It does not affect server data.',
      confirmLabel: 'Clear Caches',
      isDestructive: true,
    );
    if (confirmed == true) {
      await ref.read(platformSettingsProvider.notifier).clearCaches();
      if (mounted) SuccessToast.show(context, message: 'Caches cleared');
    }
  }

  Widget _testButton(ConnectionTestState testState, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: testState == ConnectionTestState.testing ? null : onTap,
      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36), padding: EdgeInsets.symmetric(horizontal: AppSpacing.s12)),
      child: testState == ConnectionTestState.testing
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
          : Text(testState == ConnectionTestState.success ? 'Connected ✓' : 'Test Connection', style: const TextStyle(fontSize: 12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(platformSettingsProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.kDark),
          onPressed: () => context.go('/admin/dashboard'),
        ),
        title: Text('Platform Settings', style: AppTypography.h3.copyWith(fontSize: 17)),
        actions: [
          TextButton(
            onPressed: state.hasValue ? _saveAll : null,
            child: Text('Save All', style: AppTypography.body.copyWith(color: AppColors.kOrange, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (s) {
          _seed(s);
          return ListView(
            padding: EdgeInsets.all(AppSpacing.s16),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('AISENSY — WHATSAPP API', style: AppTypography.labelSmall),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
                          decoration: BoxDecoration(color: s.aisensyConnected ? AppColors.kGreenLight : const Color(0xFFFEF2F2), borderRadius: AppSpacing.rPill),
                          child: Text(s.aisensyConnected ? '✓ Connected' : '✗ Disconnected', style: TextStyle(fontSize: 11, color: s.aisensyConnected ? AppColors.kGreen : AppColors.kError)),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.s16),
                    Text('API KEY', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                    SizedBox(height: AppSpacing.s8),
                    TextField(
                      readOnly: true,
                      obscureText: !_showAiSensyKey,
                      controller: TextEditingController(text: _showAiSensyKey ? 'sk_live_xxxxxxxxxxxx${s.aisensyApiKeyLast4}' : '••••••••••••${s.aisensyApiKeyLast4}'),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: const Color(0xFFFAFAFA),
                        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        suffixIcon: IconButton(
                          icon: Icon(_showAiSensyKey ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18),
                          onPressed: () => setState(() => _showAiSensyKey = !_showAiSensyKey),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.s4),
                    Text('Stored securely — not visible after save', style: AppTypography.caption.copyWith(fontSize: 11)),
                    SizedBox(height: AppSpacing.s16),
                    Text('CAMPAIGN NAME PREFIX', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                    SizedBox(height: AppSpacing.s8),
                    TextField(
                      controller: _prefixController,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: AppColors.kBgPage,
                        hintText: 'e.g. building_project_',
                        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    Text('WHATSAPP PLATFORM NUMBER', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                    SizedBox(height: AppSpacing.s8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
                      decoration: BoxDecoration(color: const Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.kBorderGray)),
                      child: Text(s.whatsappNumber, style: AppTypography.bodyLarge),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    _testButton(s.aisensyTestState, () => ref.read(platformSettingsProvider.notifier).testAiSensy()),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.s16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('RAZORPAY — PAYMENTS', style: AppTypography.labelSmall),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
                          decoration: BoxDecoration(color: s.razorpayConnected ? AppColors.kGreenLight : const Color(0xFFFEF2F2), borderRadius: AppSpacing.rPill),
                          child: Text(s.razorpayConnected ? '✓ Connected' : '✗ Disconnected', style: TextStyle(fontSize: 11, color: s.razorpayConnected ? AppColors.kGreen : AppColors.kError)),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.s16),
                    Text('KEY ID (PUBLIC)', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                    SizedBox(height: AppSpacing.s8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
                      decoration: BoxDecoration(color: AppColors.kBgPage, borderRadius: BorderRadius.circular(8)),
                      child: Text(s.razorpayKeyId, style: AppTypography.bodyLarge.copyWith(fontFamily: AppTypography.kFontMono, fontSize: 13)),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    Text('KEY SECRET', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                    SizedBox(height: AppSpacing.s8),
                    TextField(
                      readOnly: true,
                      obscureText: !_showRazorpaySecret,
                      controller: TextEditingController(text: _showRazorpaySecret ? 'rzp_secret_9f8e7d6c5b4a' : '••••••••••••••••'),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: const Color(0xFFFAFAFA),
                        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        suffixIcon: IconButton(
                          icon: Icon(_showRazorpaySecret ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18),
                          onPressed: () => setState(() => _showRazorpaySecret = !_showRazorpaySecret),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _confirmLiveModeToggle(false),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: AppSpacing.s12),
                              decoration: BoxDecoration(color: !s.isLiveMode ? AppColors.kDark : Colors.transparent, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.kBorderGray)),
                              alignment: Alignment.center,
                              child: Text('Test Mode', style: TextStyle(fontSize: 13, color: !s.isLiveMode ? Colors.white : AppColors.kDark)),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.s8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _confirmLiveModeToggle(true),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: AppSpacing.s12),
                              decoration: BoxDecoration(color: s.isLiveMode ? AppColors.kDark : Colors.transparent, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.kBorderGray)),
                              alignment: Alignment.center,
                              child: Text('Live Mode', style: TextStyle(fontSize: 13, color: s.isLiveMode ? Colors.white : AppColors.kDark)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.s16),
                    _testButton(s.razorpayTestState, () => ref.read(platformSettingsProvider.notifier).testRazorpay()),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.s16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SUPABASE — DATABASE', style: AppTypography.labelSmall),
                    SizedBox(height: AppSpacing.s16),
                    _ReadOnlyRow(label: 'Project URL', value: 'xxxx.supabase.co'),
                    _ReadOnlyRow(label: 'Connection', value: '✓ Connected', valueColor: AppColors.kGreen),
                    _ReadOnlyRow(label: 'Auth Provider', value: 'Supabase Auth (OTP)'),
                    SizedBox(height: AppSpacing.s12),
                    Text('DB Storage used: 42 MB / 500 MB', style: AppTypography.caption),
                    SizedBox(height: AppSpacing.s6),
                    ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: 0.084, minHeight: 6, backgroundColor: AppColors.kBorderGray)),
                    SizedBox(height: AppSpacing.s12),
                    Text('To change Supabase settings, update environment variables on Railway.', style: AppTypography.caption.copyWith(fontSize: 11)),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.s16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PLATFORM NOTIFICATIONS', style: AppTypography.labelSmall),
                    SizedBox(height: AppSpacing.s12),
                    _NotifyToggle(label: 'Notify Super Admin on new cancellation request', value: s.notifyOnCancellation, onChanged: (v) => ref.read(platformSettingsProvider.notifier).toggleNotification('cancellation', v)),
                    _NotifyToggle(label: 'Notify Super Admin on AutoPay failure', value: s.notifyOnAutopayFailure, onChanged: (v) => ref.read(platformSettingsProvider.notifier).toggleNotification('autopayFailure', v)),
                    _NotifyToggle(label: 'Notify Salesperson on their shop cancellation', value: s.notifySalespersonOnCancellation, onChanged: (v) => ref.read(platformSettingsProvider.notifier).toggleNotification('salespersonCancellation', v)),
                    _NotifyToggle(label: 'Notify Shopkeeper 3 days before AutoPay', value: s.notifyShopkeeperBeforeAutopay, onChanged: (v) => ref.read(platformSettingsProvider.notifier).toggleNotification('beforeAutopay', v)),
                    _NotifyToggle(label: 'Notify Shopkeeper on credit low (< 20%)', value: s.notifyShopkeeperOnLowCredit, onChanged: (v) => ref.read(platformSettingsProvider.notifier).toggleNotification('lowCredit', v)),
                    SizedBox(height: AppSpacing.s16),
                    Text('SEND CRITICAL ALERTS TO', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                    SizedBox(height: AppSpacing.s8),
                    TextField(
                      controller: _alertNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: AppColors.kBgPage,
                        prefixText: '+91 ',
                        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.s16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('APP VERSION INFO', style: AppTypography.labelSmall),
                    SizedBox(height: AppSpacing.s12),
                    _ReadOnlyRow(label: 'Flutter App Version', value: 'v1.0.0'),
                    _ReadOnlyRow(label: 'API Server Version', value: 'v1.0.0'),
                    if (s.lastTemplateSync != null) _ReadOnlyRow(label: 'Last Template Sync', value: Formatters.formatRelativeTime(s.lastTemplateSync!)),
                    SizedBox(height: AppSpacing.s12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          await ref.read(platformSettingsProvider.notifier).syncTemplates();
                          if (mounted) SuccessToast.show(context, message: 'Templates synced');
                        },
                        child: const Text('Force Sync Templates'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.s16),
              AppCard(
                borderColor: const Color(0xFFFECACA),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DANGER ZONE', style: AppTypography.labelSmall.copyWith(color: AppColors.kError)),
                    SizedBox(height: AppSpacing.s12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _clearCaches,
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFFECACA))),
                        child: const Text('Clear All Caches', style: TextStyle(color: AppColors.kError)),
                      ),
                    ),
                    SizedBox(height: AppSpacing.s8),
                    TextField(
                      controller: _forceResendController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Shop phone number',
                        filled: true,
                        fillColor: AppColors.kBgPage,
                        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(height: AppSpacing.s8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          SuccessToast.show(context, message: 'Credentials re-sent (simulated)');
                        },
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFFECACA))),
                        child: const Text('Force Re-send Credentials', style: TextStyle(color: AppColors.kError)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.s24),
            ],
          );
        },
      ),
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  const _ReadOnlyRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption),
          Text(value, style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor)),
        ],
      ),
    );
  }
}

class _NotifyToggle extends StatelessWidget {
  const _NotifyToggle({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTypography.body.copyWith(fontSize: 13))),
        Switch(value: value, activeThumbColor: AppColors.kOrange, onChanged: onChanged),
      ],
    );
  }
}
