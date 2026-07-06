import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../../../shared/widgets/input_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../domain/auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool get _isValidPhone => _phoneController.text.trim().length == 10;

  Future<void> _onContinue() async {
    setState(() => _errorText = null);
    final phone = _phoneController.text.trim();

    await ref.read(authProvider.notifier).requestOtp(phone);

    if (!mounted) return;

    final state = ref.read(authProvider);
    state.when(
      data: (_) => context.go('/otp', extra: phone),
      loading: () {},
      error: (error, _) => setState(() => _errorText = error.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              const GradientHeader(type: GradientHeaderType.sky, height: 200),
              Positioned.fill(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.storefront_outlined,
                        size: 48,
                        color: AppColors.kNavy,
                      ),
                      SizedBox(height: AppSpacing.s8),
                      Text(
                        AppStrings.appName,
                        style: AppTypography.h1Serif.copyWith(
                          fontSize: 24,
                          color: AppColors.kNavy,
                        ),
                      ),
                      SizedBox(height: AppSpacing.s4),
                      Text(
                        'Send bills. Grow your business.',
                        style: AppTypography.body.copyWith(
                          fontSize: 14,
                          color: AppColors.kNavy.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: AppCard(
                    borderRadius: 20,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.s16,
                      vertical: AppSpacing.s20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Log in to your shop',
                          style: AppTypography.h2.copyWith(fontSize: 18),
                        ),
                        SizedBox(height: AppSpacing.s4),
                        Text(
                          'Enter your WhatsApp number',
                          style: AppTypography.body,
                        ),
                        SizedBox(height: AppSpacing.s20),
                        InputField(
                          label: 'WhatsApp Number',
                          controller: _phoneController,
                          prefixText: '+91 ',
                          placeholder: '98765 43210',
                          keyboardType: TextInputType.phone,
                          errorText: _errorText,
                          onChanged: (_) => setState(() {}),
                        ),
                        SizedBox(height: AppSpacing.s20),
                        PrimaryButton(
                          label: 'Continue',
                          isLoading: isLoading,
                          onTap: _isValidPhone && !isLoading ? _onContinue : null,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.s24),
                Text(
                  'By proceeding, you agree to our Terms and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: AppTypography.caption.copyWith(fontSize: 11),
                ),
                SizedBox(height: AppSpacing.s12),
                Center(
                  child: GestureDetector(
                    onTap: () => context.push('/salesperson/login'),
                    child: Text(
                      'Are you a salesperson? Login here',
                      style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kOrange),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.s8),
                Center(
                  child: GestureDetector(
                    onTap: () => context.push('/admin/login'),
                    child: Text(
                      'Are you an admin? Login here',
                      style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kOrange),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.s24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
