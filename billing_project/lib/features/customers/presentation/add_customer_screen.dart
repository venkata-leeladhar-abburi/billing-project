import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/info_banner.dart';
import '../../../shared/widgets/input_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/success_toast.dart';
import '../domain/add_customer_notifier.dart';

const _businessTypes = [
  'Clothing',
  'Steel',
  'Electronics',
  'Grocery',
  'Pharmacy',
  'Jewellery',
  'Furniture',
  'Other',
];

class AddCustomerScreen extends ConsumerStatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  String? _businessType;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get _canSave =>
      _nameController.text.trim().length >= 2 &&
      _phoneController.text.trim().length == 10;

  Future<void> _onSave({bool allowDuplicate = false}) async {
    await ref.read(addCustomerProvider.notifier).save(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          businessType: _businessType,
          notes: _notesController.text.trim(),
          allowDuplicate: allowDuplicate,
        );

    if (!mounted) return;
    final saved = ref.read(addCustomerProvider).value?.savedCustomer;
    if (saved != null) {
      SuccessToast.show(context, message: 'Customer added');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(addCustomerProvider);
    final isSaving = asyncState.value?.isSaving ?? false;
    final duplicateWarning = asyncState.value?.duplicateWarning;

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      appBar: AppBar(
        backgroundColor: AppColors.kBgCard,
        elevation: 0,
        centerTitle: true,
        leading: TextButton(
          onPressed: () => context.pop(),
          child: Text(
            'Cancel',
            style: AppTypography.body.copyWith(color: AppColors.kSecondary),
          ),
        ),
        leadingWidth: 80,
        title: Text(
          'Add Customer',
          style: AppTypography.h3.copyWith(fontSize: 17),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.s16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputField(
                  label: 'Customer Name',
                  isRequired: true,
                  controller: _nameController,
                  placeholder: 'e.g. Suresh Kumar',
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: AppSpacing.s16),
                InputField(
                  label: 'WhatsApp Number',
                  isRequired: true,
                  controller: _phoneController,
                  prefixText: '+91 ',
                  placeholder: '98765 43210',
                  keyboardType: TextInputType.phone,
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: AppSpacing.s16),
                Text('BUSINESS TYPE', style: AppTypography.labelSmall),
                SizedBox(height: AppSpacing.s8),
                DropdownButtonFormField<String>(
                  initialValue: _businessType,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.kBgCard,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.s16,
                      vertical: AppSpacing.s16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.kBorderGray),
                    ),
                  ),
                  hint: Text(
                    'Select business type',
                    style: AppTypography.bodyLarge.copyWith(color: AppColors.kMuted),
                  ),
                  items: [
                    for (final type in _businessTypes)
                      DropdownMenuItem(value: type, child: Text(type)),
                  ],
                  onChanged: (value) => setState(() => _businessType = value),
                ),
                SizedBox(height: AppSpacing.s16),
                InputField(
                  label: 'Notes (Optional)',
                  controller: _notesController,
                  placeholder: 'Add a note about this customer',
                  maxLines: 2,
                ),
              ],
            ),
          ),
          if (duplicateWarning != null) ...[
            SizedBox(height: AppSpacing.s16),
            InfoBanner(type: InfoBannerType.warning, message: duplicateWarning),
            SizedBox(height: AppSpacing.s8),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _onSave(allowDuplicate: true),
                    child: const Text('Add anyway'),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: AppSpacing.s24),
          PrimaryButton(
            label: 'Save Customer',
            isLoading: isSaving,
            onTap: _canSave && !isSaving ? () => _onSave() : null,
          ),
        ],
      ),
    );
  }
}
