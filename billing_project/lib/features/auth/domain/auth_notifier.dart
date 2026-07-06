import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/mock_session.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<String> build() {
    // TODO: replace mock with real Supabase session check when backend ready
    return AsyncValue.data(MockSession.role ?? '');
  }

  Future<void> requestOtp(String phone) async {
    state = const AsyncValue.loading();
    // TODO: replace mock with real Supabase OTP request when backend ready
    await Future.delayed(const Duration(milliseconds: 800));
    state = const AsyncValue.data('otp_sent');
  }

  Future<void> verifyOtp(String phone, String token) async {
    state = const AsyncValue.loading();
    // TODO: replace mock with real Supabase OTP verification when backend ready
    await Future.delayed(const Duration(milliseconds: 600));
    if (token == '123456') {
      MockSession.role = 'shopkeeper';
      state = const AsyncValue.data('shopkeeper');
    } else {
      state = AsyncValue.error('Invalid OTP', StackTrace.current);
    }
  }

  void logout() {
    MockSession.role = null;
    state = const AsyncValue.data('');
  }
}
