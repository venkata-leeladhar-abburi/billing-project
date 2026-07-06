import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/cancellation_model.dart';

part 'cancellation_detail_notifier.g.dart';

@riverpod
class CancellationDetailNotifier extends _$CancellationDetailNotifier {
  @override
  AsyncValue<CancellationRequest> build(String requestId) {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real GET /cancellations/:id call when backend ready
    final requests = buildMockCancellationRequests();
    final request = requests.firstWhere((r) => r.id == requestId, orElse: () => requests.first);
    state = AsyncValue.data(request);
  }

  Future<void> approve({String notes = ''}) async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 700));
    // TODO: replace with real POST /cancellations/:id/approve call when backend ready
    state = AsyncValue.data(current.copyWith(status: CancellationStatus.approved, notes: notes));
  }

  Future<void> reject({String notes = ''}) async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 700));
    // TODO: replace with real POST /cancellations/:id/reject call when backend ready
    state = AsyncValue.data(current.copyWith(status: CancellationStatus.rejected, notes: notes));
  }
}
