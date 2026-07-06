import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/success_toast.dart';
import '../domain/template_detail_notifier.dart';
import '../domain/template_model.dart';

const _businessTypes = ['Clothing', 'Steel', 'Electronics', 'Grocery', 'Pharmacy', 'Jewellery', 'Furniture', 'Other'];

class TemplateDetailScreen extends ConsumerStatefulWidget {
  const TemplateDetailScreen({required this.templateId, super.key});

  final String templateId;

  @override
  ConsumerState<TemplateDetailScreen> createState() => _TemplateDetailScreenState();
}

class _TemplateDetailScreenState extends ConsumerState<TemplateDetailScreen> {
  final _nameController = TextEditingController();
  final _bodyController = TextEditingController();
  final _footerController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _bodyController.dispose();
    _footerController.dispose();
    super.dispose();
  }

  void _seedFrom(TemplateModel t) {
    if (_initialized) return;
    _initialized = true;
    _nameController.text = t.templateName;
    _bodyController.text = t.body;
    _footerController.text = t.footer;
  }

  void _sync() {
    ref.read(templateDetailProvider(widget.templateId).notifier).updateField(
          templateName: _nameController.text,
          body: _bodyController.text,
          footer: _footerController.text,
        );
    setState(() {});
  }

  String _previewText(String body) {
    return body.replaceAll('{{1}}', 'Raju Silks').replaceAll('{{2}}', '30%').replaceAll('{{3}}', 'Suresh Kumar');
  }

  String _statusLabel(MetaApprovalStatus status) {
    switch (status) {
      case MetaApprovalStatus.approved:
        return '✓ Approved by Meta';
      case MetaApprovalStatus.pending:
        return '⏳ Pending Meta Approval';
      case MetaApprovalStatus.rejected:
        return '✗ Rejected — See reason below';
      case MetaApprovalStatus.inactive:
        return 'Draft';
    }
  }

  Color _statusColor(MetaApprovalStatus status) {
    switch (status) {
      case MetaApprovalStatus.approved:
        return AppColors.kGreen;
      case MetaApprovalStatus.pending:
        return AppColors.kWarning;
      case MetaApprovalStatus.rejected:
        return AppColors.kError;
      case MetaApprovalStatus.inactive:
        return AppColors.kMuted;
    }
  }

  Future<void> _onSaveDraft() async {
    final ok = await ref.read(templateDetailProvider(widget.templateId).notifier).saveDraft();
    if (ok && mounted) SuccessToast.show(context, message: 'Draft saved');
  }

  Future<void> _onSubmit() async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.s16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This will submit the template to Meta for approval. If already approved, editing requires re-approval.',
                textAlign: TextAlign.center,
                style: AppTypography.body,
              ),
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
    if (confirmed != true || !mounted) return;
    SuccessToast.show(context, message: 'Template submitted for approval');
    await ref.read(templateDetailProvider(widget.templateId).notifier).submitForApproval();
    if (mounted) SuccessToast.show(context, message: 'Template approved by Meta ✓');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(templateDetailProvider(widget.templateId));
    final isNew = widget.templateId == 'new';

    return Scaffold(
      backgroundColor: AppColors.kBgPage,
      body: state.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text('Failed to load: $e')),
        data: (t) {
          _seedFrom(t);
          return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    GradientHeader(
                      type: GradientHeaderType.orange,
                      showBackButton: true,
                      height: 100,
                      title: '${t.businessType} Template',
                    ),
                    Padding(
                      padding: EdgeInsets.all(AppSpacing.s16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isNew) ...[
                            AppCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s8),
                                    decoration: BoxDecoration(color: _statusColor(t.status).withValues(alpha: 0.12), borderRadius: AppSpacing.rPill),
                                    child: Text(_statusLabel(t.status), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _statusColor(t.status))),
                                  ),
                                  SizedBox(height: AppSpacing.s12),
                                  Text('Template ID: ${t.aisensyTemplateId}', style: AppTypography.caption.copyWith(fontFamily: AppTypography.kFontMono, fontSize: 12)),
                                  if (t.lastUpdated != null) ...[
                                    SizedBox(height: AppSpacing.s4),
                                    Text('Last updated: ${t.lastUpdated!.day}/${t.lastUpdated!.month}/${t.lastUpdated!.year}', style: AppTypography.caption),
                                  ],
                                  if (t.status == MetaApprovalStatus.rejected && t.rejectionReason != null) ...[
                                    SizedBox(height: AppSpacing.s12),
                                    Container(
                                      padding: EdgeInsets.all(AppSpacing.s12),
                                      decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(8)),
                                      child: Text(t.rejectionReason!, style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kError)),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(height: AppSpacing.s16),
                          ],
                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TEMPLATE DETAILS', style: AppTypography.labelSmall),
                                SizedBox(height: AppSpacing.s16),
                                Text('TEMPLATE NAME', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                                SizedBox(height: AppSpacing.s8),
                                TextField(
                                  controller: _nameController,
                                  onChanged: (_) => _sync(),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: AppColors.kBgPage,
                                    hintText: 'e.g. clothing_festival_offer',
                                    contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.s4),
                                Text('Must be lowercase, underscores only', style: AppTypography.caption.copyWith(fontSize: 11)),
                                SizedBox(height: AppSpacing.s16),
                                Text('BUSINESS TYPE', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                                SizedBox(height: AppSpacing.s8),
                                DropdownButtonFormField<String>(
                                  initialValue: _businessTypes.contains(t.businessType) ? t.businessType : 'Other',
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: isNew ? AppColors.kBgPage : const Color(0xFFFAFAFA),
                                    contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  items: [for (final b in _businessTypes) DropdownMenuItem(value: b, child: Text(b))],
                                  onChanged: isNew ? (_) {} : null,
                                ),
                                SizedBox(height: AppSpacing.s16),
                                Text('CATEGORY', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                                SizedBox(height: AppSpacing.s8),
                                DropdownButtonFormField<TemplateCategory>(
                                  initialValue: t.category,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: AppColors.kBgPage,
                                    contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: TemplateCategory.marketing, child: Text('Marketing')),
                                    DropdownMenuItem(value: TemplateCategory.utility, child: Text('Utility')),
                                  ],
                                  onChanged: (v) {
                                    if (v != null) ref.read(templateDetailProvider(widget.templateId).notifier).updateField(category: v);
                                  },
                                ),
                                SizedBox(height: AppSpacing.s4),
                                Text(
                                  t.category == TemplateCategory.marketing ? 'Marketing: ₹0.86/msg' : 'Utility: ₹0.12/msg',
                                  style: AppTypography.caption.copyWith(fontSize: 11),
                                ),
                                SizedBox(height: AppSpacing.s16),
                                Text('TEMPLATE LANGUAGE', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                                SizedBox(height: AppSpacing.s8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
                                  decoration: BoxDecoration(color: const Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.kBorderGray)),
                                  child: Text('English (en)', style: AppTypography.bodyLarge),
                                ),
                                SizedBox(height: AppSpacing.s16),
                                Text('TEMPLATE BODY *', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                                SizedBox(height: AppSpacing.s8),
                                TextField(
                                  controller: _bodyController,
                                  maxLines: 5,
                                  maxLength: 1024,
                                  onChanged: (_) => _sync(),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.kBgPage,
                                    hintText: 'e.g. New arrivals at {{1}}! Visit us for {{2}} off.',
                                    contentPadding: EdgeInsets.all(AppSpacing.s16),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                                Text('Use {{1}}, {{2}} for dynamic variables', style: AppTypography.caption.copyWith(fontSize: 11)),
                                SizedBox(height: AppSpacing.s16),
                                Text('TEMPLATE FOOTER (OPTIONAL)', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                                SizedBox(height: AppSpacing.s8),
                                TextField(
                                  controller: _footerController,
                                  onChanged: (_) => _sync(),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: AppColors.kBgPage,
                                    hintText: 'e.g. Billing Project · Reply STOP to opt out',
                                    contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.s16),
                                Text('VARIABLES', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                                SizedBox(height: AppSpacing.s8),
                                for (final v in t.variables)
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: 2),
                                          decoration: BoxDecoration(color: AppColors.kOrangeLight, borderRadius: BorderRadius.circular(4)),
                                          child: Text('{{${v.index}}}', style: const TextStyle(fontSize: 12, color: AppColors.kOrange)),
                                        ),
                                        SizedBox(width: AppSpacing.s8),
                                        Expanded(child: Text(v.description, style: AppTypography.body.copyWith(fontSize: 13))),
                                      ],
                                    ),
                                  ),
                                SizedBox(height: AppSpacing.s8),
                                GestureDetector(
                                  onTap: () => ref.read(templateDetailProvider(widget.templateId).notifier).addVariable('New variable'),
                                  child: Text('+ Add Variable', style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kOrange)),
                                ),
                                SizedBox(height: AppSpacing.s4),
                                Text('Variables must match what your backend sends to AiSensy', style: AppTypography.caption.copyWith(fontSize: 11)),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSpacing.s16),
                          AppCard(
                            backgroundColor: const Color(0xFFF0F0F0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('LIVE PREVIEW', style: AppTypography.labelSmall),
                                SizedBox(height: AppSpacing.s12),
                                Container(
                                  padding: EdgeInsets.all(AppSpacing.s12),
                                  decoration: BoxDecoration(color: const Color(0xFFDCF8C6), borderRadius: BorderRadius.circular(12)),
                                  child: Text(
                                    _previewText(_bodyController.text.isEmpty ? 'Your template preview will appear here.' : _bodyController.text),
                                    style: AppTypography.body.copyWith(fontSize: 14, color: AppColors.kDark),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.s8),
                                Text('This is how recipients will see the message', style: AppTypography.caption.copyWith(fontSize: 11)),
                              ],
                            ),
                          ),
                          if (!isNew) ...[
                            SizedBox(height: AppSpacing.s16),
                            AppCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ASSIGNED TO', style: AppTypography.labelSmall),
                                  SizedBox(height: AppSpacing.s8),
                                  Text('Shops of type ${t.businessType} are using this template', style: AppTypography.body.copyWith(fontSize: 13)),
                                  SizedBox(height: AppSpacing.s8),
                                  GestureDetector(
                                    onTap: () => context.push('/admin/shops'),
                                    child: Text('View all shops →', style: AppTypography.body.copyWith(fontSize: 13, color: AppColors.kOrange)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          SizedBox(height: AppSpacing.s48),
                        ],
                      ),
                    ),
                  ],
          );
        },
      ),
      bottomNavigationBar: state.hasValue
          ? Container(
              padding: EdgeInsets.all(AppSpacing.s16),
              decoration: const BoxDecoration(color: AppColors.kBgCard, border: Border(top: BorderSide(color: AppColors.kBorderGray))),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        state.value!.category == TemplateCategory.marketing ? 'Marketing: ₹0.86/msg' : 'Utility: ₹0.12/msg',
                        style: AppTypography.caption,
                      ),
                    ),
                    SizedBox(height: AppSpacing.s8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _onSaveDraft,
                            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                            child: const Text('Save Draft'),
                          ),
                        ),
                        SizedBox(width: AppSpacing.s12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _bodyController.text.trim().isNotEmpty ? _onSubmit : null,
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.kOrange, minimumSize: const Size.fromHeight(48)),
                            child: const Text('Submit for Approval', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
