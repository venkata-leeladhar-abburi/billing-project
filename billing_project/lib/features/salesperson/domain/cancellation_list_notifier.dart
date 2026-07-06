import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/cancellation_model.dart';

part 'cancellation_list_notifier.g.dart';

class CancellationListState {
  const CancellationListState({required this.requests});

  final List<CancellationRequest> requests;

  int get pendingCount => requests.where((r) => r.status == CancellationStatus.pending).length;
  int get approvedCount => requests.where((r) => r.status == CancellationStatus.approved).length;
  int get rejectedCount => requests.where((r) => r.status == CancellationStatus.rejected).length;
}

@riverpod
class CancellationListNotifier extends _$CancellationListNotifier {
  @override
  AsyncValue<CancellationListState> build() {
    Future.microtask(_loadMock);
    return const AsyncValue.loading();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real GET /cancellations call when backend ready
    state = AsyncValue.data(CancellationListState(requests: buildMockCancellationRequests()));
  }
}
