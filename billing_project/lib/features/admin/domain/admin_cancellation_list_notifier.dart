import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/cancellation_model.dart';

part 'admin_cancellation_list_notifier.g.dart';

enum CancellationSort { newest, oldest, planValue }

class AdminCancellationListState {
  const AdminCancellationListState({required this.requests, this.sort = CancellationSort.newest});

  final List<CancellationRequest> requests;
  final CancellationSort sort;

  int get pendingCount => requests.where((r) => r.status == CancellationStatus.pending).length;
  int get approvedCount => requests.where((r) => r.status == CancellationStatus.approved).length;
  int get rejectedCount => requests.where((r) => r.status == CancellationStatus.rejected).length;

  List<CancellationRequest> get sorted {
    final list = List<CancellationRequest>.of(requests);
    switch (sort) {
      case CancellationSort.newest:
        list.sort((a, b) => b.requestedDate.compareTo(a.requestedDate));
      case CancellationSort.oldest:
        list.sort((a, b) => a.requestedDate.compareTo(b.requestedDate));
      case CancellationSort.planValue:
        list.sort((a, b) => b.monthlyAmount.compareTo(a.monthlyAmount));
    }
    return list;
  }
}

@riverpod
class AdminCancellationListNotifier extends _$AdminCancellationListNotifier {
  @override
  AsyncValue<AdminCancellationListState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real GET /admin/cancellations call when backend ready
    state = AsyncValue.data(AdminCancellationListState(requests: buildMockCancellationRequests()));
  }

  void setSort(CancellationSort sort) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(AdminCancellationListState(requests: current.requests, sort: sort));
  }
}
