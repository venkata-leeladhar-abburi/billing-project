import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../../../shared/widgets/info_banner.dart';
import '../../../shared/widgets/input_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../domain/salesperson_auth_notifier.dart';

class SalespersonLoginScreen extends ConsumerStatefulWidget {
  const SalespersonLoginScreen({super.key});

  @override
  ConsumerState<SalespersonLoginScreen> createState() =>
      _SalespersonLoginScreenState();
}

class _SalespersonLoginScreenState extends ConsumerState<SalespersonLoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorText;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _phoneController.text.trim().length == 10 &&
      _passwordController.text.trim().isNotEmpty;

  Future<void> _onLogin() async {
    setState(() => _errorText = null);
    await ref.read(salespersonAuthProvider.notifier).login(
          _phoneController.text.trim(),
          _passwordController.text.trim(),
        );
    if (!mounted) return;

    final state = ref.read(salespersonAuthProvider);
    state.when(
      data: (role) {
        if (role == 'salesperson') context.go('/salesperson/dashboard');
      },
      loading: () {},
      error: (error, _) => setState(() => _errorText = error.toString()),
    );
  }

  Future<void> _onForgotPassword() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contact your admin to reset your password.',
                textAlign: TextAlign.center,
                style: AppTypography.body,
              ),
              SizedBox(height: AppSpacing.s16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(salespersonAuthProvider);
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
                        size: 40,
                        color: AppColors.kNavy,
                      ),
                      SizedBox(height: AppSpacing.s4),
                      Text(
                        AppStrings.appName,
                        style: AppTypography.h1Serif.copyWith(
                          fontSize: 20,
                          color: AppColors.kNavy,
                        ),
                      ),
                      SizedBox(height: AppSpacing.s8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.s12,
                          vertical: AppSpacing.s4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.4),
                          borderRadius: AppSpacing.rPill,
                        ),
                        child: Text(
                          'Sales Team Portal',
                          style: AppTypography.body.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.kNavy,
                          ),
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
                          'Sales Team Login',
                          style: AppTypography.h2.copyWith(fontSize: 18),
                        ),
                        SizedBox(height: AppSpacing.s4),
                        Text(
                          'Enter your registered mobile number',
                          style: AppTypography.body,
                        ),
                        SizedBox(height: AppSpacing.s20),
                        InputField(
                          label: 'Mobile Number',
                          controller: _phoneController,
                          prefixText: '+91 ',
                          placeholder: '98765 43210',
                          keyboardType: TextInputType.phone,
                          onChanged: (_) => setState(() {}),
                        ),
                        SizedBox(height: AppSpacing.s16),
                        InputField(
                          label: 'Password',
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          placeholder: 'Enter password',
                          errorText: _errorText,
                          suffixWidget: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.kMuted,
                              size: 20,
                            ),
                            onPressed: () =>
                                setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        SizedBox(height: AppSpacing.s8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: _onForgotPassword,
                            child: Text(
                              'Forgot Password?',
                              style: AppTypography.body.copyWith(
                                fontSize: 12,
                                color: AppColors.kOrange,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.s16),
                        PrimaryButton(
                          label: 'Log In',
                          isLoading: isLoading,
                          onTap: _canSubmit && !isLoading ? _onLogin : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const InfoBanner(
                  type: InfoBannerType.warning,
                  message: 'SIMULATOR: any password with 4+ characters works',
                ),
                SizedBox(height: AppSpacing.s16),
                Text(
                  'Access restricted to authorised sales team only',
                  textAlign: TextAlign.center,
                  style: AppTypography.caption.copyWith(fontSize: 11),
                ),
                SizedBox(height: AppSpacing.s12),
                GestureDetector(
                  onTap: () => context.go('/login'),
                  child: Text(
                    'Are you a shopkeeper?',
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(
                      fontSize: 13,
                      color: AppColors.kOrange,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.s8),
                GestureDetector(
                  onTap: () => context.push('/admin/login'),
                  child: Text(
                    'Are you an admin?',
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(
                      fontSize: 13,
                      color: AppColors.kOrange,
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
