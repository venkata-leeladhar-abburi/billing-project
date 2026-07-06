import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_salesperson_notifier.g.dart';

class AddSalespersonState {
  const AddSalespersonState({
    this.fullName = '',
    this.mobile = '',
    this.email = '',
    this.cityRegion = '',
    this.notes = '',
    this.password = '',
    this.confirmPassword = '',
    this.isSubmitting = false,
  });

  final String fullName;
  final String mobile;
  final String email;
  final String cityRegion;
  final String notes;
  final String password;
  final String confirmPassword;
  final bool isSubmitting;

  bool get _passwordValid => password.length >= 8 && RegExp(r'[0-9]').hasMatch(password) && RegExp(r'[A-Z]').hasMatch(password);

  bool get canSubmit =>
      fullName.trim().length >= 2 &&
      mobile.trim().length == 10 &&
      cityRegion.trim().isNotEmpty &&
      _passwordValid &&
      password == confirmPassword &&
      !isSubmitting;

  AddSalespersonState copyWith({
    String? fullName,
    String? mobile,
    String? email,
    String? cityRegion,
    String? notes,
    String? password,
    String? confirmPassword,
    bool? isSubmitting,
  }) {
    return AddSalespersonState(
      fullName: fullName ?? this.fullName,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      cityRegion: cityRegion ?? this.cityRegion,
      notes: notes ?? this.notes,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

@riverpod
class AddSalespersonNotifier extends _$AddSalespersonNotifier {
  @override
  AddSalespersonState build() => const AddSalespersonState();

  void updateField({
    String? fullName,
    String? mobile,
    String? email,
    String? cityRegion,
    String? notes,
    String? password,
    String? confirmPassword,
  }) {
    state = state.copyWith(
      fullName: fullName,
      mobile: mobile,
      email: email,
      cityRegion: cityRegion,
      notes: notes,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  Future<bool> create() async {
    state = state.copyWith(isSubmitting: true);
    await Future.delayed(const Duration(milliseconds: 800));
    // TODO: replace with real POST /admin/salespersons call when backend ready
    state = state.copyWith(isSubmitting: false);
    return true;
  }

  void reset() => state = const AddSalespersonState();
}
