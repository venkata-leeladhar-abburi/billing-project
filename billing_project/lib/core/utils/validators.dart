class Validators {
  Validators._();

  static final RegExp _phoneRegex = RegExp(r'^[6-9]\d{9}$');
  static final RegExp _gstRegex = RegExp(
    r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
  );
  static final RegExp _upiRegex = RegExp(r'^[\w.\-]{2,}@[a-zA-Z]{2,}$');
  static final RegExp _uppercaseRegex = RegExp(r'[A-Z]');
  static final RegExp _digitRegex = RegExp(r'[0-9]');

  static String? validatePhone(String? value) {
    final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (!_phoneRegex.hasMatch(digits)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  static String? validateGst(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (!_gstRegex.hasMatch(value.trim())) {
      return 'Invalid GST number format';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    final amount = double.tryParse(value ?? '');
    if (amount == null || amount <= 0) {
      return 'Must be greater than 0';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!_uppercaseRegex.hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!_digitRegex.hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  static String? validateUpi(String? value) {
    if (value == null || !_upiRegex.hasMatch(value.trim())) {
      return 'Enter a valid UPI ID (e.g. name@upi)';
    }
    return null;
  }
}
