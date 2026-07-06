import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/cancellation_model.dart';

part 'admin_cancellation_detail_notifier.g.dart';

@riverpod
class AdminCancellationDetailNotifier extends _$AdminCancellationDetailNotifier {
  @override
  AsyncValue<CancellationRequest> build(String requestId) {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real GET /admin/cancellations/:id call when backend ready
    final requests = buildMockCancellationRequests();
    final request = requests.firstWhere((r) => r.id == requestId, orElse: () => requests.first);
    state = AsyncValue.data(request);
  }

  Future<void> approve({String adminNotes = ''}) async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 800));
    // TODO: replace with real POST /admin/subscriptions/:id/cancel call when backend ready
    // (cancels the Razorpay AutoPay mandate + updates shop status)
    state = AsyncValue.data(current.copyWith(status: CancellationStatus.approved, adminNotes: adminNotes));
  }

  Future<void> reject({String adminNotes = ''}) async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 800));
    // TODO: replace with real POST /admin/cancellations/:id/reject call when backend ready
    state = AsyncValue.data(current.copyWith(status: CancellationStatus.rejected, adminNotes: adminNotes));
  }
}
