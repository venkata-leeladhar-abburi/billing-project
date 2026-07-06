import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'credits_notifier.dart';

part 'topup_notifier.g.dart';

class TopupState {
  const TopupState({
    required this.pack,
    this.isPaying = false,
    this.isPaid = false,
  });

  final TopupPack pack;
  final bool isPaying;
  final bool isPaid;

  double get gst => pack.price * 0.18;
  double get total => pack.price + gst;

  TopupState copyWith({bool? isPaying, bool? isPaid}) {
    return TopupState(
      pack: pack,
      isPaying: isPaying ?? this.isPaying,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}

@riverpod
class TopupNotifier extends _$TopupNotifier {
  @override
  AsyncValue<TopupState> build() => const AsyncValue.loading();

  void setPack(TopupPack pack) {
    if (state.value?.pack.id == pack.id) return;
    state = AsyncValue.data(TopupState(pack: pack));
  }

  Future<void> pay() async {
    final current = state.value;
    if (current == null) return;

    state = AsyncValue.data(current.copyWith(isPaying: true));
    // TODO: replace with real razorpay_flutter checkout + backend
    // POST /credits/topup/initiate + POST /credits/topup/verify when backend ready
    await Future.delayed(const Duration(milliseconds: 1200));
    state = AsyncValue.data(current.copyWith(isPaying: false, isPaid: true));
  }
}
