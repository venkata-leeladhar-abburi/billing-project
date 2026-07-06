/// TEMPORARY mock-auth holder — bypasses the real Supabase session check in
/// app_router.dart's _redirect so the mock login → OTP → dashboard flow is
/// navigable end-to-end before real Supabase auth is wired up.
/// TODO: delete this file once AuthNotifier calls real Supabase Auth.
class MockSession {
  MockSession._();

  static String? role;
}
