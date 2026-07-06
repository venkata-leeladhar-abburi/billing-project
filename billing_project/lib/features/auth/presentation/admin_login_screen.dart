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
import '../domain/admin_auth_notifier.dart';

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _canSubmit => _emailController.text.trim().isNotEmpty && _passwordController.text.trim().isNotEmpty;

  Future<void> _onLogin() async {
    setState(() => _errorText = null);
    await ref.read(adminAuthProvider.notifier).login(_emailController.text.trim(), _passwordController.text.trim());
    if (!mounted) return;

    final state = ref.read(adminAuthProvider);
    state.when(
      data: (role) {
        if (role == 'super_admin') context.go('/admin/dashboard');
      },
      loading: () {},
      error: (error, _) => setState(() => _errorText = error.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(adminAuthProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              const GradientHeader(type: GradientHeaderType.navy, height: 200),
              Positioned.fill(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shield_outlined, size: 40, color: Colors.white),
                      SizedBox(height: AppSpacing.s4),
                      Text(
                        AppStrings.appName,
                        style: AppTypography.h1Serif.copyWith(fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(height: AppSpacing.s12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s4),
                        decoration: BoxDecoration(
                          color: AppColors.kOrange.withValues(alpha: 0.25),
                          borderRadius: AppSpacing.rPill,
                          border: Border.all(color: AppColors.kOrange.withValues(alpha: 0.5)),
                        ),
                        child: Text(
                          'Super Admin Portal',
                          style: AppTypography.body.copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.kOrange),
                        ),
                      ),
                      SizedBox(height: AppSpacing.s8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s4),
                        decoration: BoxDecoration(
                          color: AppColors.kError.withValues(alpha: 0.15),
                          borderRadius: AppSpacing.rPill,
                        ),
                        child: const Text(
                          'Restricted Access',
                          style: TextStyle(fontSize: 11, color: AppColors.kError),
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
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Admin Login', style: AppTypography.h2.copyWith(fontSize: 18)),
                        SizedBox(height: AppSpacing.s4),
                        Text(
                          'One Stop Solutions — Internal Only',
                          style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kMuted, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(height: AppSpacing.s20),
                        InputField(
                          label: 'Admin Email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (_) => setState(() {}),
                        ),
                        SizedBox(height: AppSpacing.s16),
                        InputField(
                          label: 'Password',
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          errorText: _errorText,
                          suffixWidget: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.kMuted,
                              size: 20,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        SizedBox(height: AppSpacing.s20),
                        PrimaryButton(
                          label: 'Log In',
                          isLoading: isLoading,
                          onTap: _canSubmit && !isLoading ? _onLogin : null,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_outline, size: 14, color: AppColors.kMuted),
                    SizedBox(width: AppSpacing.s4),
                    Flexible(
                      child: Text(
                        'This portal is for authorised administrators only. Unauthorised access is a violation of platform policy.',
                        textAlign: TextAlign.center,
                        style: AppTypography.caption.copyWith(fontSize: 11),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.s16),
                GestureDetector(
                  onTap: () => context.go('/login'),
                  child: Text(
                    'Log in as Shopkeeper →',
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kOrange),
                  ),
                ),
                SizedBox(height: AppSpacing.s8),
                GestureDetector(
                  onTap: () => context.go('/salesperson/login'),
                  child: Text(
                    'Log in as Sales Team →',
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kOrange),
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
