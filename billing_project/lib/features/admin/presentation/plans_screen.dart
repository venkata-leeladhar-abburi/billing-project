import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/plan_badge.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../../shared/widgets/success_toast.dart';
import '../domain/plans_notifier.dart';

class PlansScreen extends ConsumerWidget {
  const PlansScreen({super.key});

  Future<void> _confirmSave(BuildContext context, WidgetRef ref) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.s16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure? New subscriptions will use these prices.', textAlign: TextAlign.center, style: AppTypography.body),
              SizedBox(height: AppSpacing.s16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(sheetContext).pop(true),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.kOrange, minimumSize: const Size.fromHeight(48)),
                  child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed == true) {
      await ref.read(plansProvider.notifier).savePlans();
      if (context.mounted) SuccessToast.show(context, message: 'Plans updated');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(plansProvider);

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
        title: Text('Subscription Plans', style: AppTypography.h3.copyWith(fontSize: 17)),
        actions: [
          if (state.hasValue)
            IconButton(
              icon: Icon(state.value!.isEditMode ? Icons.close : Icons.edit_outlined, color: AppColors.kDark),
              onPressed: () {
                if (state.value!.isEditMode) {
                  ref.read(plansProvider.notifier).cancelEdit();
                } else {
                  ref.read(plansProvider.notifier).enterEditMode();
                }
              },
            ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (data) {
          final editMode = data.isEditMode;
          return ListView(
            padding: EdgeInsets.all(AppSpacing.s16),
            children: [
              AppCard(
                leftBorderColor: AppColors.kWarning,
                child: Text(
                  'Changes to plan pricing and limits affect ALL new subscriptions immediately. Existing subscriptions renew at the price they signed up for.',
                  style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kWarning),
                ),
              ),
              SizedBox(height: AppSpacing.s16),
              for (var i = 0; i < data.displayPlans.length; i++) ...[
                _PlanCard(
                  config: data.displayPlans[i],
                  isEditMode: editMode,
                  shopCount: data.shopCountFor(data.displayPlans[i].plan),
                  onChanged: (updated) => ref.read(plansProvider.notifier).updateDraftPlan(i, updated),
                ),
                SizedBox(height: AppSpacing.s12),
              ],
              SizedBox(height: AppSpacing.s4),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CREDIT TOP-UP PACKS', style: AppTypography.labelSmall),
                    SizedBox(height: AppSpacing.s12),
                    for (var i = 0; i < data.displayPacks.length; i++) ...[
                      _PackRow(
                        pack: data.displayPacks[i],
                        isEditMode: editMode,
                        onChanged: (updated) => ref.read(plansProvider.notifier).updateDraftPack(i, updated),
                      ),
                      if (i != data.displayPacks.length - 1) const Divider(height: 16),
                    ],
                    SizedBox(height: AppSpacing.s12),
                    Text('Your AiSensy cost: ₹0.86/marketing msg · ₹0.12/utility msg', style: AppTypography.caption.copyWith(fontSize: 11)),
                  ],
                ),
              ),
              if (editMode) ...[
                SizedBox(height: AppSpacing.s24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _confirmSave(context, ref),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.kOrange, minimumSize: const Size.fromHeight(52)),
                    child: const Text('Save Plan Changes', style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: AppSpacing.s12),
                SecondaryButton(label: 'Cancel', onTap: () => ref.read(plansProvider.notifier).cancelEdit()),
              ],
              SizedBox(height: AppSpacing.s24),
            ],
          );
        },
      ),
    );
  }
}

class _PlanCard extends StatefulWidget {
  const _PlanCard({required this.config, required this.isEditMode, required this.shopCount, required this.onChanged});

  final PlanConfig config;
  final bool isEditMode;
  final int shopCount;
  final ValueChanged<PlanConfig> onChanged;

