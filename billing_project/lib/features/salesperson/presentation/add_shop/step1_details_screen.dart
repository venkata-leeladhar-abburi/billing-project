import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_action_bar.dart';
import '../../../../shared/widgets/confirm_bottom_sheet.dart';
import '../../../../shared/widgets/input_field.dart';
import '../../../../shared/widgets/step_progress_bar.dart';
import '../../domain/add_shop_notifier.dart';

const _businessTypes = [
  'Clothing', 'Steel', 'Electronics', 'Grocery',
  'Pharmacy', 'Jewellery', 'Furniture', 'Other',
];

const _indianStates = [
  'Andhra Pradesh', 'Telangana', 'Karnataka', 'Tamil Nadu',
  'Kerala', 'Maharashtra', 'Other',
];

class Step1DetailsScreen extends ConsumerStatefulWidget {
  const Step1DetailsScreen({super.key});

  @override
  ConsumerState<Step1DetailsScreen> createState() => _Step1DetailsScreenState();
}

class _Step1DetailsScreenState extends ConsumerState<Step1DetailsScreen> {
  final _shopNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pinController = TextEditingController();
  final _gstController = TextEditingController();
  bool _sameAsMobile = true;
  String? _selectedState;
  String? _businessType;

  @override
  void dispose() {
    _shopNameController.dispose();
    _ownerNameController.dispose();
    _mobileController.dispose();
    _whatsappController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pinController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _shopNameController.text.trim().length >= 2 &&
      _ownerNameController.text.trim().length >= 2 &&
      _mobileController.text.trim().length == 10 &&
      (_sameAsMobile || _whatsappController.text.trim().length == 10) &&
      _addressController.text.trim().length >= 10 &&
      _cityController.text.trim().isNotEmpty &&
      _selectedState != null &&
      _pinController.text.trim().length == 6 &&
      _businessType != null;

  Future<void> _onCancel() async {
    final confirmed = await ConfirmBottomSheet.show(
      context,
      title: 'Discard this shop?',
      body: 'All entered details will be lost.',
      confirmLabel: 'Discard',
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      ref.read(addShopProvider.notifier).reset();
      context.go('/salesperson/dashboard');
    }
  }

  void _onNext() {
    ref.read(addShopProvider.notifier).saveStep1(
          shopName: _shopNameController.text.trim(),
          ownerName: _ownerNameController.text.trim(),
          ownerMobile: _mobileController.text.trim(),
          whatsappNumber: _whatsappController.text.trim(),
          sameAsMobile: _sameAsMobile,
          address: _addressController.text.trim(),
          city: _cityController.text.trim(),
          stateName: _selectedState!,
          pinCode: _pinController.text.trim(),
          gstNumber: _gstController.text.trim(),
          businessType: _businessType!,
        );
    context.push('/salesperson/shops/add/branding');
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('New Shop · Step 1 of 4', style: AppTypography.h3.copyWith(fontSize: 15)),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.s16),
        children: [
          StepProgressBar(
            stepLabels: const ['Details', 'Branding', 'Plan', 'AutoPay'],
            currentStep: 0,
            completedSteps: 0,
          ),
          SizedBox(height: AppSpacing.s24),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SHOP INFORMATION', style: AppTypography.labelSmall),
                SizedBox(height: AppSpacing.s16),
                InputField(
                  label: 'Shop Name',
                  isRequired: true,
                  controller: _shopNameController,
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: AppSpacing.s16),
                InputField(
                  label: 'Owner Full Name',
                  isRequired: true,
                  controller: _ownerNameController,
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: AppSpacing.s16),
                InputField(
                  label: 'Owner Mobile Number',
                  isRequired: true,
                  controller: _mobileController,
                  prefixText: '+91 ',
                  keyboardType: TextInputType.phone,
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: AppSpacing.s8),
                Row(
                  children: [
                    Checkbox(
                      value: _sameAsMobile,
                      activeColor: AppColors.kOrange,
                      onChanged: (v) => setState(() => _sameAsMobile = v ?? true),
                    ),
                    Expanded(
                      child: Text('Same as mobile number', style: AppTypography.body.copyWith(fontSize: 13)),
                    ),
                  ],
                ),
                if (!_sameAsMobile) ...[
                  InputField(
                    label: 'WhatsApp Number',
                    isRequired: true,
                    controller: _whatsappController,
                    prefixText: '+91 ',
                    keyboardType: TextInputType.phone,
                    onChanged: (_) => setState(() {}),
                  ),
                  SizedBox(height: AppSpacing.s16),
                ],
                InputField(
                  label: 'Shop Address',
                  isRequired: true,
                  controller: _addressController,
                  maxLines: 3,
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: AppSpacing.s16),
                InputField(
                  label: 'City',
                  isRequired: true,
                  controller: _cityController,
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: AppSpacing.s16),
                Text('STATE *', style: AppTypography.labelSmall),
                SizedBox(height: AppSpacing.s8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedState,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.kBgCard,
                    contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.kBorderGray)),
                  ),
                  hint: Text('Select state', style: AppTypography.bodyLarge.copyWith(color: AppColors.kMuted)),
                  items: [for (final s in _indianStates) DropdownMenuItem(value: s, child: Text(s))],
                  onChanged: (v) => setState(() => _selectedState = v),
                ),
                SizedBox(height: AppSpacing.s16),
                InputField(
                  label: 'PIN Code',
                  isRequired: true,
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.s16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BUSINESS INFORMATION', style: AppTypography.labelSmall),
                SizedBox(height: AppSpacing.s16),
                InputField(
                  label: 'GST Number (Optional)',
                  controller: _gstController,
                  placeholder: 'e.g. 37AABCS1234C1Z5',
                ),
                SizedBox(height: AppSpacing.s4),
                Text('Skip if GST not applicable', style: AppTypography.caption),
                SizedBox(height: AppSpacing.s16),
                Text('BUSINESS TYPE *', style: AppTypography.labelSmall),
                SizedBox(height: AppSpacing.s8),
                DropdownButtonFormField<String>(
                  initialValue: _businessType,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.kBgCard,
                    contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.kBorderGray)),
                  ),
                  hint: Text('Select business type', style: AppTypography.bodyLarge.copyWith(color: AppColors.kMuted)),
                  items: [for (final t in _businessTypes) DropdownMenuItem(value: t, child: Text(t))],
                  onChanged: (v) => setState(() => _businessType = v),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.s48),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        secondaryLabel: 'Step 1 of 4',
        ctaLabel: 'Next: Branding →',
        onCtaTap: _isValid ? _onNext : null,
      ),
    );
  }
}
