import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cancel_request_notifier.g.dart';

enum CancelReason { noLongerNeeded, tooExpensive, switchingApp, technicalIssues, other }

class CancelRequestState {
  const CancelRequestState({
    this.reason,
    this.customReason = '',
    this.confirmed = false,
    this.isSubmitting = false,
    this.requestId,
    this.submittedAt,
  });

  final CancelReason? reason;
  final String customReason;
  final bool confirmed;
  final bool isSubmitting;
  final String? requestId;
  final DateTime? submittedAt;

  bool get canSubmit =>
      reason != null &&
      confirmed &&
      (reason != CancelReason.other || customReason.trim().isNotEmpty);

  CancelRequestState copyWith({
    CancelReason? reason,
    String? customReason,
    bool? confirmed,
    bool? isSubmitting,
    String? requestId,
    DateTime? submittedAt,
  }) {
    return CancelRequestState(
      reason: reason ?? this.reason,
      customReason: customReason ?? this.customReason,
      confirmed: confirmed ?? this.confirmed,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      requestId: requestId ?? this.requestId,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }
}

@riverpod
class CancelRequestNotifier extends _$CancelRequestNotifier {
  @override
  AsyncValue<CancelRequestState> build() =>
      const AsyncValue.data(CancelRequestState());

  void setReason(CancelReason reason) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(reason: reason));
  }

  void setCustomReason(String text) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(customReason: text));
  }

  void setConfirmed(bool value) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(confirmed: value));
  }

  Future<void> submit() async {
    final current = state.value;
    if (current == null || !current.canSubmit) return;

    state = AsyncValue.data(current.copyWith(isSubmitting: true));
    // TODO: replace with real POST /cancellation-requests call when backend ready
    await Future.delayed(const Duration(milliseconds: 800));
    state = AsyncValue.data(
      current.copyWith(
        isSubmitting: false,
        requestId: 'REQ-${DateTime.now().millisecondsSinceEpoch % 100000}',
        submittedAt: DateTime.now(),
      ),
    );
  }
}
