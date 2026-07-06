import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/mock_session.dart';

part 'admin_auth_notifier.g.dart';

@riverpod
class AdminAuthNotifier extends _$AdminAuthNotifier {
  @override
  AsyncValue<String> build() {
    return AsyncValue.data(MockSession.role == 'super_admin' ? 'super_admin' : '');
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 800));
    // TODO: replace with real Supabase Auth (email/password) call when backend ready
    if (password.length >= 6 && email.contains('@')) {
      MockSession.role = 'super_admin';
      state = const AsyncValue.data('super_admin');
    } else {
      state = AsyncValue.error('Invalid email or password', StackTrace.current);
    }
  }

  void logout() {
    MockSession.role = null;
    state = const AsyncValue.data('');
  }
}