  @override
  State<_PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<_PlanCard> {
  late final _priceController = TextEditingController(text: widget.config.price.toStringAsFixed(0));
  late final _billController = TextEditingController(text: widget.config.billCreditsLimit >= 99999 ? '' : '${widget.config.billCreditsLimit}');
  late final _msgController = TextEditingController(text: '${widget.config.msgCreditsLimit}');

  @override
  void dispose() {
    _priceController.dispose();
    _billController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  void _emit() {
    widget.onChanged(widget.config.copyWith(
      price: double.tryParse(_priceController.text) ?? widget.config.price,
      billCreditsLimit: widget.config.billCreditsLimit >= 99999 ? null : (int.tryParse(_billController.text) ?? widget.config.billCreditsLimit),
      msgCreditsLimit: int.tryParse(_msgController.text) ?? widget.config.msgCreditsLimit,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PlanBadge(plan: config.plan, isLarge: true),
              widget.isEditMode
                  ? SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        onChanged: (_) => _emit(),
                        decoration: const InputDecoration(prefixText: '₹', isDense: true),
                        style: AppTypography.body.copyWith(fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                    )
                  : Text(Formatters.formatINR(config.price), style: AppTypography.body.copyWith(fontSize: 22, fontWeight: FontWeight.w700)),
            ],
          ),
          SizedBox(height: AppSpacing.s16),
          _LimitRow(
            label: 'Bill Credits/month',
            value: config.billCreditsLimit >= 99999 ? '∞' : '${config.billCreditsLimit}',
            isEditMode: widget.isEditMode && config.billCreditsLimit < 99999,
            controller: _billController,
            onChanged: _emit,
          ),
          _LimitRow(label: 'Msg Credits/month', value: '${config.msgCreditsLimit}', isEditMode: widget.isEditMode, controller: _msgController, onChanged: _emit),
          _LimitRow(label: 'Customer Limit', value: config.customerLimit == null ? '∞' : '${config.customerLimit}', isEditMode: false, controller: null, onChanged: null),
          _LimitRow(label: 'Bill History', value: config.billHistoryMonths == null ? 'Unlimited' : '${config.billHistoryMonths} months', isEditMode: false, controller: null, onChanged: null),
          SizedBox(height: AppSpacing.s12),
          const Divider(),
          SizedBox(height: AppSpacing.s8),
          Text('${widget.shopCount} active shops on this plan', style: AppTypography.caption),
          SizedBox(height: AppSpacing.s4),
          Text('${Formatters.formatINR(config.price * widget.shopCount)}/month total', style: AppTypography.body.copyWith(fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _LimitRow extends StatelessWidget {
  const _LimitRow({required this.label, required this.value, required this.isEditMode, this.controller, this.onChanged});

  final String label;
  final String value;
  final bool isEditMode;
  final TextEditingController? controller;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption),
          isEditMode && controller != null
              ? SizedBox(
                  width: 80,
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    onChanged: (_) => onChanged?.call(),
                    decoration: const InputDecoration(isDense: true),
                    style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                )
              : Text(value, style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _PackRow extends StatefulWidget {
  const _PackRow({required this.pack, required this.isEditMode, required this.onChanged});

  final TopupPackConfig pack;
  final bool isEditMode;
  final ValueChanged<TopupPackConfig> onChanged;

  @override
  State<_PackRow> createState() => _PackRowState();
}

class _PackRowState extends State<_PackRow> {
  late final _priceController = TextEditingController(text: widget.pack.price.toStringAsFixed(0));

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pack = widget.pack;
    return Row(
      children: [
        Expanded(flex: 2, child: Text(pack.name, style: AppTypography.body.copyWith(fontSize: 13))),
        Expanded(child: Text('${pack.credits}', style: AppTypography.body.copyWith(fontSize: 13))),
        Expanded(
          child: widget.isEditMode
              ? TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => widget.onChanged(pack.copyWith(price: double.tryParse(v) ?? pack.price)),
                  decoration: const InputDecoration(isDense: true, prefixText: '₹'),
                  style: AppTypography.body.copyWith(fontSize: 13),
                )
              : Text(Formatters.formatINR(pack.price), style: AppTypography.body.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
        ),
        Expanded(child: Text('₹${pack.costPerCredit.toStringAsFixed(2)}', style: AppTypography.caption.copyWith(fontSize: 11))),
      ],
    );
  }
}
