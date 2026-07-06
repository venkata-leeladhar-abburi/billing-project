import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/info_banner.dart';
import '../../../shared/widgets/primary_button.dart';
import '../domain/auth_notifier.dart';

const _otpLength = 6;
const _resendSeconds = 45;

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({required this.phone, super.key});

  final String phone;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  late final List<TextEditingController> _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  late final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

  Timer? _timer;
  int _secondsLeft = _resendSeconds;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _secondsLeft = _resendSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otpValue => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    if (_otpValue.length == _otpLength) {
      FocusScope.of(context).unfocus();
      _verify();
    }
    setState(() {});
  }

  void _clearBoxes() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
    setState(() {});
  }

  Future<void> _verify() async {
    setState(() => _errorText = null);
    await ref.read(authProvider.notifier).verifyOtp(widget.phone, _otpValue);

    if (!mounted) return;

    final state = ref.read(authProvider);
    state.when(
      data: (role) {
        if (role == 'shopkeeper') {
          context.go('/dashboard');
        }
      },
      loading: () {},
      error: (error, _) {
        setState(() => _errorText = 'Incorrect OTP. Mock code is 123456');
        _clearBoxes();
      },
    );
  }

  Future<void> _onResend() async {
    if (_secondsLeft > 0) return;
    await ref.read(authProvider.notifier).requestOtp(widget.phone);
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    final isComplete = _otpValue.length == _otpLength;

    return Scaffold(
      backgroundColor: AppColors.kBgCard,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.kDark),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.s48),
            Text(
              'Enter OTP',
              style: AppTypography.h2.copyWith(fontSize: 24),
            ),
            SizedBox(height: AppSpacing.s8),
            Text(
              'Sent to ${Formatters.maskPhone(widget.phone)}',
              style: AppTypography.body.copyWith(color: AppColors.kSecondary),
            ),
            SizedBox(height: AppSpacing.s24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < _otpLength; i++) _buildBox(i),
              ],
            ),
            if (_errorText != null) ...[
              SizedBox(height: AppSpacing.s12),
              Text(
                _errorText!,
                style: const TextStyle(fontSize: 12, color: AppColors.kError),
              ),
            ],
            SizedBox(height: AppSpacing.s24),
            InfoBanner(
              type: InfoBannerType.warning,
              message: 'SIMULATOR: use 123456 as OTP',
            ),
            SizedBox(height: AppSpacing.s24),
            Row(
              children: [
                Text(
                  "Didn't receive it? ",
                  style: AppTypography.body.copyWith(fontSize: 13),
                ),
                GestureDetector(
                  onTap: _secondsLeft == 0 ? _onResend : null,
                  child: Text(
                    _secondsLeft == 0
                        ? 'Resend OTP'
                        : 'Resend in 0:${_secondsLeft.toString().padLeft(2, '0')}',
                    style: AppTypography.body.copyWith(
                      fontSize: 13,
                      color: _secondsLeft == 0
                          ? AppColors.kOrange
                          : AppColors.kMuted,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.s24),
            PrimaryButton(
              label: 'Verify & Login',
              isLoading: isLoading,
              onTap: isComplete && !isLoading ? _verify : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBox(int index) {
    final controller = _controllers[index];
    final isFilled = controller.text.isNotEmpty;

    return SizedBox(
      width: 48,
      height: 56,
      child: TextField(
        controller: controller,
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppTypography.body.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.kDark,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: isFilled ? AppColors.kOrangeLight : AppColors.kBgCard,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.kBorderGray),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isFilled ? AppColors.kOrange : AppColors.kBorderGray,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.kOrange, width: 2),
          ),
        ),
        onChanged: (value) => _onDigitChanged(index, value),
        onTap: () {
          setState(() {});
        },
      ),
    );
  }
}
