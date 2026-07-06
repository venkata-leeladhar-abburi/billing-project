import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/models/shop_model.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/bottom_action_bar.dart';
import '../../../shared/widgets/confirm_bottom_sheet.dart';
import '../../../shared/widgets/input_field.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/plan_badge.dart';
import '../../../shared/widgets/success_toast.dart';
import '../domain/edit_shop_notifier.dart';

const _businessTypes = ['Clothing', 'Steel', 'Electronics', 'Grocery', 'Pharmacy', 'Jewellery', 'Furniture', 'Other'];
const _indianStates = ['Andhra Pradesh', 'Telangana', 'Karnataka', 'Tamil Nadu', 'Kerala', 'Maharashtra', 'Other'];

class EditShopScreen extends ConsumerStatefulWidget {
  const EditShopScreen({required this.shopId, super.key});

  final String shopId;

  @override
  ConsumerState<EditShopScreen> createState() => _EditShopScreenState();
}

class _EditShopScreenState extends ConsumerState<EditShopScreen> {
  final _shopNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pinController = TextEditingController();
  final _gstController = TextEditingController();
  String? _selectedState;
  String? _businessType;
  bool _initialized = false;
  bool _dirty = false;

  @override
  void dispose() {
    _shopNameController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pinController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  void _seedFrom(ShopModel shop) {
    if (_initialized) return;
    _initialized = true;
    _shopNameController.text = shop.shopName;
    _ownerNameController.text = shop.ownerName;
    _phoneController.text = shop.phone.replaceFirst('+91', '').trim();
    _whatsappController.text = shop.whatsappNumber.replaceFirst('+91', '').trim();
    _addressController.text = shop.address;
    _cityController.text = shop.city;
    _pinController.text = shop.pinCode;
    _gstController.text = shop.gstNumber ?? '';
    _selectedState = shop.state;
    _businessType = shop.businessType;
  }

  Future<void> _onCancel() async {
    if (!_dirty) {
      context.pop();
      return;
    }
    final confirmed = await ConfirmBottomSheet.show(
      context,
      title: 'Discard changes?',
      body: 'Your edits to this shop will be lost.',
      confirmLabel: 'Discard',
      isDestructive: true,
    );
    if (confirmed == true && mounted) context.pop();
  }

  Future<void> _onSave() async {
    final notifier = ref.read(editShopProvider(widget.shopId).notifier);
    notifier.updateField(
      shopName: _shopNameController.text.trim(),
      ownerName: _ownerNameController.text.trim(),
      phone: '+91${_phoneController.text.trim()}',
      whatsappNumber: '+91${_whatsappController.text.trim()}',
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      stateName: _selectedState,
      pinCode: _pinController.text.trim(),
      gstNumber: _gstController.text.trim(),
      businessType: _businessType,
    );
    final ok = await notifier.save();
    if (ok && mounted) {
      SuccessToast.show(context, message: 'Shop updated');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editShopProvider(widget.shopId));

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
        title: Text('Edit Shop', style: AppTypography.h3.copyWith(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: _onSave,
            child: Text('Save', style: AppTypography.body.copyWith(color: AppColors.kOrange, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (shop) {
          _seedFrom(shop);
          return ListView(
            padding: EdgeInsets.all(AppSpacing.s16),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SHOP INFORMATION', style: AppTypography.labelSmall),
                    SizedBox(height: AppSpacing.s16),
                    InputField(label: 'Shop Name', isRequired: true, controller: _shopNameController, onChanged: (_) => _dirty = true),
                    SizedBox(height: AppSpacing.s16),
                    InputField(label: 'Owner Full Name', isRequired: true, controller: _ownerNameController, onChanged: (_) => _dirty = true),
                    SizedBox(height: AppSpacing.s16),
                    InputField(label: 'Owner Mobile Number', isRequired: true, controller: _phoneController, prefixText: '+91 ', keyboardType: TextInputType.phone, onChanged: (_) => _dirty = true),
                    SizedBox(height: AppSpacing.s16),
                    InputField(label: 'WhatsApp Number', isRequired: true, controller: _whatsappController, prefixText: '+91 ', keyboardType: TextInputType.phone, onChanged: (_) => _dirty = true),
                    SizedBox(height: AppSpacing.s16),
                    InputField(label: 'Shop Address', isRequired: true, controller: _addressController, maxLines: 3, onChanged: (_) => _dirty = true),
                    SizedBox(height: AppSpacing.s16),
                    InputField(label: 'City', isRequired: true, controller: _cityController, onChanged: (_) => _dirty = true),
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
                      items: [for (final s in _indianStates) DropdownMenuItem(value: s, child: Text(s))],
                      onChanged: (v) => setState(() {
                        _selectedState = v;
                        _dirty = true;
                      }),
                    ),
                    SizedBox(height: AppSpacing.s16),
                    InputField(label: 'PIN Code', isRequired: true, controller: _pinController, keyboardType: TextInputType.number, onChanged: (_) => _dirty = true),
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
                    InputField(label: 'GST Number (Optional)', controller: _gstController, onChanged: (_) => _dirty = true),
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
                      items: [for (final t in _businessTypes) DropdownMenuItem(value: t, child: Text(t))],
                      onChanged: (v) => setState(() {
                        _businessType = v;
                        _dirty = true;
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.s16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SUBSCRIPTION PLAN', style: AppTypography.labelSmall),
                    SizedBox(height: AppSpacing.s12),
                    Row(
                      children: [
                        for (final plan in SubscriptionPlan.values) ...[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                ref.read(editShopProvider(widget.shopId).notifier).changePlan(plan);
                                _dirty = true;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: AppSpacing.s12),
                                margin: EdgeInsets.only(right: plan == SubscriptionPlan.business ? 0 : AppSpacing.s8),
                                decoration: BoxDecoration(
                                  color: shop.plan == plan ? AppColors.kOrangeLight : AppColors.kBgPage,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: shop.plan == plan ? AppColors.kOrange : AppColors.kBorderGray),
                                ),
                                alignment: Alignment.center,
                                child: PlanBadge(plan: plan),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: AppSpacing.s8),
                    Text('WhatsApp template: ${shop.templateName}', style: AppTypography.caption),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.s48),
            ],
          );
        },
      ),
      bottomNavigationBar: state.hasValue
          ? BottomActionBar(
              secondaryLabel: 'Editing ${state.value!.shopName}',
              ctaLabel: 'Save Changes',
              onCtaTap: _onSave,
            )
          : null,
    );
  }
}
