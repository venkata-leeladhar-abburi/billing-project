import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/customer_model.dart';

part 'add_customer_notifier.g.dart';

class AddCustomerState {
  const AddCustomerState({
    this.isSaving = false,
    this.savedCustomer,
    this.duplicateWarning,
  });

  final bool isSaving;
  final CustomerModel? savedCustomer;
  final String? duplicateWarning;

  AddCustomerState copyWith({
    bool? isSaving,
    CustomerModel? savedCustomer,
    String? duplicateWarning,
    bool clearWarning = false,
  }) {
    return AddCustomerState(
      isSaving: isSaving ?? this.isSaving,
      savedCustomer: savedCustomer ?? this.savedCustomer,
      duplicateWarning: clearWarning ? null : (duplicateWarning ?? this.duplicateWarning),
    );
  }
}

@riverpod
class AddCustomerNotifier extends _$AddCustomerNotifier {
  @override
  AsyncValue<AddCustomerState> build() {
    return const AsyncValue.data(AddCustomerState());
  }

  Future<void> save({
    required String name,
    required String phone,
    String? businessType,
    String? notes,
    bool allowDuplicate = false,
  }) async {
    final current = state.value;
    if (current == null) return;

    state = AsyncValue.data(current.copyWith(isSaving: true, clearWarning: true));
    // TODO: replace with real POST /customers call when backend ready
    await Future.delayed(const Duration(milliseconds: 600));

    if (!allowDuplicate && phone == '9876543210') {
      state = AsyncValue.data(
        current.copyWith(
          isSaving: false,
          duplicateWarning: 'A customer with this number already exists: Suresh Kumar',
        ),
      );
      return;
    }

    final customer = CustomerModel(
      id: 'new_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      phone: phone,
      billCount: 0,
      totalBilled: 0,
      addedAt: DateTime.now(),
    );

    state = AsyncValue.data(
      current.copyWith(isSaving: false, savedCustomer: customer),
    );
  }
}
