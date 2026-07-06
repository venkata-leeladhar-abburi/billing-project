import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'template_model.dart';

part 'template_detail_notifier.g.dart';

const _newTemplateId = 'new';

@riverpod
class TemplateDetailNotifier extends _$TemplateDetailNotifier {
  @override
  AsyncValue<TemplateModel> build(String templateId) {
    if (templateId == _newTemplateId) {
      return AsyncValue.data(TemplateModel(
        id: _newTemplateId,
        businessType: 'Other',
        templateName: '',
        category: TemplateCategory.marketing,
        body: '',
        status: MetaApprovalStatus.inactive,
        isActive: false,
      ));
    }
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real GET /admin/templates/:id call when backend ready
    final templates = buildMockTemplates();
    final template = templates.firstWhere((t) => t.id == templateId, orElse: () => templates.first);
    state = AsyncValue.data(template);
  }

  void updateField({
    String? businessType,
    String? templateName,
    TemplateCategory? category,
    String? header,
    String? body,
    String? footer,
  }) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(templateName: templateName, category: category, header: header, body: body, footer: footer));
  }

  void addVariable(String description) {
    final current = state.value;
    if (current == null) return;
    final nextIndex = current.variables.isEmpty ? 1 : current.variables.last.index + 1;
    state = AsyncValue.data(current.copyWith(variables: [...current.variables, TemplateVariable(index: nextIndex, description: description)]));
  }

  Future<bool> saveDraft() async {
    final current = state.value;
    if (current == null) return false;
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real PUT /admin/templates/:id call when backend ready
    state = AsyncValue.data(current);
    return true;
  }

  Future<bool> submitForApproval() async {
    final current = state.value;
    if (current == null) return false;
    state = AsyncValue.data(current.copyWith(status: MetaApprovalStatus.pending, lastUpdated: DateTime.now()));
    // TODO: replace with real AiSensy template submission call when backend ready
    await Future.delayed(const Duration(seconds: 3));
    final approved = state.value;
    if (approved == null) return false;
    state = AsyncValue.data(approved.copyWith(status: MetaApprovalStatus.approved, isActive: true, lastUpdated: DateTime.now()));
    return true;
  }
}
