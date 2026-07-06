import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/mock/mock_fixtures.dart';

part 'bulk_message_notifier.g.dart';

enum RecipientMode { all, manual }

class BulkMessageState {
  const BulkMessageState({
    required this.customers,
    required this.templates,
    this.recipientMode = RecipientMode.all,
    this.selectedCustomerIds = const {},
    this.selectedTemplate,
    this.msgCredits = MockFixtures.msgCredits,
    this.msgCreditsLimit = MockFixtures.msgCreditsMax,
    this.isSending = false,
    this.isSent = false,
    this.deliveredCount = 0,
    this.failedCount = 0,
  });

  final List<MockCustomer> customers;
  final List<MockTemplate> templates;
  final RecipientMode recipientMode;
  final Set<String> selectedCustomerIds;
  final MockTemplate? selectedTemplate;
  final int msgCredits;
  final int msgCreditsLimit;
  final bool isSending;
  final bool isSent;
  final int deliveredCount;
  final int failedCount;

  int get recipientCount => recipientMode == RecipientMode.all
      ? customers.length
      : selectedCustomerIds.length;

  int get creditsRemainingAfter => msgCredits - recipientCount;

  bool get canSend =>
      selectedTemplate != null &&
      recipientCount > 0 &&
      creditsRemainingAfter >= 0;

  BulkMessageState copyWith({
    RecipientMode? recipientMode,
    Set<String>? selectedCustomerIds,
    MockTemplate? selectedTemplate,
    bool? isSending,
    bool? isSent,
    int? deliveredCount,
    int? failedCount,
  }) {
    return BulkMessageState(
      customers: customers,
      templates: templates,
      recipientMode: recipientMode ?? this.recipientMode,
      selectedCustomerIds: selectedCustomerIds ?? this.selectedCustomerIds,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      msgCredits: msgCredits,
      msgCreditsLimit: msgCreditsLimit,
      isSending: isSending ?? this.isSending,
      isSent: isSent ?? this.isSent,
      deliveredCount: deliveredCount ?? this.deliveredCount,
      failedCount: failedCount ?? this.failedCount,
    );
  }
}

@riverpod
class BulkMessageNotifier extends _$BulkMessageNotifier {
  @override
  AsyncValue<BulkMessageState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    // TODO: replace with real customerRepository + templateRepository calls when backend ready
    await Future.delayed(const Duration(milliseconds: 600));
    state = AsyncValue.data(
      BulkMessageState(
        customers: MockFixtures.customers,
        templates: MockFixtures.templates,
      ),
    );
  }

  void setRecipientMode(RecipientMode mode) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(recipientMode: mode));
  }

  void toggleCustomer(String customerId) {
    final current = state.value;
    if (current == null) return;
    final selected = {...current.selectedCustomerIds};
    if (!selected.add(customerId)) selected.remove(customerId);
    state = AsyncValue.data(current.copyWith(selectedCustomerIds: selected));
  }

  void selectTemplate(MockTemplate template) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(selectedTemplate: template));
  }

  Future<void> send() async {
    final current = state.value;
    if (current == null || !current.canSend) return;

    state = AsyncValue.data(current.copyWith(isSending: true));
    // TODO: replace with real POST /campaigns call when backend ready
    await Future.delayed(const Duration(milliseconds: 1200));

    final total = current.recipientCount;
    final failed = total > 5 ? 2 : 0;
    state = AsyncValue.data(
      current.copyWith(
        isSending: false,
        isSent: true,
        deliveredCount: total - failed,
        failedCount: failed,
      ),
    );
  }

  void reset() {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      BulkMessageState(customers: current.customers, templates: current.templates),
    );
  }
}
