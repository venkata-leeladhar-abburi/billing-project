import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'template_model.dart';

part 'templates_notifier.g.dart';

class TemplatesState {
  const TemplatesState({required this.templates, required this.aisensyConnected});

  final List<TemplateModel> templates;
  final bool aisensyConnected;
}

@riverpod
class TemplatesNotifier extends _$TemplatesNotifier {
  @override
  AsyncValue<TemplatesState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real GET /admin/templates call when backend ready
    state = AsyncValue.data(TemplatesState(templates: buildMockTemplates(), aisensyConnected: true));
  }

  void toggleActive(String templateId) {
    final current = state.value;
    if (current == null) return;
    final updated = [
      for (final t in current.templates)
        if (t.id == templateId) t.copyWith(isActive: !t.isActive) else t,
    ];
    state = AsyncValue.data(TemplatesState(templates: updated, aisensyConnected: current.aisensyConnected));
  }
}
