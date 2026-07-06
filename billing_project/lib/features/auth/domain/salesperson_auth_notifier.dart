import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/mock_session.dart';

part 'salesperson_auth_notifier.g.dart';

@riverpod
class SalespersonAuthNotifier extends _$SalespersonAuthNotifier {
  @override
  AsyncValue<String> build() {
    // TODO: replace mock with real Supabase session check when backend ready
    return AsyncValue.data(MockSession.role == 'salesperson' ? 'salesperson' : '');
  }

  Future<void> login(String phone, String password) async {
    state = const AsyncValue.loading();
    // TODO: replace mock with real Supabase Auth (phone + password) when backend ready
    await Future.delayed(const Duration(milliseconds: 800));
    if (password.length >= 4) {
      MockSession.role = 'salesperson';
      state = const AsyncValue.data('salesperson');
    } else {
      state = AsyncValue.error('Invalid mobile number or password', StackTrace.current);
    }
  }

  void logout() {
    MockSession.role = null;
    state = const AsyncValue.data('');
  }
}
