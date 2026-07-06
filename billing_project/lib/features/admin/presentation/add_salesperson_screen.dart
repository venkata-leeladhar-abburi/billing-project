import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/confirm_bottom_sheet.dart';
import '../../../shared/widgets/input_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/success_toast.dart';
import '../domain/add_salesperson_notifier.dart';

class AddSalespersonScreen extends ConsumerStatefulWidget {
  const AddSalespersonScreen({super.key});

  @override
  ConsumerState<AddSalespersonScreen> createState() => _AddSalespersonScreenState();
}

class _AddSalespersonScreenState extends ConsumerState<AddSalespersonScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _notesController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _notesController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _sync() {
    ref.read(addSalespersonProvider.notifier).updateField(
          fullName: _nameController.text,
          mobile: _mobileController.text,
          email: _emailController.text,
          cityRegion: _cityController.text,
          notes: _notesController.text,
          password: _passwordController.text,
          confirmPassword: _confirmController.text,
        );
    setState(() {});
  }

  Future<void> _onCancel() async {
    final confirmed = await ConfirmBottomSheet.show(
      context,
      title: 'Discard this salesperson?',
      body: 'All entered details will be lost.',
      confirmLabel: 'Discard',
      isDestructive: true,
    );
    if (confirmed == true && mounted) {
      ref.read(addSalespersonProvider.notifier).reset();
      context.pop();
    }
  }

  Future<void> _onCreate() async {
    final mobile = _mobileController.text.trim();
    final ok = await ref.read(addSalespersonProvider.notifier).create();
    if (ok && mounted) {
      SuccessToast.show(context, message: 'Account created. Credentials sent to +91 $mobile');
      ref.read(addSalespersonProvider.notifier).reset();
      context.go('/admin/salespersons');
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(addSalespersonProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        centerTitle: true,
        leading: TextButton(
          onPressed: _onCancel,
          child: Text('Cancel', style: AppTypography.body.copyWith(color: AppColors.kSecondary)),
        ),
        leadingWidth: 80,
        title: Text('Add Salesperson', style: AppTypography.h3.copyWith(fontSize: 16)),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.s16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SALESPERSON DETAILS', style: AppTypography.labelSmall),
                SizedBox(height: AppSpacing.s16),
                InputField(label: 'Full Name', isRequired: true, controller: _nameController, onChanged: (_) => _sync()),
                SizedBox(height: AppSpacing.s16),
                InputField(label: 'Mobile Number', isRequired: true, controller: _mobileController, prefixText: '+91 ', keyboardType: TextInputType.phone, onChanged: (_) => _sync()),
                SizedBox(height: AppSpacing.s16),
                InputField(label: 'Email Address (Optional)', controller: _emailController, keyboardType: TextInputType.emailAddress, onChanged: (_) => _sync()),
                SizedBox(height: AppSpacing.s16),
                InputField(label: 'City / Region', isRequired: true, controller: _cityController, onChanged: (_) => _sync()),
                SizedBox(height: AppSpacing.s16),
                InputField(
                  label: 'Notes (Internal, Optional)',
                  controller: _notesController,
                  maxLines: 3,
                  placeholder: 'e.g. Handles Vijayawada and Guntur region',
                  onChanged: (_) => _sync(),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.s16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LOGIN CREDENTIALS', style: AppTypography.labelSmall),
                SizedBox(height: AppSpacing.s16),
                InputField(
                  label: 'Temporary Password',
                  isRequired: true,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  suffixWidget: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.kMuted, size: 20),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  onChanged: (_) => _sync(),
                ),
                SizedBox(height: AppSpacing.s4),
                Text('Salesperson must change this on first login', style: AppTypography.caption.copyWith(fontSize: 11)),
                SizedBox(height: AppSpacing.s16),
                InputField(label: 'Confirm Password', isRequired: true, controller: _confirmController, obscureText: true, onChanged: (_) => _sync()),
                SizedBox(height: AppSpacing.s12),
                _RuleRow(text: 'Minimum 8 characters', met: _passwordController.text.length >= 8),
                _RuleRow(text: 'At least 1 number', met: RegExp(r'[0-9]').hasMatch(_passwordController.text)),
                _RuleRow(text: 'At least 1 uppercase letter', met: RegExp(r'[A-Z]').hasMatch(_passwordController.text)),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.s16),
          AppCard(
            backgroundColor: AppColors.kBlueLight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: AppColors.kBlue, size: 20),
                SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: Text(
                    'Login credentials will be sent to +91 ${_mobileController.text.isEmpty ? '—' : _mobileController.text} via WhatsApp after creation.',
                    style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kBlue),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.s24),
          PrimaryButton(
            label: 'Create Salesperson Account',
            isLoading: data.isSubmitting,
            onTap: data.canSubmit ? _onCreate : null,
          ),
          SizedBox(height: AppSpacing.s24),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.text, required this.met});

  final String text;
  final bool met;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(met ? Icons.check_circle : Icons.circle_outlined, size: 14, color: met ? AppColors.kGreen : AppColors.kMuted),
          SizedBox(width: AppSpacing.s8),
          Text(text, style: AppTypography.body.copyWith(fontSize: 12, color: met ? AppColors.kGreen : AppColors.kMuted)),
        ],
      ),
    );
  }
}
